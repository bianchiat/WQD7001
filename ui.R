#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(jsonlite)
library(geojsonio)
library(dplyr) 
library(leaflet)
library(shiny)
library(RColorBrewer)
library(scales)
library(lattice)
library(DT)

vars <- names(dff2)
vars <-vars[-1:-4]


# Define UI for application that draws a histogram
navbarPage("TB", id="nav",
           
           tabPanel("Interactive Map",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        
                        # If not using custom CSS, set height of leafletOutput to a number instead of percent
                        
                        leafletOutput("map", width="80%", height="100%"),
                        
                        
                        
                        # Shiny versions prior to 0.11 should use class = "modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = FALSE, top = 55, left = "auto", right = 10, bottom = "auto",
                                      width = 400, height = "100%",
                                      
                                      h2("2016 TB Data Explorer"),
                                      
                                      selectInput("typeofdisease", "Select the type of disease", vars),
                                      
                                      #dataTableOutput(outputId="data")
                                      
                                     tableOutput("data")
                        ))))