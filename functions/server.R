server = function(input, output) {
  rv = reactiveValues(data = data)
  
  observeEvent(c(input$species, input$temperature, input$weather, input$area, input$dates, input$nest.type), {
    rv$data = data
    
    if (!is.null(input$species)) {
      if (!"Todas" %in% input$species) {
        rv$data = rv$data[rv$data$species %in% input$species,]
      }
    }
    
    rv$data = rv$data[rv$data$temperature >= input$temperature[1] & rv$data$temperature <= input$temperature[2],]
    
    if (input$weather != "Todas") {
      rv$data = rv$data[rv$data$weather == input$weather,]
    }
    
    if (input$area != "Todas") {
      rv$data = rv$data[rv$data$area==input$area,]
    }
    
    rv$data = rv$data[as.Date(rv$data$date.observation) >= as.Date(input$dates[1]) & as.Date(rv$data$date.observation) <= as.Date(input$dates[2]),]
    
    if (input$nest.type != "Todos") {
      rv$data = rv$data[rv$data$nest.type == input$nest.type & !is.na(rv$data$nest.type),]
    }
  })
  
  ###
  
  output$numberOfFilteredObservations = renderValueBox({
    valueBox(
      nrow(rv$data),
      "Contribuições",
      icon = icon("list"),
      color = "teal"
    )
  })
  
  output$numberOfFilteredScientists = renderValueBox({
    valueBox(
      length(unique(rv$data$email)),
      "Cientistas cidadãos",
      icon = icon("users"),
      color = "teal",
    )
  })
  
  output$numberOfFilteredBees = renderValueBox({
    valueBox(
      sum(rv$data$exit + rv$data$entrance),
      "Abelhas em atividade",
      icon = icon("forumbee"),
      color = "teal",
    )
  })
  
  output$numberOfFilteredPolen = renderValueBox({
    valueBox(
      sum(rv$data[rv$data$invalid.pollen==FALSE, c('pollen')]),
      "Com pólen",
      icon = icon("spa"),
      color = "teal",
    )
  })
  
  output$meanOfBees = renderValueBox({
    valueBox(
      round(mean(rv$data$activity), 1),
      "Média de atividade",
      icon = icon("forumbee"),
      color = "teal",
    )
  })
  
  output$rateOfEntranceExit = renderValueBox({
    valueBox(
      paste(round((sum(rv$data$entrance)/sum(rv$data$exit, rv$data$entrance) * 100), 1), "%"),
      "Entrada/Atividade",
      icon = icon("forumbee"),
      color = "teal",
    )
  })
  
  output$rateOfPolen = renderValueBox({
    valueBox(
      paste(round((sum(rv$data[rv$data$invalid.pollen==FALSE, c('pollen')])/sum(rv$data$entrance, rv$data[rv$data$invalid.pollen==FALSE, c('pollen')]) * 100), 1), "%"),
      "Pólen/Entrada",
      icon = icon("spa"),
      color = "teal",
    )
  })
  
  output$meanOfTemperature = renderValueBox({
    valueBox(
      paste(round(mean(rv$data$temperature), 1), " ºC"),
      "Média de temperatura",
      icon = icon("thermometer-three-quarters"),
      color = "teal",
    )
  })
  
  ###
  
  output$plot1 = renderPlotly({
    fig = plot_ly(type = "scatter")
    fig = fig %>%
      add_trace(data = rv$data,
                x = ~hour.observation, y = ~activity,
                text = ~paste("Espécie: ", species, '<br>Saídas: ', exit, '<br>Entradas: ',
                              entrance, '<br>Temperatura: ', temperature, '<br>Condição do céu: ',
                              weather, '<br>Área: ', area),
                name = 'Contribuição',
                mode = 'markers',
                marker = list(size = 10,
                              color = '#2c74b4'))
    
    fig = fig %>%
      add_trace(x = aggregate(rv$data$activity, by=list(rv$data$hour.observation), mean)$Group.1,
                y = aggregate(rv$data$activity, by=list(rv$data$hour.observation), mean)$x,
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
      add_trace(data = rv$data,
                x = ~temperature, y = ~activity,
                text = ~paste("Espécie: ", species, '<br>Saídas: ', exit, '<br>Entradas: ',
                              entrance, '<br>Temperatura: ', temperature, '<br>Condição do céu: ',
                              weather, '<br>Área: ', area),
                name = "Contribuição",
                mode = 'markers',
                marker = list(size = 10,
                              color = '#2c74b4'))
    
    fig = fig %>%
      add_trace(x = aggregate(rv$data$activity, by=list(floor(rv$data$temperature)), mean)$Group.1,
                y = aggregate(rv$data$activity, by=list(floor(rv$data$temperature)), mean)$x,
                name = 'Média de atividade',
                mode = 'lines',
                line = list(color = 'red'))
    
    fig = fig %>%
      layout(xaxis = list(title = "(Temperatura ºC)"),
             yaxis = list (title = "Saídas + entradas"))
  })
  
  output$plot3 = renderPlotly({
    agg = aggregate(rv$data$activity, by=list(rv$data$weather), mean)
    df = data.frame(agg$Group.1, agg$x)
    df$agg.Group.1 = factor(df$agg.Group.1, levels = df[["agg.Group.1"]])

    fig = plot_ly(data=df, x = ~agg.Group.1, y = ~agg.x, type = 'bar',
                  text = round(df$agg.x, 1), textposition = 'auto')
    fig = fig %>%
      layout(yaxis = list(title = 'Média de atividade (saídas + entradas)'),
             xaxis = list(title = ''))
  })
  
  output$plot4 = renderPlotly({
    agg1 = aggregate(rv$data[rv$data$invalid.pollen==FALSE, c('entrance')], by=list(rv$data[rv$data$invalid.pollen==FALSE, c('hour.observation')]), mean)
    agg2 = aggregate(rv$data[rv$data$invalid.pollen==FALSE, c('pollen')], by=list(rv$data[rv$data$invalid.pollen==FALSE, c('hour.observation')]), mean)
    
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
      domain = rv$data$area
  )
    
  leaflet(rv$data) %>%
    setView(lng = -55, lat = -12, zoom = 3) %>%
    addTiles() %>%
    addCircles(data = rv$data,
               lat = ~ random.latitude,
               lng = ~ random.longitude,
               radius = 10000,
               weight = 10,
               color =  ~palette(area),
               popup = paste("<b> Espécie:</b> ", rv$data$species, "<br/>",
                             "<b> Saídas:</b> ", rv$data$exit, "<br/>",
                             "<b> Entradas:</b> ", rv$data$entrance, "<br/>",
                             "<b> Temperatura:</b> ", rv$data$temperature, "ºC <br/>",
                             "<b> Condição do céu:</b> ", rv$data$weather, "<br/>",
                             "<b> Área:</b> ", rv$data$area, "<br/>")) %>%
    addLegend("bottomright", pal = palette, values = ~area,
              title = "Área",
              opacity = 1
    )
  })
}