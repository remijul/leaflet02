#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(magrittr)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Leaflet is awesome"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(

    sidebarPanel(
      sliderInput("slider", label="Zoom for map", min=1, max=20, value=8)
    ),
    # Show a plot of the generated distribution
    mainPanel(
      leaflet::leafletOutput("plot", height = "600px", width = "100%")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  output$plot <- leaflet::renderLeaflet({
    leaflet::leaflet() %>%
      leaflet::addTiles(urlTemplate = "http://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&s=Ga", attribution = "Map data ©2019 Google", group = "Google Map") %>%
      leaflet::addProviderTiles("OpenStreetMap.Mapnik", group = "OSM World Map") %>%
      leaflet::addProviderTiles("OpenStreetMap.France", group = "OSM France Map") %>%
      leaflet::addProviderTiles("Esri.WorldTopoMap", group = "ESRI World Topo Map") %>%
      leaflet::addProviderTiles("Esri.WorldImagery", group = "ESRI World Imagery") %>%
      leaflet::addLayersControl(
        baseGroups = c("Google Map", "OSM World Map", "OSM France Map", "ESRI World Topo Map", "ESRI World Imagery"),
        position = "topright",
        options = leaflet::layersControlOptions(collapsed = TRUE)
      ) %>%
      leaflet::setView(lng = 1.6806699, lat = 47.5004721, zoom = input$slider) %>%
      leaflet::addControl(layerId = "mapInfo", shinyWidgets::actionBttn(inputId = "mapBtnInfo", label = "Info", color = "danger", size = "xs", style = "jelly"), position="bottomright") %>%
      # leaflet::addControl(shinyWidgets::actionBttn(inputId = "mapInfo", label = "", color = "danger", icon = icon("info-circle", class="fa-2x"), size = "xs", style = "material-circle"), position="bottomright") %>%
      # leaflet::addControl(actionButton(inputId = "mapInfo", label="", icon = icon("info-circle", class="fa-2x"), style="justify-content: center; margin: auto; display:block; text-align: center; height: 35px; width: 35px; color: red; background-color: transparent; border-color: white; border-radius: 50%;"), position="bottomright") %>%
      leaflet::addControl(HTML('<a href="http://www.dcid-consulting.fr/" target="_blank">Source : dcid-consulting.fr</a>'), position = "bottomleft", "map-title")
    # leaflet::removeControl(layerId = "mapInfo")
  })
  
  
  # Affichage d'une fenetre modal (information previsions) sur l'evenement clik bouton "mapInfo"
  observeEvent(input$mapBtnInfo, {
    showModal(modalDialog(
      title = "Information on map",
      div(h5("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
      ),
      footer = modalButton("OK"),
      easyClose = TRUE
    ))
  })

}

# Run the application 
shinyApp(ui = ui, server = server)
