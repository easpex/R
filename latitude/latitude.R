aerserv<-read.csv(file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\aerserv_cleanmaster.csv",
                  skip = 0, stringsAsFactors=FALSE, dec = ".",
                  header=TRUE)

head(aerserv)
unique(aerserv$adSource)


aggr<-with(data = aerserv,
                             aggregate(x = cbind(requests = requests,
                                                 impressions = impressions),
                                       by = list(date = date,
                                                 trafficChannel = trafficChannel),
                                       FUN = sum, na.rm = TRUE))

View(aggr)


writePath<-"C:\\Users\\yossi.spektor\\Documents\\Reports\\aerserv_cleanmasterAggr.csv"
write.csv(x = aggr, file = writePath, row.names = FALSE)
list.files(path = "C:\\Users\\yossi.spektor\\Documents\\Reports")








require(plotly)
require(httr)
require(ggmap)

redshift <- read.csv(file = 'C:\\Users\\yossi.spektor\\Documents\\R\\latitude\\redshift.csv',
                      skip = 0, stringsAsFactors=FALSE, dec = ".",
                      header=TRUE)
head(redshift)
redshift$len<-NULL
for(i in 1:nrow(redshift)) {
  redshift$len[i]<-max(nchar(redshift$latitude[i]), nchar(redshift$longitude[i]))
  
}
max(redshift$len, na.rm = TRUE)

redshift$latRounded<-NULL
redshift$lonRounded<-NULL
for(i in 1:nrow(redshift)) {
  redshift$latRounded[i]<-round(redshift$latitude[i], digits = 2)
  redshift$lonRounded[i]<-round(redshift$longitude[i], digits = 2)
  
}

redshift$lat_lon<-NULL
for(i in 1:nrow(redshift)) {
  redshift$lat_lon[i]<-sprintf("%s_%s", redshift$latRounded[i], redshift$lonRounded[i])
  
}
lat<-33.85
long<--84.36
url<-sprintf('http://scatter-otl.rhcloud.com/location?lat=%s&long=%s', lat, long)

scatter<-httr::GET(url = "http://scatter-otl.rhcloud.com/location", 
                      query = list(lat=lat, long=long))
scatter$city




ggmapAPI<-httr::GET(url = "http://maps.googleapis.com/maps/api/geocode/json", 
                   query = list(latlng=sprintf("%s,%s", lat, long), sensor="false"))
ggmapAPI<-content(x = ggmapAPI,type = 'application/json')

city<-ggmapAPI$results[[1]]$address_components[[2]]$short_name
country<-ggmapAPI$results[[1]]$address_components[[4]]$short_name

ggmapAPI$results[[3]]$address_components[[2]]$short_name
strsplit(x = ggmapAPI$results[[1]]$formatted_address, fixed = TRUE, split = ",")[[1]][4]


redshift$country<-NULL
redshift$city<-NULL
for(i in 1:nrow(redshift)) {
  lat<-redshift$latitude[i]
  long<-redshift$longitude[i]

  ggmapAPI<-httr::GET(url = "http://maps.googleapis.com/maps/api/geocode/json", 
                      query = list(latlng=sprintf("%s,%s", lat, long), sensor="false"))
  ggmapAPI<-content(x = ggmapAPI,type = 'application/json')
  
  #  redshift$city[i]<-ggmapAPI$results[[1]]$address_components[[3]]$long_name
  #  redshift$country[i]<-ggmapAPI$results[[1]]$address_components[[6]]$long_name
  redshift$city[i]<-strsplit(x = ggmapAPI$results[[1]]$formatted_address, fixed = TRUE, split = ",")[[1]][2]
  redshift$country[i]<-strsplit(x = ggmapAPI$results[[1]]$formatted_address, fixed = TRUE, split = ",")[[1]][4]
  print(paste("i=", i, " ", ggmapAPI$results[[1]]$formatted_address))
  # print(paste("i=", i, "city=", redshift$city[i], "country=", redshift$country[i], sep = ""))
}

require(zipcode)
data(zipcode)
head(zipcode)
View(redshift)
View(city)

myZipcode<-zipcode
myZipcode$lat_lon<-NULL
head(myZipcode)
myZipcode$len<-NULL
for(i in 1:nrow(redshift)) {
  myZipcode$len[i]<-max(nchar(myZipcode$latitude[i]), nchar(myZipcode$longitude[i]))
  
}
max(myZipcode$len, na.rm = TRUE)

myZipcode$latRounded<-NULL
myZipcode$lonRounded<-NULL
for(i in 1:nrow(myZipcode)) {
  myZipcode$latRounded[i]<-round(myZipcode$latitude[i], digits = 2)
  myZipcode$lonRounded[i]<-round(myZipcode$longitude[i], digits = 2)
  
}

myZipcode$lat_lon<-NULL
for(i in 1:nrow(myZipcode)) {
  myZipcode$lat_lon[i]<-sprintf("%s_%s", myZipcode$latRounded[i], myZipcode$lonRounded[i])
  
}

redshift$nearestLat<-NULL
redshift$nearestLon<-NULL
for(i in 1:nrow(redshift)) { #
  minLat<-50000   #redshift$latitude[i] - myZipcode$latitude[1]
  minLon<-50000   #redshift$longitude[i] - myZipcode$longitude[1]
  
  for(k in 1:nrow(myZipcode)) { #
    boolRedLat<-redshift$latitude[i] > 0 
    boolZipLat<-myZipcode$latitude[i] > 0
    boolLat1<-boolRedLat && boolZipLat
    boolLat2<-!boolRedLat && !boolZipLat
    print(paste("i=",i, "|", "k=", k))
    print(boolLat1 || boolLat2)
    print(redshift$latitude[i]-myZipcode$latitude[k] < minLat)
    print((boolLat1 || boolLat2) && redshift$latitude[i]-myZipcode$latitude[k] < minLat)
    if( (boolLat1 || boolLat2) && redshift$latitude[i]-myZipcode$latitude[k] < minLat ){
      
      
      redshift$nearestLat[i]<-myZipcode$latitude[k]
      minLat<-redshift$latitude[i]-myZipcode$latitude[k]

      
    } # end of positivity/negativity check
  
      
    boolRedLon<-redshift$longitude[i] > 0 
    boolZipLon<-myZipcode$longitude[k] > 0
    boolLon1<-boolRedLon && boolZipLon
    boolLon2<-!boolRedLon && !boolZipLon
    if( (boolLon1 || boolLon2) && redshift$longitude[i]-myZipcode$longitude[k] < minLon ){

        redshift$nearestLon[i]<-myZipcode$longitude[k]
        minLon<-redshift$longitude[i]-myZipcode$longitude[k]

      
    }# end of positivity/negativity check
  } # end of k loop
} # end of i loop
