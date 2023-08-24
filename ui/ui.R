ui = fluidPage(
  #tags$head(includeHTML(("www/google-analytics.html"))),
  includeCSS("www/styles/style.css"),
  
  dashboardPage(
    skin = "yellow",

    dashboardHeader(
      title = "Monitoramento de ninhos",
      titleWidth = 300,
      disable = FALSE,
      tags$li(class = "dropdown",
              tags$a(href = "https://www.facebook.com/beekeep.life", target="_blank", HTML(paste("<i class='fab fa-facebook-square fa-lg'></i>")))
      ),
      tags$li(class = "dropdown",
              tags$a(href = "https://www.instagram.com/beekeep.life", target="_blank", HTML(paste("<i class='fab fa-instagram fa-lg'></i>")))
      ),
      tags$li(class = "dropdown",
              tags$a(href = "https://www.twitter.com/BeekeepL", target="_blank", HTML(paste("<i class='fab fa-twitter fa-lg'></i>")))
      ),
      tags$li(class = "dropdown",
              tags$a(href = "https://www.youtube.com/channel/UChJe2qL4h1Sr0Q-k4RsWyfQ", target="_blank", HTML(paste("<i class='fab fa-youtube fa-lg'></i>")))
      )
    ),
    
    dashboardSidebar(
      disable = TRUE
    ),
    
    dashboardBody(
      fluidRow(
        column(3,
               HTML(
                 paste0(
                   "<div id='infomations'>",
                   "<br>",
                   "<img style = 'display: block; .clearfix {overflow: auto;' src='images/beekeep.jpeg' width = '110'>",
                   "<br>",
                   "<p>Resultado do protocolo de monitoramento de Ninhos de Abelhas. Para contribuir, acesse: <a href='https://beekeep.pcs.usp.br'>beekeep.pcs.usp.br</a></p>",
                   "</div>"
                   )
                 )
               ),
        column(9, class=c("valuesbox"),
               valueBoxOutput("numberOfFilteredObservations", width = 3),
               valueBoxOutput("numberOfFilteredScientists", width = 3),
               valueBoxOutput("numberOfFilteredBees", width = 3),
               valueBoxOutput("meanOfBees", width = 3),
               valueBoxOutput("rateOfEntranceExit", width = 3),
               valueBoxOutput("numberOfFilteredPolen", width = 3),
               valueBoxOutput("rateOfPolen", width = 3),
               valueBoxOutput("meanOfTemperature", width = 3)
               )
        ),
      
      fluidRow(class=c("colorbox"),
        box(width = 12,
          column(4,
            selectInput("species", "Espécie:", c("Todas", str_sort(unique(as.character(data$species)))), multiple = TRUE),
            sliderInput("temperature",
                        "Temperatura:",
                        min=floor(min(data$temperature)),
                        max=ceiling(max(data$temperature)),
                        value=c(floor(min(data$temperature)), ceiling(max(data$temperature))),
                        step = 0.5),
                    ),
          column(4,
                 selectInput("weather", "Condição do céu:", c("Todas", str_sort(unique(as.character(data$weather))))),
                 selectInput("area", "Área:", c("Todas", unique(as.character(data$area[order(data$area)]))))        ),
          column(4,
                 dateRangeInput("dates", "Período:", start = as.Date("2020-07-23"), end = Sys.Date(), separator = "até", format = "dd-mm-yyyy"),
                 selectInput("nest.type", "Tipo de ninho:", c("Todos", str_sort(unique(as.character(data$nest.type[!is.na(data$nest.type)])))))
          ),
        ),
      ),
        
      fluidRow(
        tabBox(id = "tabset1", width = 12,
          tabPanel("Atividade por horário", plotlyOutput("plot1")),
          tabPanel("Atividade por temperatura", plotlyOutput("plot2")),
          tabPanel("Atividade por condição do céu", plotlyOutput("plot3")),
          tabPanel("Pólen por entrada", plotlyOutput("plot4"))
        )
      ),
        
      fluidRow(
        #box(leafletOutput(outputId = "map"), width = 12)
      )
    )
  )
)
