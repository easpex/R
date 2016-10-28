require(httr)
lkqdTags<-httr::GET(url = "https://ui-api.lkqd.com/demand/tag-listing-rows", 
                add_headers(c('Origin'='https://ui.lkqd.com',
                              'Accept-Encoding' = 'gzip, deflate, sdch, br', 
                              'LKQD-Api-Version' = '34', 
                              'User-Agent' = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36', 
                              'Accept' = 'application/json, text/plain, */*', 
                              'Connection' = 'keep-alive',
                              'Cookie' = '_ga=GA1.2.1632327767.1457612548; session=qAbNZ6oXrtEEbmbKWRPnoK1Mon0KyetS'
                )))


lkqdTags<-content(x = lkqdTags, type = 'application/json')                 

length(lkqdTags$data)
lkqdTags$data[[4]]$tagId


currentTagId<-lkqdTags$data[[4]]$tagId

#  https://ui-api.lkqd.com/tags/50416

lkqdTagId<-httr::GET(url = sprintf("https://ui-api.lkqd.com/tags/%s", currentTagId), 
                    add_headers(c('Origin'='https://ui.lkqd.com',
                                  'Accept-Encoding' = 'gzip, deflate, sdch, br', 
                                  'LKQD-Api-Version' = '33', 
                                  'User-Agent' = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36', 
                                  'Accept' = 'application/json, text/plain, */*', 
                                  'Connection' = 'keep-alive',
                                  'Cookie' = '_ga=GA1.2.1632327767.1457612548; session=qAbNZ6oXrtEEbmbKWRPnoK1Mon0KyetS'
                    )))
lkqdTagId<-content(x = lkqdTagId, type = 'application/json')      
str(lkqdTagId)
lkqdTagId$data$tagId
lkqdTagId$data$name
lkqdTagId$data$adTag
lkqdTagId$data$dealCpm



#################################################################### funtion

lkqdTags<-httr::GET(url = "https://ui-api.lkqd.com/demand/tag-listing-rows", 
                    add_headers(c('Origin'='https://ui.lkqd.com',
                                  'Accept-Encoding' = 'gzip, deflate, sdch, br', 
                                  'LKQD-Api-Version' = '33', 
                                  'User-Agent' = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36', 
                                  'Accept' = 'application/json, text/plain, */*', 
                                  'Connection' = 'keep-alive',
                                  'Cookie' = '_ga=GA1.2.1632327767.1457612548; session=qAbNZ6oXrtEEbmbKWRPnoK1Mon0KyetS'
                    )))


lkqdTags<-content(x = lkqdTags, type = 'application/json')  

lkqdTagsDF<-data.frame(matrix(nrow = length(lkqdTags$data), ncol = 4))
colnames(lkqdTagsDF)[1]<-"tagId"
colnames(lkqdTagsDF)[2]<-"name"
colnames(lkqdTagsDF)[3]<-"dealCpm"
colnames(lkqdTagsDF)[4]<-"adTag"

for(i in 255:length(lkqdTags$data)) {
  currentTagId<-lkqdTags$data[[i]]$tagId
  
  lkqdTagId<-httr::GET(url = sprintf("https://ui-api.lkqd.com/tags/%s", currentTagId), 
                       add_headers(c('Origin'='https://ui.lkqd.com',
                                     'Accept-Encoding' = 'gzip, deflate, sdch, br', 
                                     'LKQD-Api-Version' = '34', 
                                     'User-Agent' = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36', 
                                     'Accept' = 'application/json, text/plain, */*', 
                                     'Connection' = 'keep-alive',
                                     'Cookie' = '_ga=GA1.2.1632327767.1457612548; session=qAbNZ6oXrtEEbmbKWRPnoK1Mon0KyetS'
                       )))
  lkqdTagId<-content(x = lkqdTagId, type = 'application/json')
  
  lkqdTagsDF$tagId[i]<-lkqdTagId$data$tagId
  lkqdTagsDF$name[i]<-lkqdTagId$data$name
  lkqdTagsDF$dealCpm[i]<-lkqdTagId$data$dealCpm
  lkqdTagsDF$adTag[i]<-lkqdTagId$data$adTag
  print(i)
}
lkqdPath<-sprintf("C:\\Users\\yossi.spektor\\Documents\\Reports\\LKQD\\lkqdTagsDF_%s.csv", Sys.Date())
write.csv(x = lkqdTagsDF, file = lkqdPath, row.names = FALSE)

#################################################################
# , session=UumAriFm9AhrJSzQaAOpStMz1q0HzzMT'
  lkqdSites<-httr::GET(url = "https://ui-api.lkqd.com/supply/listing-rows", 
                    (add_headers(c('Cookie' = '_ga=GA1.2.1632327767.1457612548; session=UumAriFm9AhrJSzQaAOpStMz1q0HzzMT',
                                  'Origin'='https://ui.lkqd.com',
                                  'Accept-Encoding' = 'gzip, deflate, sdch, br', 
                                  'Accept-Language' = 'en-US,en;q=0.8',
                                  'LKQD-Api-Version' = '34', 
                                  'Accept' = 'application/json, text/plain, */*', 
                                  'Referer' = 'https://ui.lkqd.com/sites',
                                  'User-Agent' = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36', 
                                  'Connection' = 'keep-alive'
                                  ))))
                    
                       
lkqdSites<-content(x = lkqdSites, type = 'application/json')  

