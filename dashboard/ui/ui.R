ui = fluidPage(
  
  includeCSS("www/styles/style.css"),
    
  tags$style(type = "text/css",
    ".shiny-output-error { visibility: hidden; }",
    ".shiny-output-error:before { visibility: hidden; }"
  ),
  
  dashboardPage(
    skin = "yellow",

    dashboardHeader(
      title = "NM Dashboard",
      titleWidth = 300,
      disable = FALSE
    ),
    
    dashboardSidebar(
      width = 300,

      sidebarMenu(
        HTML(
          paste0(
            "<br>",
            "<img style = 'display: block; margin-left: auto; margin-right: auto;' src='images/beekeep.jpeg' width = '186'>",
            "<br>",
            "<p style = 'text-align: center;'><small>Nest Monitoring Dashboard</small></p>",
            "<br>"
          )
        ),
        
        menuItem("Início", tabName = "home", icon = icon("home")),
        menuItem("Gráficos", tabName = "charts", icon = icon("chart-pie")),
        menuItem("Sobre", tabName = "about", icon = icon("info-circle")),
        
        HTML(
          paste0(
            "<table style='margin-top:260px; margin-left:auto; margin-right:auto;'>",
              "<tr>",
                "<td style='padding: 5px;'><a href='https://www.facebook.com/beekeep.life' target='_blank'><i class='fab fa-facebook-square fa-lg'></i></a></td>",
                "<td style='padding: 5px;'><a href='https://www.instagram.com/beekeep.life' target='_blank'><i class='fab fa-instagram fa-lg'></i></a></td>",
                "<td style='padding: 5px;'><a href='https://www.twitter.com/BeekeepL' target='_blank'><i class='fab fa-twitter fa-lg'></i></a></td>",
                "<td style='padding: 5px;'><a href='https://www.youtube.com/UChJe2qL4h1Sr0Q-k4RsWyfQ' target='_blank'><i class='fab fa-youtube fa-lg'></i></a></td>",
              "</tr>",
            "</table>",
            "<br>"
          ),
        
          paste0(
            "<script>",
              "var today = new Date();",
              "var yyyy = today.getFullYear();",
            "</script>",
            "<p style = 'text-align: center;'><small>&copy; <a href='http://beekeep.life' target='_blank'>BeeKeep team</a> - <script>document.write(yyyy);</script></small></p>"
          )
        )
      )
    ),
    
    dashboardBody(
      tabItems(
        tabItem(tabName = "home",
          fluidRow(
            valueBoxOutput("numberOfObservations", width = 4)
          ),
          
          fluidRow(
            infoBoxOutput("numberOfScientists")
          ),
          
          fluidRow(
            infoBoxOutput("numberOfSpecies"),
            infoBoxOutput("numberOfNests")
          ),
          
          fluidRow(
            infoBoxOutput("numberOfExits"),
            infoBoxOutput("numberOfEntries"),
            infoBoxOutput("numberOfPollen")
          )
        ),
        
        tabItem(tabName = "charts",
          fluidRow(class=c(""),
            box(width = 6,
              selectInput("species", "Espécie:", c("Todas", unique(as.character(data$Especie[order(data$Especie)])))),
              sliderInput("temperature",
                          "Temperatura:",
                          min=floor(min(data$Temperatura)),
                          max=ceiling(max(data$Temperatura)),
                          value=c(floor(min(data$Temperatura)), ceiling(max(data$Temperatura))),
                          step = 0.5),
              selectInput("weather", "Condição do céu:", c("Todas", unique(as.character(data$CondicaoCeu[order(data$CondicaoCeu)])))),
              selectInput("area", "Área:", c("Todas", unique(as.character(data$AreaClass[order(data$AreaClass)]))))
            ),

            valueBoxOutput("numberOfFilteredObservations", width = 6),
            valueBoxOutput("numberOfFilteredScientists", width = 6),
            valueBoxOutput("numberOfFilteredBees", width = 6)
          ),
          
          fluidRow(
            box(
              selectInput("experience", "Experiência:", c("Todas", unique(as.character(data$Experiencia[order(data$Experiencia)]))))
            ),
            
            valueBoxOutput("numberOfFilteredPolen", width = 6)
          ),
          
          fluidRow(
            tabBox(id = "tabset1", width = 12,
              tabPanel("Atividade por horário", plotOutput("plot1")),
              tabPanel("Atividade por temperatura", plotOutput("plot2")),
              tabPanel("Atividade por condição do céu", plotOutput("plot3")),
              tabPanel("Pólen por entrada", plotOutput("plot4"))
            )
          ),
          
          fluidRow(
            box(leafletOutput(outputId = "map"), width = 12)
          )
        ),
        
        tabItem(tabName = "about",
          fluidRow(
            box(includeMarkdown("ui/about.md"), width = 12)
          )
        )
      )
    )
  )
)
