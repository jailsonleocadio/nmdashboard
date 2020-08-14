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

if (!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
}

if (!require(devtools)) {
  install.packages("devtools")
  library(devtools)
}

if (!require(plotly)) {
  devtools::install_github("ropensci/plotly")
  library(plotly)
}

source("database/database.R")
source("functions/server.R")
source("ui/ui.R")

shinyApp(ui = ui, server = server)
