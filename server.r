library(sf)
library(dplyr)
library(stringr)
library(leaflet)
library(shiny)

birdscapes <- read_sf("data/birdscapes.gpkg") %>% 
  mutate(popup = str_glue("<p><strong>{name}</strong><br>",
                          "<strong>Status</strong>: {status}<br></p>"))

server <- function(input, output, session) {
  
  controls <- . %>% 
    addLayersControl(
      baseGroups = c("Light", "Dark", "Topography", "Satellite"),
      overlayGroups = c("Prioritization", "ABC Birdscapes"),
      options = layersControlOptions(collapsed = FALSE),
      position = "topright")
  
  output$map <- renderLeaflet({
    leaflet(options = leafletOptions(minZoom = 1, maxZoom = 6)) %>%
      addProviderTiles("CartoDB.Positron", group = "Light") %>%
      addProviderTiles("CartoDB.DarkMatter", group = "Dark") %>%
      addProviderTiles("Esri.WorldTopoMap", group = "Topography") %>% 
      addProviderTiles("Esri.WorldImagery", group = "Satellite") %>% 
      addTiles("mig-opt_wk_nc_hf/{z}/{x}/{y}.png",
                layerId = "prioritization",
                group = "Prioritization",
                options = tileOptions(minZoom = 1, maxZoom = 6, 
                                      noWrap = TRUE, tms = TRUE, 
                                      opacity = 1)) %>%
      addPolygons(data = birdscapes, group = "Birdscapes",
                  color = "#4daf4a", weight = 2, opacity = 1,
                  fillColor = "#aaaa", fillOpacity = 0.5,
                  popup = ~ popup,
                  popupOptions = popupOptions(noWrap = TRUE)) %>% 
      setView(lng = -90, lat = 35, zoom = 3) %>%
      controls()
  })
  
  selected_tiles <- eventReactive(input$submit_button, ignoreNULL = FALSE, {
    paste(input$week_year, input$clustering, input$footprint, sep = "_") %>% 
      paste0("mig-opt_", .,"/{z}/{x}/{y}.png")
  })
  
  # update map according to scenario
  observe({
    leafletProxy("map") %>% 
      removeTiles("prioritization") %>% 
      addTiles(selected_tiles(),
               layerId = "prioritization",
               group = "Prioritization",
               options = tileOptions(minZoom = 1, maxZoom = 6, 
                                     noWrap = TRUE, tms = TRUE, 
                                     opacity = 1)) %>%
      controls()
  })
  
  output$legend_container <- renderUI({
    if (input$week_year == "wk") {
      l <- div(class = "text-center", id = "legend")
    } else {
      l <- div(class = "text-center", id = "legend", style = "height:100px")
    }
    return(l)
  })
}