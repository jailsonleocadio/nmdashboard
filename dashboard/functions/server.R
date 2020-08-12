server = function(input, output) {
  rv = reactiveValues(dt_species = data)
  
  observeEvent(c(input$species, input$weather, input$area, input$experience, input$temperature), {
    rv$dt_species = data
    
    if (input$species != "Todas") {
      rv$dt_species = rv$dt_species[rv$dt_species$Especie==input$species,]
    }
    
    if (input$weather != "Todas") {
      rv$dt_species = rv$dt_species[rv$dt_species$CondicaoCeu==input$weather,]
    }
    
    if (input$area != "Todas") {
      rv$dt_species = rv$dt_species[rv$dt_species$AreaClass==input$area,]
    }
    
    if (input$experience != "Todas") {
      rv$dt_species = rv$dt_species[rv$dt_species$Experiencia==input$experience,]
    }
    
    rv$dt_species = rv$dt_species[rv$dt_species$Temperatura >= input$temperature[1] & rv$dt_species$Temperatura <= input$temperature[2],]
  })
  
  ###
  
  output$numberOfObservations = renderValueBox({
    valueBox(
      nrow(data),
      "Total de contribuições",
      icon = icon("list"),
      color = "teal"
    )
  })
  
  output$numberOfScientists = renderInfoBox({
    infoBox(
      "Cientistas cidadãos",
      length(unique(data$Email)),
      icon = icon("users"),
      color = "blue",
      fill = FALSE
    )
  })
  
  output$numberOfSpecies = renderInfoBox({
    infoBox(
      "Espécies estudadas",
      length(unique(data$Especie))-1,
      icon = icon("forumbee"),
      color = "yellow",
      fill = FALSE
    )
  })
  
  output$numberOfNests = renderInfoBox({
    infoBox(
      "Ninhos",
      nrow(unique(data.frame(data$Email, data$IdentificadorNinho))),
      icon = icon("forumbee"),
      color = "yellow",
      fill = FALSE
    )
  })
  
  output$numberOfExits = renderInfoBox({
    infoBox(
      "Abelhas saindo do ninho",
      sum(data$Saida),
      icon = icon("forumbee"),
      color = "yellow",
      fill = TRUE
    )
  })
  
  output$numberOfEntries = renderInfoBox({
    infoBox(
      "Abelhas entrando no ninho",
      sum(data$Entrada),
      icon = icon("forumbee"),
      color = "yellow",
      fill = TRUE
    )
  })
  
  output$numberOfPollen = renderInfoBox({
    infoBox(
      "Abelhas com pólen",
      sum(data$Polen),
      icon = icon("forumbee"),
      color = "yellow",
      fill = TRUE
    )
  })
  
  ###
  
  output$numberOfFilteredObservations = renderValueBox({
    valueBox(
      nrow(rv$dt_species),
      "Total de contribuições",
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
      "Abelhas carregando pólen",
      icon = icon("spa"),
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

    model = lm(atividade ~ poly(Temperatura, degree=2), data = rv$dt_species)
    
    x = with(rv$dt_species, seq(min(Temperatura), max(Temperatura), length.out=2000))
    y = predict(model, newdata = data.frame(Temperatura = x))
    
    fig = fig %>%
      add_trace(x = x,
                y = y,
                name = 'Linha de tendência',
                mode = 'lines',
                line = list(color = 'red'))
    
    fig = fig %>%
      layout(xaxis = list(title = "(Temperatura ºC)"),
             yaxis = list (title = "Saídas + entradas"))
  })
  
  output$plot3 = renderPlotly({
    agg = aggregate(rv$dt_species$atividade, by=list(rv$dt_species$CondicaoCeu), mean)
    vt = agg$x
    names(vt) = as.character(agg$Group.1)
    vt = c(vt["Chuva fraca"], vt["Coberto por nuvens de chuva/nublado"], vt["Parcialmente coberto por nuvens"], vt["Céu aberto sem nuvens"])
    
    fig = plot_ly(x = names(vt), y = vt, type = 'bar', name = 'SF Zoo',
                  text = round(vt, 1), textposition = 'auto')
    fig = fig %>%
      layout(yaxis = list(title = 'Média de atividade (saídas + entradas)'))
  })
  
  output$plot4 = renderPlotly({
    agg1 = aggregate(rv$dt_species$Entrada, by=list(rv$dt_species$registro.hora), mean)
    agg2 = aggregate(rv$dt_species$Polen, by=list(rv$dt_species$registro.hora), mean)
    
    fig = plot_ly(x = agg1$Group.1, y = agg1$x, type = 'bar', name = 'Entrada',
                  text = round(agg1$x, 1), textposition = 'auto')
    fig = fig %>% add_trace(y = agg2$x, name = 'Pólen',
                            text = round(agg2$x, 1), textposition = 'auto')
    fig = fig %>%
      layout(yaxis = list(title = 'Média de atividade (saídas + entradas)'))
  })
  
  output$map = renderLeaflet({
    palette = colorFactor(
      palette = c("#66C2A5", "#FC8D62", "#8DA0CB"),
      domain = rv$dt_species$AreaClass
    )
    
    #if (is.null(input$map_bounds)) {
    #  limits = c(33.2, 22.4, -153.1, -42.6)
    #} else {
    #  b = as.numeric(unlist(input$countMap_bounds))
    #  limits = c(b[2], b[1], b[4], b[3])
    #}
    
    leaflet(rv$dt_species) %>%
      #fitBounds(limits[1], limits[2], limits[3], limits[4]) %>%
      #fitBounds(33.2, 22.4, -153.1, -42.6) %>%
      setView(lng = -55, lat = -12, zoom = 3) %>%
      addTiles() %>%
      addCircles(data = rv$dt_species,
                 lat = ~ Latitude_r,
                 lng = ~ Longitude_r,
                 radius = 3000,
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