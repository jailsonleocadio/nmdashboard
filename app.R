# by Jailson Leocadio
# jailsonleocadio@gmail.com
# Beekeep team (http://beekeep.life)


library(shiny)
library(shinydashboard)
#library(leaflet)
library(plotly)

library(stringr)

source("database/database.R")
source("ui/ui.R")
source("functions/server.R")

shinyApp(ui = ui, server = server)
