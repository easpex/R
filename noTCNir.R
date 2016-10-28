
noTCNir<-function(bearer = "") {

  
  bearer<-paste('Bearer ', bearer, sep = "")
  # necessary libraries
  if(!require(httr)) {install.packages("httr")} 
  if(!require(jsonlite)) {install.packages("jsonlite")} 
  require(httr)
  require(jsonlite)
  # we get the json object which contains all waterfalls in our account
  waterfalls<-httr::GET(url = "http://ironsrc.streamrail.com/api/waterfalls", 
                        query = list(itemsPerPage="5000", sortAsc="true", sortBy="priority"), 
                        
                        # add the relevant below
                        add_headers(c('Authorization'= bearer,
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

  # loop which will check each waterfall if it doesn't have any traffic targeting or it is NOT targeted to specific traffic channels
  for(i in 1:length(waterfallsJson$waterfalls)) {
    if( !grepl(pattern = ".*key.*chan.*\"eq", x = waterfallsJson$waterfalls[i][[1]]$targetingConditions[1], fixed = FALSE))
      
      
    {
      # print the name of the waterfall where the problem was found
      print(waterfallsJson$waterfalls[i][[1]]$name)
    } # end of if 
    
  } # end of for
 } # end of function




# run funtion here
noTCNir(bearer = "typeBearerHere")
