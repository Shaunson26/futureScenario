library(shiny)
library(shinybusy)
library(dplyr)
library(leaflet)

gnaf <- readRDS('gnaf_test.rds')

# UI ----
ui <- fluidPage(
  tags$style(
    type = "text/css",
    paste(
      "html, body, .container-fluid {width:100%;height:100%}",
      "p {text-align: justify}"
    )
  ),
  selectizeInput('address', label = 'Select address', choices = NULL)

)

# Server ----
server <- function(input, output, session) {
  updateSelectizeInput(session, 'address', choices = c(NA, gnaf$full_address), server = TRUE)
}

# Run app ----
shinyApp(ui = ui, server = server)
