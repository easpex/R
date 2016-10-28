require(RCurl)
require(httr)


devtools::install_github("hrbrmstr/curlconverter")


library(curlconverter)
library(jsonlite)
library(httr)



waterfalls<-httr::GET(url = "http://ironsrc.streamrail.com/api/waterfalls", 
           query = list(itemsPerPage="1000", sortAsc="true", sortBy="priority"), 
           add_headers(c('Authorization'='Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI1NmZhNzZiMzMxMTY5NzAwMDIwMDAwNDIifQ.CHjH9jQHy2-B68aBRijoZptCAtVLm9U_Z80f_XYaPEc',
                         'Accept-Encoding' = 'gzip, deflate, sdch, br', 
                         'Accept-Language' = 'en-US,en;q=0.8', 
                         'User-Agent' = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36', 
                         'Accept' = 'application/json, text/javascript, */*; q=0.01', 
                         'X-Requested-With' = 'XMLHttpRequest', 
                         'Connection' = 'keep-alive',
                         'Cache-Control' = 'max-age=0'
                         )))
                    
waterfallsJson<-content(x = waterfalls,type = 'application/json')                 



str(waterfallsJson)
waterfallsJson$waterfalls[203][[1]]$name


result<-data.frame(matrix(nrow = length(waterfallsJson$waterfalls), ncol = 1))
colnames(result)[1]<-"name"
for(i in 1:length(waterfallsJson$waterfalls)) {
  if( !grepl(pattern = ".*key.*chan.*\"eq", x = waterfallsJson$waterfalls[i][[1]]$targetingConditions[1], fixed = FALSE))
  
       
    {
    print(waterfallsJson$waterfalls[i][[1]]$name)
    } 
  
}

str(result)
View(result)
result$name[complete.cases(result$name)]
length(waterfallsJson$waterfalls)
       
       
       
noTC<-function() {
  # necessary libraries
  library(httr)
  library(jsonlite)
  
  # we get the json object which contains all waterfalls in our account
  waterfalls<-httr::GET(url = "http://ironsrc.streamrail.com/api/waterfalls", 
                        query = list(itemsPerPage="5000", sortAsc="true", sortBy="priority"), 
                        add_headers(c('Authorization'='Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI1NmZhNzZiMzMxMTY5NzAwMDIwMDAwNDIifQ.CHjH9jQHy2-B68aBRijoZptCAtVLm9U_Z80f_XYaPEc',
                                      'Accept-Encoding' = 'gzip, deflate, sdch, br', 
                                      'Accept-Language' = 'en-US,en;q=0.8', 
                                      'User-Agent' = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36', 
                                      'Accept' = 'application/json, text/javascript, */*; q=0.01', 
                                      'X-Requested-With' = 'XMLHttpRequest', 
                                      'Connection' = 'keep-alive',
                                      'Cache-Control' = 'max-age=0'
                        )))
  # extract json from waterfalls object
  waterfallsJson<-content(x = waterfalls,type = 'application/json')      
  
  # create a data frame which will contain the names of all problematic waterfalls
  # result<-data.frame(matrix(nrow = length(waterfallsJson$waterfalls), ncol = 1))
  
  # name the column
  # colnames(result)[1]<-"name"
  
  # loop which will check each waterfall if it doesn't have any traffic targeting or it is NOT targeted to specific traffic channels
  for(i in 1:length(waterfallsJson$waterfalls)) {
    if( !grepl(pattern = ".*key.*chan.*\"eq", x = waterfallsJson$waterfalls[i][[1]]$targetingConditions[1], fixed = FALSE) &&
        !grepl(pattern = ".*key.*sr_publisher.*\"eq", x = waterfallsJson$waterfalls[i][[1]]$targetingConditions[1], fixed = FALSE))
      
      
    {
      # add name of the waterfall where the problem was found
     # result$name[i]<-waterfallsJson$waterfalls[i][[1]]$name
      print(waterfallsJson$waterfalls[i][[1]]$name)
    } # end of if 
    
  } # end of for
 # writePath<-paste("C:\\Users\\yossi.spektor\\Desktop\\", "waterfallsNoChannel",Sys.Date(), ".csv", sep = "")
 #write.csv(x = result, file = writePath, row.names = FALSE)
} # end of function




# run funtion here
noTC()
