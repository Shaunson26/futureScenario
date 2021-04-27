library(shiny)
library(dplyr)
library(leaflet)

# Functions ----
find_address <- function(data, number, street, suburb, postcode){
    data %>%
        dplyr::filter(POSTCODE == postcode,
                      LOCALITY_NAME == suburb,
                      STREET_NAME == street,
                      NUMBER_FIRST == number)
}

nsw_bounds <- function(map, flyThere = F){
    # nsw_bbox = c(minX = 140, minY = -40, maxX = 155, maxY = -27)
    if (flyThere) {
        flyToBounds(map = map,
                    lng1 = 140, lng2 = 155,
                    lat1 = -40, lat2 = -27)
    } else {
        fitBounds(map = map,
                  lng1 = 140, lng2 = 155,
                  lat1 = -40, lat2 = -27)
    }
}

unique_input_values <- function(x){
    c(NA, sort(unique(x)))
}

make_input <- function(id, label){
    selectizeInput(inputId = id,
                   label = p(label),
                   choices = NULL,
                   options = list(placeholder = sprintf('type and select a %s',
                                                        tolower(label))
                   )
    )
}

make_button <- function(id, label) {
    actionButton(inputId = id,
                 label = label,
                 style = 'margin: 4px auto; width: 100%;')
}

updateSelectize <- function(session, inputId, choices){
    updateSelectizeInput(session = session, inputId = inputId, choices = choices, server = TRUE,
                         selected = ifelse(length(choices) == 2, choices[2], NA))
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
        street = make_input(id = 'street', label ='Street name'),
        suburb = make_input(id = 'suburb', label ='Suburb name'),
        postcode = make_input(id = 'postcode', label =  'Postcode')
    )


button_list <-
    list(
        search = make_button(id = 'search', label = 'Search address'),
        clear = make_button(id = 'clear', label ='Clear selection')
    )


# UI ----
ui <- fluidPage(
    tags$style(type = "text/css",
               paste("html, body, .container-fluid {width:100%;height:100%}",
                     "p {text-align: justify}")),

    shiny::fluidRow(
        style = 'height: 100%; padding: 16px; background-color: white;',

        shiny::column(
            style = 'height: 100%; padding: 0; background-color: white;',
            width = 3,

            shiny::wellPanel(
                h3('Search an address'),
                p('Units and apartments numbers of disregarded'),
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
            tableOutput('found_address'),
            leafletOutput("address_map", width = "100%", height = "100%"),
        )
    )
)

# Server ----
server <- function(input, output, session) {

    # Initialize drop-downs
    reset_values <- function(session, list){
        for(id in names(list)){
            updateSelectizeInput(session = session, server = TRUE,
                                 inputId = id, choices = list[[id]])
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
    toListen <- reactive({
        list(number = input$number, street = input$street,
             suburb = input$suburb, postcode = input$postcode)
    })

    # On listen event
    observeEvent(toListen(), {

        inputs = toListen()

        gnaf_subset <-
            gnaf %>%
            filter(if (inputs$number == '') T else NUMBER_FIRST == inputs$number,
                   if (inputs$street == '') T else STREET_NAME == inputs$street ,
                   if (inputs$suburb == '') T else LOCALITY_NAME == inputs$suburb ,
                   if (inputs$postcode == '') T else POSTCODE == inputs$postcode)


        if (inputs$number == '') {
            unique_numbers <- unique_input_values(gnaf_subset$NUMBER_FIRST)
            updateSelectize(session = session, inputId = 'number', choices = unique_numbers)

        }

        if (inputs$street == '') {
            unique_streets <- unique_input_values(gnaf_subset$STREET_NAME)
            updateSelectize(session = session, inputId = 'street', choices = unique_streets)
        }

        if (inputs$suburb == '') {
            unique_suburbs <- unique_input_values(gnaf_subset$LOCALITY_NAME)
            updateSelectize(session = session, inputId = 'suburb', choices = unique_suburbs)
        }

        if (inputs$postcode == '') {
            unique_postcode <- unique_input_values(gnaf_subset$POSTCODE)
            updateSelectize(session = session, inputId = 'postcode', choices = unique_postcode)
        }

    })

    observeEvent(input$search, {

        found_address <-
            gnaf %>%
            find_address(number = input$number,
                         street =  input$street,
                         suburb = input$suburb,
                         postcode =  input$postcode)

        # df output
        output$found_address <- renderTable(found_address, width = '100%')

        leaflet
        address_label = with(found_address,
                             paste(NUMBER_FIRST, STREET_NAME,
                                   LOCALITY_NAME, POSTCODE))

        leafletProxy("address_map") %>%
            clearMarkers() %>%
            addMarkers(lng = found_address$LONGITUDE,
                       lat = found_address$LATITUDE,
                       label = address_label) %>%
            flyTo(lng =  found_address$LONGITUDE,
                  lat = found_address$LATITUDE,
                  zoom = 13)

    })

    observeEvent(input$clear, {
        reset_values(session = session, list = unique_list)

        leafletProxy("address_map") %>%
            clearMarkers() %>%
            nsw_bounds(flyThere = T)

    })

}

# Run app ----
shinyApp(ui = ui, server = server)
