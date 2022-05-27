library(shiny)
library(shinybusy)
library(dplyr)
library(leaflet)
library(reactable)
library(htmltools)

# Functions ----
find_address <- function(data, number, street, suburb, postcode) {
  data %>%
    dplyr::filter(
      POSTCODE == as.integer(postcode),
      LOCALITY_NAME == suburb,
      STREET_NAME == street,
      NUMBER_FIRST == as.integer(number)
    )
}

nsw_bounds <- function(map, flyThere = F) {
  # nsw_bbox = c(minX = 140, minY = -40, maxX = 155, maxY = -27)
  if (flyThere) {
    flyToBounds(
      map = map,
      lng1 = 140,
      lng2 = 155,
      lat1 = -40,
      lat2 = -27
    )
  } else {
    fitBounds(
      map = map,
      lng1 = 140,
      lng2 = 155,
      lat1 = -40,
      lat2 = -27
    )
  }
}

unique_input_values <- function(x) {
  c(NA, sort(unique(x)))
}

make_input <- function(id, label) {
  selectizeInput(
    inputId = id,
    label = p(label),
    choices = NULL,
    options = list(placeholder = sprintf('type and select a %s',
                                         tolower(label)))
  )
}

make_button <- function(id, label) {
  actionButton(inputId = id,
               label = label,
               style = 'margin: 4px auto; width: 100%;')
}

updateSelectize <- function(session, inputId, choices) {
  updateSelectizeInput(
    session = session,
    inputId = inputId,
    choices = choices,
    server = TRUE,
    selected = ifelse(length(choices) == 2, choices[2], NA)
  )
}


# Data prep ----
unique_list <-
  list(
    number = unique_input_values(gnaf$NUMBER_FIRST),
    street = unique_input_values(gnaf$STREET_NAME),
    suburb = unique_input_values(gnaf$LOCALITY_NAME),
    postcode = unique_input_values(gnaf$POSTCODE)
  )



# Widgets ----
input_list <-
  list(
    number = make_input(id = 'number', label = 'Street number'),
    street = make_input(id = 'street', label = 'Street name'),
    suburb = make_input(id = 'suburb', label = 'Suburb name'),
    postcode = make_input(id = 'postcode', label =  'Postcode')
  )


button_list <-
  list(
    search = make_button(id = 'search', label = 'Get data'),
    clear = make_button(id = 'clear', label = 'Clear selection')
  )

blackMarker <-
  leaflet::icons(
    iconUrl = 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-black.png',
    shadowUrl = 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
    iconWidth= 25,
    iconHeight = 41,
    iconAnchorX = 12,
    iconAnchorY = 41,
    shadowAnchorX = 1,
    shadowAnchorY = -34,
    shadowWidth = 41,
    shadowHeight = 41
  )


# UI ----
ui <- fluidPage(
  tags$style(
    type = "text/css",
    paste(
      "html, body, .container-fluid {width:100%;height:100%}",
      "p {text-align: justify}"
    )
  ),

  #shinybusy::add_busy_spinner(spin = "fading-circle", position = 'top-right'),

  shiny::fluidRow(
    style = 'height: 100%; padding: 16px; background-color: white;',

    shiny::column(
      style = 'height: 100%; padding: 0; background-color: white;',
      width = 3,

      shiny::wellPanel(
        h3('Obtain data for an address'),
        p('Only street number is required, unit and apartment numbers are disregarded.'),
        input_list$number,
        input_list$street,
        input_list$suburb,
        input_list$postcode,
        button_list$search,
        button_list$clear
      )
    ),

    shiny::column(
      style = 'height: 100%; padding: 0; padding-left: 8px;',
      width = 9,
      id = 'column-main',
      leafletOutput("address_map", width = "100%", height = "300px")
    )
  )
)

