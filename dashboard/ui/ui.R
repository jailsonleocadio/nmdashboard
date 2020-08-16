ui = fluidPage(
  #tags$head(includeHTML(("www/google-analytics.html"))),
  includeCSS("www/styles/style.css"),
    
  tags$style(type = "text/css",
    ".shiny-output-error { visibility: hidden; }",
    ".shiny-output-error:before { visibility: hidden; }"
  ),
  
  dashboardPage(
    skin = "yellow",

    dashboardHeader(
      title = "Monitoramento de ninhos",
      titleWidth = 300,
      disable = FALSE
    ),
    
    dashboardSidebar(
      disable = TRUE
    ),
    
    dashboardBody(
      fluidRow(
        valueBoxOutput("numberOfFilteredObservations", width = 2),
        valueBoxOutput("numberOfFilteredScientists", width = 2),
        valueBoxOutput("numberOfFilteredBees", width = 2),
        valueBoxOutput("meanOfBees", width = 2),
        valueBoxOutput("numberOfFilteredPolen", width = 2),
        valueBoxOutput("rateOfPolen", width = 2),
      ),
      
      fluidRow(class=c(""),
        box(width = 3,
          selectInput("species", "Espécie:", c("Todas", unique(as.character(data$Especie[order(data$Especie)])))),
        ),
        box(width = 3,
            sliderInput("temperature",
                        "Temperatura:",
                        min=floor(min(data$Temperatura)),
                        max=ceiling(max(data$Temperatura)),
                        value=c(floor(min(data$Temperatura)), ceiling(max(data$Temperatura))),
                        step = 0.5)),
        box(width = 3,
            selectInput("weather", "Condição do céu:", c("Todas", unique(as.character(data$CondicaoCeu[order(data$CondicaoCeu)]))))
        ),
        box(width = 3,
            selectInput("area", "Área:", c("Todas", unique(as.character(data$AreaClass[order(data$AreaClass)]))))
        ),
        box(width = 3,
            selectInput("experience", "Experiência:", c("Todas", unique(as.character(data$Experiencia[order(data$Experiencia)]))))
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
        box(leafletOutput(outputId = "map"), width = 12)
      )
    )
  )
)
