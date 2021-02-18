data.old = read.csv("database/data_old.csv", header=TRUE, sep=",")

data.old$date.observation = as.POSIXct(strptime(data.old$date.observation,"%Y-%m-%d %H:%M:%S", tz=""))
data.old$email = as.character(data.old$email)
data.old$date.register = as.POSIXct(strptime(data.old$date.register,"%Y-%m-%d %H:%M:%S", tz=""))
data.old$temperature = as.numeric(data.old$temperature)
data.old$experience = as.factor(data.old$experience)
data.old$species = as.factor(data.old$species)
data.old$course = as.factor(data.old$course)

data.old$weather = as.factor(data.old$weather)
data.old$weather = factor(data.old$weather, levels = c("Chuva fraca", "Coberto por nuvens de chuva/nublado", "Parcialmente coberto por nuvens", "Céu aberto sem nuvens"))

data.old$nest = as.character(data.old$nest)
data.old$area = as.factor(data.old$area)
data.old$exit = as.numeric(data.old$exit)
data.old$entrance = as.numeric(data.old$entrance)
data.old$pollen = as.numeric(data.old$pollen)
data.old$latitude =  as.numeric(data.old$latitude)
data.old$longitude = as.numeric(data.old$longitude)
data.old$filename = as.character(data.old$filename)

data.old$activity = data.old$exit + data.old$entrance
data.old$hour.register = as.numeric(format(as.POSIXct(strptime(data.old$date.register,"%Y-%m-%d %H:%M:%S",tz="")), format = "%H"))

###

source("functions/random.coordinate.R")

set.seed(2468)

dt = as.data.frame(t(mapply(random.coordinate, data.old$latitude, data.old$longitude)))
colnames(dt) = c("random.latitude", "random.longitude")
data.old = cbind(data.old, dt)

remove(dt)