# Server ----
server <- function(input, output, session) {

  # Initialize drop-downs
  reset_values <- function(session, list) {
    for (id in names(list)) {
      updateSelectizeInput(
        session = session,
        server = TRUE,
        inputId = id,
        choices = list[[id]]
      )
    }
  }

  reset_values(session = session, list = unique_list)

  # Initialize map
  output$address_map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)) %>%
      nsw_bounds(flyThere = T)
  })

  # Listen for selections
  selection_listeners <- reactive({
    list(
      number = input$number,
      street = input$street,
      suburb = input$suburb,
      postcode = input$postcode
    )
  })

  triggerSelectionUpdate = reactiveVal(Sys.time())

  observeEvent(selection_listeners(),
               ignoreInit = TRUE,
               handlerExpr =  {

                 inputs <- unlist(selection_listeners())
                 sum_inputs <- sum(inputs == '')

                 if (sum_inputs == 3) {
                   print('trigger initial search')
                   triggerSelectionUpdate(Sys.time())
                 } else if (sum_inputs > 0 & sum_inputs < 3) {
                   print('trigger subset search')
                   triggerSelectionUpdate(Sys.time())
                 } else {
                   print('we happy with selection!')
                 }
               })

  gnaf_subset <-
    eventReactive(triggerSelectionUpdate(),
                  ignoreInit = TRUE,
                  valueExpr =  {

                    print('filtering GNAF')

                    inputs = selection_listeners()

                    gnaf %>%
                      filter(
                        if (inputs$number == '')
                          T
                        else
                          NUMBER_FIRST == as.integer(inputs$number),
                        if (inputs$street == '')
                          T
                        else
                          STREET_NAME == inputs$street ,
                        if (inputs$suburb == '')
                          T
                        else
                          LOCALITY_NAME == inputs$suburb ,
                        if (inputs$postcode == '')
                          T
                        else
                          POSTCODE == as.integer(inputs$postcode)
                      )


                  })

  observeEvent(gnaf_subset(), {

    print('filtering GNAF done')

    inputs = selection_listeners()

    if (inputs$number == '') {
      unique_numbers <- unique_input_values(gnaf_subset()$NUMBER_FIRST)
      updateSelectize(session = session,
                      inputId = 'number',
                      choices = unique_numbers)

    }

    if (inputs$street == '') {
      unique_streets <- unique_input_values(gnaf_subset()$STREET_NAME)
      updateSelectize(session = session,
                      inputId = 'street',
                      choices = unique_streets)
    }

    if (inputs$suburb == '') {
      unique_suburbs <- unique_input_values(gnaf_subset()$LOCALITY_NAME)
      updateSelectize(session = session,
                      inputId = 'suburb',
                      choices = unique_suburbs)
    }

    if (inputs$postcode == '') {
      unique_postcode <- unique_input_values(gnaf_subset()$POSTCODE)
      updateSelectize(session = session,
                      inputId = 'postcode',
                      choices = unique_postcode)
    }

  })



  triggerDataPipeline = reactiveVal(Sys.time())

  observeEvent(input$search, {

    inputs <- unlist(selection_listeners())

    if (any(inputs == '')) {
      modalDialog(title = 'Error',
                  tags$p('Please complete all address fields'),
                  size = 's') %>%
        showModal()
    } else {
      triggerDataPipeline(Sys.time())
    }
  })

  observeEvent(triggerDataPipeline(),
               ignoreInit = TRUE,
               handlerExpr = {

                 found_address <-
                   gnaf_subset() %>%
                   find_address(number = input$number,
                                street = input$street,
                                suburb = input$suburb,
                                postcode = input$postcode) %>%
                   join_sa1()

                 # df output
                 # insertUI(selector = '#column-main', where = 'beforeEnd',
                 #          ui = tableOutput('found_address'))
                 #
                 # output$found_address <-
                 #   renderTable(found_address, width = '100%')

                 address_label = with(found_address,
                                      paste(NUMBER_FIRST, STREET_NAME,
                                            LOCALITY_NAME, POSTCODE))

                 leafletProxy("address_map") %>%
                   clearMarkers() %>%
                   addMarkers(
                     lng = found_address$LONGITUDE,
                     lat = found_address$LATITUDE,
                     label = address_label,
                     icon = blackMarker
                   ) %>%
                   flyTo(lng =  found_address$LONGITUDE,
                         lat = found_address$LATITUDE,
                         zoom = 14)

                 shinybusy::show_modal_spinner(text = 'Downloading data from APIs')

                 print('Getting UHI')

                 uhi_resp <-
                   found_address %>%
                   dplyr::pull(MB_2016_CODE) %>%
                   get_urban_heat_island_value() %>%
                   map_urban_heat_island_value()

                 print('Getting UVI')

                 hvi_resp <-
                   found_address %>%
                   pull(SA1_MAINCODE_2016) %>%
                   get_heat_vulnerability_index() %>%
                   map_heat_vulnerability_index()

                 print('Getting UVCA')

                 uvca_resp <-
                   found_address %>%
                   dplyr::pull(MB_2016_CODE) %>%
                   get_urban_vegetation_cover_all() %>%
                   map_urban_vegetation_cover_all()

                 shinybusy::remove_modal_spinner()

                 insertUI(selector = '#column-main', where = 'beforeEnd',
                          ui = tags$div(
                            id = 'uhi-container',
                            h4('Urban Heat Island'),
                            reactableOutput('uhi_results'),
                            hr()
                          )
                 )

                 output$uhi_results <- renderReactable({

                   uhi_resp %>%
                     select(label, value_text, value) %>%
                     mutate(bar = value) %>%
                     reactable::reactable(
                       columns = list(
                         label = colDef(name = 'Measure'),
                         value_text = colDef(name = 'Value category', maxWidth = 160),
                         value = colDef(
                           name = 'Value',
                           maxWidth = 110,
                           align = 'right',
                           cell = function(value){
                             if (is.numeric(value)) {
                               return(paste(round(value, 2), '°C'))
                             }
                             value
                           }
                         ),
                         bar = colDef(
                           name = '',
                           align = 'left',
                           cell = function(value) {

                             redColorRamp <-
                               colorRamp(RColorBrewer::brewer.pal(9, 'Reds'))

                             if (is.numeric(value)) {

                               value_max = ifelse(value > 9, 9,  value)
                               background_colour <- rgb(redColorRamp(value_max/9), maxColorValue=255)
                               width <- paste0(value_max/9 * 100, "%")

                             } else {

                               background_colour <- rgb(redColorRamp(0/9), maxColorValue=255)
                               width <- paste0(0, "%")

                             }

                             bar <-
                               div(style=list(width = width,
                                              backgroundColor = background_colour))

                             div(style='width:100%;height:1em;display:flex;', bar)

                           }
                         )
                       ))
                 })

                 insertUI(selector = '#column-main', where = 'beforeEnd',
                          ui = tags$div(
                            id = 'hvi-container',
                            h4('Heat vulnerability index'),
                            reactableOutput('hvi_results'),
                            hr()
                          )
                 )

                 output$hvi_results <- renderReactable({

                   hvi_resp %>%
                     select(label, value_text, value) %>%
                     mutate(bar = value) %>%
                     reactable::reactable(
                       columns = list(
                         label = colDef(name = 'Index'),
                         value_text = colDef(name = 'Index category', maxWidth = 160),
                         value = colDef(
                           name = 'Value',
                           maxWidth = 110,
                           align = 'right'),
                         bar = colDef(
                           name = '',
                           align = 'left',
                           cell = function(value, i) {

                             colours <- rev(c('#d7191c','#fdae61','#ffffbf','#abd9e9','#2c7bb6'))

                             width <- paste0(value * 100 / 5, "%")

                             background_colour <-
                               ifelse(grepl('Adaptive', hvi_resp$label[i]),
                                      rev(colours)[value],
                                      colours[value])

                             bar <-
                               div(style= list(width = width,
                                               backgroundColor = background_colour))

                             div(style='width:100%;height:1em;display:flex;', bar)
                           }
                         )
                       )
                     )
                 })

                 insertUI(selector = '#column-main', where = 'beforeEnd',
                          ui = tags$div(
                            id = 'uvca-container',
                            h4('Urban vegetation cover'),
                            reactableOutput('uvca_results'),
                            hr()
                          )
                 )

                 output$uvca_results <- renderReactable({

                   uvca_resp %>%
                     select(label, value_text, value) %>%
                     mutate(bar = value) %>%
                     reactable::reactable(
                       columns = list(
                         label = colDef(name = 'Vegetation type'),
                         value_text = colDef(name = 'Value category', maxWidth = 160),
                         value = colDef(
                           name = 'Percent cover',
                           maxWidth = 110,
                           align = 'right',
                           cell = function(value){
                             if (is.numeric(value)) {
                               return(paste(round(value, 2), '%'))
                             }
                             value
                           }
                         ),
                         bar = colDef(
                           name = '',
                           align = 'left',
                           cell = function(value) {

                             greenColorRamp <-
                               colorRamp(RColorBrewer::brewer.pal(9, 'Greens'))

                             if (is.numeric(value)) {

                               background_colour <- rgb(greenColorRamp(value/100), maxColorValue=255)
                               width <- paste0(value, "%")

                             } else {

                               background_colour <- rgb(greenColorRamp(0/100), maxColorValue=255)
                               width <- paste0(0, "%")

                             }

                             bar <-
                               div(style=list(width = width,
                                              backgroundColor = background_colour))

                             div(style='width:100%;height:1em;display:flex;', bar)


                           }
                         )
                       ))
                 })


               })



  observeEvent(input$clear, {

    reset_values(session = session, list = unique_list)

    leafletProxy("address_map") %>%
      clearMarkers() %>%
      nsw_bounds(flyThere = T)

    #removeUI('#found_address')
    removeUI('#uhi-container')
    removeUI('#hvi-container')
    removeUI('#uvca-container')

  })

}

# Run app ----
shinyApp(ui = ui, server = server)
