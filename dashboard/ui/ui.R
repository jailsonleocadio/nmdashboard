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
        column(4,
               HTML(
                 paste0(
                   "<br>",
                   "<img style = 'display: block;' src='images/beekeep.jpeg' width = '100'>",
                   "<br>",
                   "<p style = 'text-align: center;'><small>Nest Monitoring Dashboard</small></p>",
                   "<br>"
                   )
                 )
               ),
        column(8, class=c("valuesbox"),
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
        box(width = 8,
          column(4,
            selectInput("species", "Espécie:", c("Todas", unique(as.character(data$Especie[order(data$Especie)]))), multiple = TRUE),
            sliderInput("temperature",
                        "Temperatura:",
                        min=floor(min(data$Temperatura)),
                        max=ceiling(max(data$Temperatura)),
                        value=c(floor(min(data$Temperatura)), ceiling(max(data$Temperatura))),
                        step = 0.5),
                    ),
          column(4,
                 selectInput("weather", "Condição do céu:", c("Todas", unique(as.character(data$CondicaoCeu[order(data$CondicaoCeu)])))),
                 selectInput("area", "Área:", c("Todas", unique(as.character(data$AreaClass[order(data$AreaClass)]))))        ),
          column(4,
                 dateRangeInput("dates", "Período:", start = as.Date("2020-07-23"), end = Sys.Date(), separator = "até", format = "dd-mm-yyyy"),
                 selectInput("experience", "Experiência:", c("Todas", unique(as.character(data$Experiencia[order(data$Experiencia)]))))
          ),
        ),
        box(width = 4,
          column(12,
               textInput("email", "Para ver as suas contribuições em destaque, digite o seu e-mail abaixo:")
          )
        )
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
        box(leafletOutput(outputId = "map"), width = 12)
      ),
      
      fluidRow(
        column(4,
               
        )
      ),
      
      fluidRow(
        div(actionButton("about", "Sobre"), style = "text-align: center")
      )
    )
  )
)
