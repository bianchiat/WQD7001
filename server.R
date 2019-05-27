#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(rlang)


# Define server logic required to draw a histogram
function(input, output, session) {

  target_quo = reactive ({
    parse_quosure(input$typeofdisease)
  })
    
 dftable<-  reactive ({
    dff2%>%
      arrange(desc(!!target_quo()))
  })
 
 dfmap<-reactive ({
   dff2%>%
     select(input$typeofdisease)
 })
  
  
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet(geojson) %>% addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                                  attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>')%>%
      addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.5,
                  label = paste(dff$Country, ":", dfmap()[,1]),
                  color = pal(rescale(dfmap()[,1],na.rm=TRUE))
                 
                  
      )%>%
      setView(lng = 0, lat = 40, zoom = 2) %>%
      addLegend("bottomleft",pal = pal, 
               # values =log10(dff2$TB_Death_HIVneg_per100k_pop), opacity = 0.5)
                 values =c(0:1), opacity = 0.5)
  })
  
output$data <- renderTable({
  head((dftable()[, c("Country", input$typeofdisease), drop = FALSE]) ,10)
}, rownames = TRUE)
}
