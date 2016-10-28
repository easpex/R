#get streamrail ad sources
tc<-httr::GET(url = "http://ironsrc.streamrail.com/api/traffic-channels", 
                     query = list(itemsPerPage="5000", sortAsc="true", sortBy="name"), 
                     add_headers(c('Authorization'='Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI1NmZhNzZiMzMxMTY5NzAwMDIwMDAwNDIifQ.CHjH9jQHy2-B68aBRijoZptCAtVLm9U_Z80f_XYaPEc',
                                   'Accept-Encoding' = 'gzip, deflate, sdch, br', 
                                   'Accept-Language' = 'en-US,en;q=0.8', 
                                   'User-Agent' = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36', 
                                   'Accept' = 'application/json, text/javascript, */*; q=0.01', 
                                   'X-Requested-With' = 'XMLHttpRequest', 
                                   'Connection' = 'keep-alive',
                                   'Cache-Control' = 'max-age=0'
                     )))

tc<-content(x = tc,type = 'application/json')  
  tc$trafficChannels[1][[1]]$name
  
tcDF<-data.frame(matrix(nrow = length(tc$trafficChannels), ncol = 3))

#extract the adserver domain com and populate the DF with ad source properties
for(i in 1:length(tc$trafficChannels)) {
  tcDF$name[i]<-tc$trafficChannels[i][[1]]$name
  tcDF$id[i]<-tc$trafficChannels[i][[1]]$id
}

View(tcDF)


writePath<-"C:\\Users\\yossi.spektor\\Documents\\Reports\\Environment\\tcDF.csv"
write.csv(x = tcDF, file = writePath, row.names = FALSE)
