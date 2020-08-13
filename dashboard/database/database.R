data = read.csv("database/data.csv", header=TRUE, sep=",")

data$DataCriacao = as.POSIXct(strptime(data$DataCriacao,"%Y-%m-%d %H:%M:%S", tz=""))
data$Email = as.character(data$Email)
data$DataRegistro = as.POSIXct(strptime(data$DataRegistro,"%Y-%m-%d %H:%M:%S", tz=""))
data$Temperatura = as.numeric(data$Temperatura)
data$Experiencia = as.factor(data$Experiencia)
data$Especie = as.factor(data$Especie)
data$FezCurso = as.factor(data$FezCurso)

data$CondicaoCeu = as.factor(data$CondicaoCeu)
data$CondicaoCeu = factor(data$CondicaoCeu, levels = c("Chuva fraca", "Coberto por nuvens de chuva/nublado", "Parcialmente coberto por nuvens", "Céu aberto sem nuvens"))

data$IdentificadorNinho = as.character(data$IdentificadorNinho)
data$AreaClass = as.factor(data$AreaClass)
data$Saida = as.numeric(data$Saida)
data$Entrada = as.numeric(data$Entrada)
data$Polen = as.numeric(data$Polen)
data$Latidute =  as.numeric(data$Latidute)
data$Longitude = as.numeric(data$Longitude)
data$ArquivoVideo = as.character(data$ArquivoVideo)

data$atividade = data$Saida + data$Entrada
data$registro.hora = as.numeric(format(as.POSIXct(strptime(data$DataRegistro,"%Y-%m-%d %H:%M:%S",tz="")), format = "%H"))

###

source("functions/random.coordinate.R")

set.seed(2468)

dt = as.data.frame(t(mapply(random.coordinate, data$Latidute, data$Longitude)))
colnames(dt) = c("Latitude_r", "Longitude_r")
data = cbind(data, dt)

remove(dt)
