data.old = read.csv("database/data_old.csv", header=TRUE, sep=",")

data.old$date.observation = as.POSIXct(strptime(data.old$date.observation, "%Y-%m-%d %H:%M:%S", tz=""))
data.old$email = as.character(data.old$email)
data.old$date.register = as.POSIXct(strptime(data.old$date.register, "%Y-%m-%d %H:%M:%S", tz=""))
data.old$temperature = as.numeric(data.old$temperature)
data.old$experience = as.factor(data.old$experience)
data.old$species = as.factor(data.old$species)
data.old$course = as.factor(data.old$course)

data.old$weather = as.factor(data.old$weather)
data.old$weather = factor(data.old$weather, levels = c("Chuva forte", "Chuva fraca", "Coberto por nuvens de chuva/nublado", "Parcialmente coberto por nuvens", "Céu aberto sem nuvens"))

data.old$nest = as.character(data.old$nest)
data.old$area = as.factor(data.old$area)
data.old$exit = as.numeric(data.old$exit)
data.old$entrance = as.numeric(data.old$entrance)
data.old$pollen = as.numeric(data.old$pollen)
data.old$latitude =  as.numeric(data.old$latitude)
data.old$longitude = as.numeric(data.old$longitude)
data.old$id.video = as.factor(data.old$id.video)

###########################################

counts = read.csv("database/counts.csv", header=TRUE, sep=",")

counts$id.video = as.factor(counts$id.video)

counts$email = trimws(counts$email)
counts$email = as.character(counts$email)

counts$entrance = as.numeric(counts$entrance)
counts$exit = as.numeric(counts$exit)
counts$pollen = as.numeric(counts$pollen)

counts$invalid.pollen = trimws(counts$invalid.pollen)
counts$invalid.pollen[counts$invalid.pollen=='False'] = FALSE
counts$invalid.pollen[counts$invalid.pollen=='True'] = TRUE
counts$invalid.pollen = as.factor(counts$invalid.pollen)

###########################################

videos = read.csv("database/videos.csv", header=TRUE, sep=",")

videos$id.video = as.factor(videos$id.video)
videos$date.register = as.POSIXct(strptime(videos$date.register, "%Y-%m-%d %H:%M:%S", tz=""))
videos$date.observation = as.POSIXct(strptime(videos$date.observation, "%Y-%m-%d %H:%M:%S", tz=""))

videos$email = trimws(videos$email)
videos$email =  as.character(videos$email)

videos$temperature = as.numeric(videos$temperature)

videos$species = trimws(videos$species)
videos$species = as.factor(videos$species)

videos$weather = trimws(videos$weather)
videos$weather = as.factor(videos$weather)
videos$weather = factor(videos$weather, levels = c("Chuva forte", "Chuva fraca", "Coberto por nuvens de chuva/nublado", "Parcialmente coberto por nuvens", "Céu aberto sem nuvens"))


videos$nest = trimws(videos$nest)
videos$nest = as.character(videos$nest)

videos$area = trimws(videos$area)
videos$area = as.factor(videos$area)

videos$nest.type = trimws(videos$nest.type)
videos$nest.type = as.factor(videos$nest.type)

videos$latitude = as.numeric(videos$latitude)
videos$longitude = as.numeric(videos$longitude)

###########################################

library(dplyr)

data = inner_join(videos, counts, by = c("id.video", "email")) 

data.old$invalid.pollen = FALSE
data.old$invalid.pollen = as.factor(data.old$invalid.pollen)

for(i in names(data.old)[!names(data.old) %in% names(data)]) {
  data[i] = NA
}

for(i in names(data)[!names(data) %in% names(data.old)]) {
  data.old[i] = NA
}

data = full_join(data, data.old)

###########################################

data$activity = data$exit + data$entrance
data$hour.observation = as.numeric(format(as.POSIXct(strptime(data$date.observation,"%Y-%m-%d %H:%M:%S",tz="")), format = "%H"))

###

source("functions/random.coordinate.R")

set.seed(2468)

dt = as.data.frame(t(mapply(random.coordinate, data$latitude, data$longitude)))
colnames(dt) = c("random.latitude", "random.longitude")
data = cbind(data, dt)

remove(dt, data.old, i, counts, videos, random.coordinate)
