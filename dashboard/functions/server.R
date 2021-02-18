server = function(input, output) {
  rv = reactiveValues(dt_species = data)
  
  observeEvent(c(input$species, input$temperature, input$weather, input$area, input$dates, input$experience, input$email), {
    rv$dt_species = data
    
    if (!is.null(input$species)) {
      if (!"Todas" %in% input$species) {
        rv$dt_species = rv$dt_species[rv$dt_species$Especie %in% input$species,]
      }
    }
    
    rv$dt_species = rv$dt_species[rv$dt_species$Temperatura >= input$temperature[1] & rv$dt_species$Temperatura <= input$temperature[2],]
    
    if (input$weather != "Todas") {
      rv$dt_species = rv$dt_species[rv$dt_species$CondicaoCeu==input$weather,]
    }
    
    if (input$area != "Todas") {
      rv$dt_species = rv$dt_species[rv$dt_species$AreaClass==input$area,]
    }
    
    rv$dt_species = rv$dt_species[as.Date(rv$dt_species$DataRegistro) >= as.Date(input$dates[1]) & as.Date(rv$dt_species$DataRegistro) <= as.Date(input$dates[2]),]
    
    if (input$experience != "Todas") {
      rv$dt_species = rv$dt_species[rv$dt_species$Experiencia==input$experience,]
    }
  })
  
  ###
  
  output$numberOfFilteredObservations = renderValueBox({
    valueBox(
      nrow(rv$dt_species),
      "Contribuições",
      icon = icon("list"),
      color = "teal"
    )
  })
  
  output$numberOfFilteredScientists = renderValueBox({
    valueBox(
      length(unique(rv$dt_species$Email)),
      "Cientistas cidadãos",
      icon = icon("users"),
      color = "teal",
    )
  })
  
  output$numberOfFilteredBees = renderValueBox({
    valueBox(
      sum(rv$dt_species$Saida + rv$dt_species$Entrada),
      "Abelhas em atividade",
      icon = icon("forumbee"),
      color = "teal",
    )
  })
  
  output$numberOfFilteredPolen = renderValueBox({
    valueBox(
      sum(rv$dt_species$Polen),
      "Com pólen",
      icon = icon("spa"),
      color = "teal",
    )
  })
  
  output$meanOfBees = renderValueBox({
    valueBox(
      round(mean(rv$dt_species$atividade), 1),
      "Média de atividade",
      icon = icon("forumbee"),
      color = "teal",
    )
  })
  
  output$rateOfEntranceExit = renderValueBox({
    valueBox(
      paste(round((sum(rv$dt_species$Entrada)/sum(rv$dt_species$Saida, rv$dt_species$Entrada) * 100), 1), "%"),
      "Entrada/Atividade",
      icon = icon("forumbee"),
      color = "teal",
    )
  })
  
  output$rateOfPolen = renderValueBox({
    valueBox(
      paste(round((sum(rv$dt_species$Polen)/sum(rv$dt_species$Entrada, rv$dt_species$Polen) * 100), 1), "%"),
      "Pólen/Entrada",
      icon = icon("spa"),
      color = "teal",
    )
  })
  
  output$meanOfTemperature = renderValueBox({
    valueBox(
      paste(round(mean(rv$dt_species$Temperatura), 1), " ºC"),
      "Média de temperatura",
      icon = icon("thermometer-three-quarters"),
      color = "teal",
    )
  })
  
  ###
  
  output$plot1 = renderPlotly({
    fig = plot_ly(type = "scatter")
    fig = fig %>%
      add_trace(data = rv$dt_species,
                x = ~registro.hora, y = ~atividade,
                text = ~paste("Espécie: ", Especie, '<br>Saídas: ', Saida, '<br>Entradas: ',
                              Entrada, '<br>Temperatura: ', Temperatura, '<br>Condição do céu: ',
                              CondicaoCeu, '<br>Área: ', AreaClass),
                name = 'Contribuição',
                mode = 'markers',
                marker = list(size = 10,
                              color = '#2c74b4'))
    
    fig = fig %>%
      add_trace(x = aggregate(rv$dt_species$atividade, by=list(rv$dt_species$registro.hora), mean)$Group.1,
                y = aggregate(rv$dt_species$atividade, by=list(rv$dt_species$registro.hora), mean)$x,
                name = 'Média de atividade',
                mode = 'lines',
                line = list(color = 'red'))
    
    fig = fig %>%
      layout(xaxis = list(title = "(Hora)"),
             yaxis = list (title = "Saídas + entradas"))

  })
  
  output$plot2 = renderPlotly({
    fig = plot_ly(type = "scatter")
    fig = fig %>%
      add_trace(data = rv$dt_species,
                x = ~Temperatura, y = ~atividade,
                text = ~paste("Espécie: ", Especie, '<br>Saídas: ', Saida, '<br>Entradas: ',
                              Entrada, '<br>Temperatura: ', Temperatura, '<br>Condição do céu: ',
                              CondicaoCeu, '<br>Área: ', AreaClass),
                name = "Contribuição",
                mode = 'markers',
                marker = list(size = 10,
                              color = '#2c74b4'))
    
    fig = fig %>%
      add_trace(x = aggregate(rv$dt_species$atividade, by=list(floor(rv$dt_species$Temperatura)), mean)$Group.1,
                y = aggregate(rv$dt_species$atividade, by=list(floor(rv$dt_species$Temperatura)), mean)$x,
                name = 'Média de atividade',
                mode = 'lines',
                line = list(color = 'red'))
    
    fig = fig %>%
      layout(xaxis = list(title = "(Temperatura ºC)"),
             yaxis = list (title = "Saídas + entradas"))
  })
  
  output$plot3 = renderPlotly({
    agg = aggregate(rv$dt_species$atividade, by=list(rv$dt_species$CondicaoCeu), mean)
    df = data.frame(agg$Group.1, agg$x)
    df$agg.Group.1 = factor(df$agg.Group.1, levels = df[["agg.Group.1"]])

    fig = plot_ly(data=df, x = ~agg.Group.1, y = ~agg.x, type = 'bar',
                  text = round(df$agg.x, 1), textposition = 'auto')
    fig = fig %>%
      layout(yaxis = list(title = 'Média de atividade (saídas + entradas)'),
             xaxis = list(title = ''))
  })
  
  output$plot4 = renderPlotly({
    agg1 = aggregate(rv$dt_species$Entrada, by=list(rv$dt_species$registro.hora), mean)
    agg2 = aggregate(rv$dt_species$Polen, by=list(rv$dt_species$registro.hora), mean)
    
    fig = plot_ly(x = agg1$Group.1, y = agg1$x, type = 'bar', name = 'Entrada',
                  text = round(agg1$x, 1), textposition = 'auto')
    fig = fig %>% add_trace(y = agg2$x, name = 'Pólen',
                            text = round(agg2$x, 1), textposition = 'auto')
    fig = fig %>%
      layout(yaxis = list(title = 'Média de Entradas'))
  })
  
  output$map = renderLeaflet({
    palette = colorFactor(
      palette = c("#66C2A5", "#FC8D62", "#8DA0CB"),
      domain = rv$dt_species$AreaClass
  )
    
  leaflet(rv$dt_species) %>%
    setView(lng = -55, lat = -12, zoom = 3) %>%
    addTiles() %>%
    addCircles(data = rv$dt_species,
               lat = ~ Latitude_r,
               lng = ~ Longitude_r,
               radius = 10000,
               weight = 10,
               color =  ~palette(AreaClass),
               popup = paste("<b> Espécie:</b> ", rv$dt_species$Especie, "<br/>",
                             "<b> Saídas:</b> ", rv$dt_species$Saida, "<br/>",
                             "<b> Entradas:</b> ", rv$dt_species$Entrada, "<br/>",
                             "<b> Temperatura:</b> ", rv$dt_species$Temperatura, "ºC <br/>",
                             "<b> Condição do céu:</b> ", rv$dt_species$CondicaoCeu, "<br/>",
                             "<b> Área:</b> ", rv$dt_species$AreaClass, "<br/>")) %>%
    addLegend("bottomright", pal = palette, values = ~AreaClass,
              title = "Área",
              opacity = 1
    )
  })
}