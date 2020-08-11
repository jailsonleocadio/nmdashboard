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
  
  ###
  
  output$plot1 = renderPlot({
    plot(rv$dt_species$registro.hora,
         rv$dt_species$atividade,
         pch=16,
         xlab = "(Hora)",
         ylab = "Saídas + entradas",
         main = "Atividade das abelhas por horário"
    )
    
    legend(min(rv$dt_species$registro.hora), max(rv$dt_species$atividade), legend=c("Média de atividade"), col=c("red"), lty=1, cex=1, lwd=4)
    lines(aggregate(rv$dt_species$atividade, by=list(rv$dt_species$registro.hora), mean), col="red", lwd=4)
  })
  
  output$plot2 = renderPlot({
    plot(rv$dt_species$Temperatura,
         rv$dt_species$atividade,
         pch=16,
         xlab = "(Temperatura ºC)",
         ylab = "Saídas + entradas",
         main = "Atividade das abelhas por temperatura"
    )
    
    model = lm(atividade ~ poly(Temperatura, degree=1), data = rv$dt_species)
    
    x = with(rv$dt_species, seq(min(Temperatura), max(Temperatura), length.out=2000))
    y = predict(model, newdata = data.frame(Temperatura = x))
    
    lines(x, y, col = "red", lwd=4)
    legend(min(rv$dt_species$Temperatura), max(rv$dt_species$atividade), legend=c("Linha de tendência"), col=c("red"), lty=1, cex=1, lwd=4)
  })
  
  output$plot3 = renderPlot({
    agg = aggregate(rv$dt_species$atividade, by=list(rv$dt_species$CondicaoCeu), mean)
    vt = agg$x
    names(vt) = as.character(agg$Group.1)
    vt = c(vt["Chuva fraca"], vt["Coberto por nuvens de chuva/nublado"], vt["Parcialmente coberto por nuvens"], vt["Céu aberto sem nuvens"])
    
    plot = barplot(vt,
            col = "#75AADB",
            border = "white",
            xlab = "Condição do céu",
            ylab = "Média de atividade (entrada + saída)",
            ylim=c(0, (ceiling(max(vt)) + 1)),
            main = "Atividade das abelhas por condição do céu"
    )
    
    text(x=plot, y=vt, labels=as.character(round(vt, 1)), pos=3)
  })
  
  output$plot4 = renderPlot({
    agg1 = aggregate(rv$dt_species$Entrada, by=list(rv$dt_species$registro.hora), mean)
    agg2 = aggregate(rv$dt_species$Pole, by=list(rv$dt_species$registro.hora), mean)

    mt = t(matrix(c(agg1$x, agg2$x), ncol=2))
    
    plot = barplot(mt,
                   beside=T,
                   col = c("#75AADB","coral"),
                   border = "white",
                   ylim=c(0, (ceiling(max(mt)) + 2)),
                   names.arg = agg1$Group.1,
                   xlab = "(Hora)",
                   main = "Média de pólen na entrada"
    )
    
    text(x=plot, y=mt, labels=gsub("^0$", "", as.character(round(mt, 1))), pos=3)
    legend(1, max(mt)+2, legend=c("Entrada", "Entrada com pólen"), col=c("#75AADB","coral"), pch=15)
  })
  
  output$map = renderLeaflet({
    palette = colorFactor(
      palette = c('yellow', 'green', 'red'),
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