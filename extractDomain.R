urls<-read.csv(file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\urls.csv",
               skip = 0, stringsAsFactors=FALSE, dec = ".",
               header=TRUE) 
head(urls)

urls$URLdecoded<-""
urls$host<-""
urls$subdomain<-""
urls$domainBody<-""
urls$suffix<-""
urls$domain<-""
for(i in 1:nrow(urls)) {
  
  # urls$domain[i]<-urltools::domain(urls$URL[i])
  urls$URLdecoded[i]<-urltools::url_decode(urls$URL[i])
  urls$host[i]<-as.character(urltools::suffix_extract(domain(urls$URLdecoded[i]))[1])
  urls$subdomain[i]<-as.character(urltools::suffix_extract(domain(urls$URLdecoded[i]))[2])
  urls$domainBody[i]<-as.character(urltools::suffix_extract(domain(urls$URLdecoded[i]))[3])
  urls$suffix[i]<-as.character(urltools::suffix_extract(domain(urls$URLdecoded[i]))[4])
  urls$domain[i]<-paste(urls$domainBody[i], urls$suffix[i], sep = ".")
  
}



write.csv(x = urls, file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\urlsView.csv", row.names = FALSE)
