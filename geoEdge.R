install.packages("stringr ")
require(urltools)
require(stringr)       


geoPath<-"C:\\Users\\yossi.spektor\\Documents\\Reports\\Float\\floatGeoedge.csv"


geoFile<-read.csv(file = geoPath,
                    skip = 0, stringsAsFactors=FALSE, dec = ".",
                    header=TRUE) 
head(geoFile)


geoFile$URLdecoded<-""
geoFile$host<-""
geoFile$subdomain<-""
geoFile$domainBody<-""
geoFile$suffix<-""
geoFile$domain<-""
for(i in 1:nrow(geoFile)) {
  
  # geoFile$domain[i]<-urltools::domain(geoFile$URL[i])
  geoFile$URLdecoded[i]<-urltools::url_decode(geoFile$URL[i])
  geoFile$host[i]<-as.character(urltools::suffix_extract(domain(geoFile$URLdecoded[i]))[1])
  geoFile$subdomain[i]<-as.character(urltools::suffix_extract(domain(geoFile$URLdecoded[i]))[2])
  geoFile$domainBody[i]<-as.character(urltools::suffix_extract(domain(geoFile$URLdecoded[i]))[3])
  geoFile$suffix[i]<-as.character(urltools::suffix_extract(domain(geoFile$URLdecoded[i]))[4])
  geoFile$domain[i]<-paste(geoFile$domainBody[i], geoFile$suffix[i], sep = ".")
  
}



write.csv(x = geoFile, file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\Float\\geoFile.csv", row.names = FALSE)


geoFile[100,]
View(geoFile)
head(geoFile)

###################################################################################
geoFile$domainCount<-""
for(i in 1:nrow(geoFile)) {
  
  geoFile$domainCount[i]<-stringr::str_count(string = geoFile$domain[i])
  
}

  
  
  
  table(unlist(geoFile$domain))
as.data.frame(table(geoFile$domain))


advertiserChain<-data.frame(as.data.frame(unique(geoFile$tag)), domain="", count="")
names(advertiserChain)[1]<-"tag"
for(i in 1:length(unique(geoFile$tag))) {
  
  advertiserChain<-rbind(advertiserChain, advertiserChain[, "domain"])
  
}



