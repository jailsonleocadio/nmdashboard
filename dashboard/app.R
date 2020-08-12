# by Jailson Leocadio
# jailsonleocadio@gmail.com
# Beekeep team (http://beekeep.life)

if (!require(shiny)) {
  install.packages("shiny")
  library(shiny)
}

if (!require(shinydashboard)) {
  install.packages("shinydashboard")
  library(shinydashboard)
}

if (!require(leaflet)) {
  install.packages("leaflet")
  library(leaflet)
}

if (!require(plotly)) {
  install.packages("plotly")
  library(plotly)
}

source("database/database.R")
source("functions/server.R")
source("ui/ui.R")

shinyApp(ui = ui, server = server)
