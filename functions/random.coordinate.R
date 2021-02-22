random.coordinate = function(latitude, longitude, min_distance = 100, max_distance = 10000) {
  lat = latitude * pi / 180
  lon = longitude * pi / 180
  
  max_distance = max_distance
  min_distance = min_distance
  earth_radius = 6371000
  
  distance = sqrt(runif(1) * (max_distance^2 - min_distance^2) + min_distance^2)
  
  delta_lat = cos(runif(1) *  pi) * distance / earth_radius
  
  sign = runif(1, min=0, max=2) * 2 - 1
  delta_lon = sign * acos(
    ((cos(distance/earth_radius) - cos(delta_lat)) /
       (cos(lat) * cos(delta_lat + lat))) + 1)
  
  return (c((lat + delta_lat) * 180 / pi, (lon + delta_lon) * 180 / pi))
}
