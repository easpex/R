require(RCurl)
require(httr)
require(jsonlite)
require(urltools)

#get streamrail ad sources
adSources<-httr::GET(url = "http://ironsrc.streamrail.com/api/ad-sources", 
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

adSources<-content(x = adSources,type = 'application/json')  

adSources$adSources[334][[1]]$targetingConditions
adSources$adSources[334][[1]]$name


str(adSources)
View(adSourcesDF)

#create data frame for all the columns
adSourcesDF<-data.frame(matrix(nrow = length(adSources$adSources), ncol = 8))
colnames(adSourcesDF)[1]<-"name"
colnames(adSourcesDF)[2]<-"id"
colnames(adSourcesDF)[3]<-"prerollAdTag"
colnames(adSourcesDF)[4]<-"advertiserTagId"
colnames(adSourcesDF)[5]<-"adServerDomain"
colnames(adSourcesDF)[6]<-"adServerDomainSuffix"
colnames(adSourcesDF)[7]<-"adServerDomainCom"
colnames(adSourcesDF)[8]<-"env"

#extract the adserver domain com and populate the DF with ad source properties
for(i in 1:length(adSources$adSources)) {
  adSourcesDF$name[i]<-adSources$adSources[i][[1]]$name
  adSourcesDF$id[i]<-adSources$adSources[i][[1]]$id
  adSourcesDF$prerollAdTag[i]<-adSources$adSources[i][[1]]$prerollAdTag
  adSourcesDF$adServerDomain[i]<-as.character(urltools::suffix_extract(domain(adSourcesDF$prerollAdTag[i]))[3])
  adSourcesDF$adServerDomainSuffix[i]<-as.character(urltools::suffix_extract(domain(adSourcesDF$prerollAdTag[i]))[4])
  adSourcesDF$adServerDomainCom[i]<-paste(adSourcesDF$adServerDomain[i], adSourcesDF$adServerDomainSuffix[i], sep = ".")
  
  if(grepl(pattern = "[\"mobile_app\"]", x = adSources$adSources[i][[1]]$targetingConditions, fixed = TRUE)) {
    adSourcesDF$env[i]<-"mobile_app"
    
  } else if(grepl(pattern = "[\"desktop\"]", x = adSources$adSources[i][[1]]$targetingConditions, fixed = TRUE)) {
    adSourcesDF$env[i]<-"desktop"
  } else if(grepl(pattern = "[\"mobile_web\"]", x = adSources$adSources[i][[1]]$targetingConditions, fixed = TRUE)) {
    adSourcesDF$env[i]<-"mobile_web"
  } else {
    adSourcesDF$env[i]<-"error"
  }
    
}

View(adSourcesDF)


################################################# extract ad server ID's in streamrail demand tags


# extract ad server ID's in streamrail demand tags
for(i in 1:nrow(adSourcesDF)) {
  if(adSourcesDF$adServerDomainCom[i]=="lkqd.net") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "sid=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "sid=", replacement = "", fixed = TRUE)
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="advertising.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
    split<-split[[1]][6]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-split
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="tremorhub.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "adCode=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "adCode=", replacement = "", fixed = TRUE)
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="spotxchange.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
    split<-split[[1]][6]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-split
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="aerserv.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    split<-split[[1]][1]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "plc=", replacement = "", fixed = TRUE)
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="yumenetworks.com") {
    if(grepl(pattern = "dynamic_preroll_playlist", x = adSourcesDF$prerollAdTag[i], fixed = TRUE)) {
      split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
      split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
      split<-split[[1]][1]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "domain=", replacement = "", fixed = TRUE)
    } else if(grepl(pattern = "http://plg", x = adSourcesDF$prerollAdTag[i], fixed = TRUE)) {
      split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "/", fixed = TRUE)   #split the vast url
      split<-split[[1]][6]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      adSourcesDF$advertiserTagId[i]<-split
    } else if(grepl(pattern = "https://spl", x = adSourcesDF$prerollAdTag[i], fixed = TRUE)) {
      split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "/", fixed = TRUE)   #split the vast url
      split<-split[[1]][6]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      adSourcesDF$advertiserTagId[i]<-split
    } else{
      adSourcesDF$advertiserTagId[i]<-"error"
    }
  } # end of Yume
  
  if(adSourcesDF$adServerDomainCom[i]=="stickyadstv.com") {
    if(!grepl(pattern = "vpaid-adapter", x = adSourcesDF$prerollAdTag[i], fixed = TRUE)) {
      split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "&", fixed = TRUE)   #split the vast url
      split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "/", fixed = TRUE)   #split the vast url
      # find where the zoneId id
      zone<-sapply(split, function(x) grep(pattern = "zoneId", x = x, fixed = TRUE))
      split<-split[[1]][zone]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "zoneId=", replacement = "", fixed = TRUE)
    } else {
      split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "&", fixed = TRUE)   #split the vast url
      split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)   #split the vast url
      split<-split[[1]][6]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      adSourcesDF$advertiserTagId[i]<-split
    }
    
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="inmobi.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    split<-split[[1]][1]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "plid=", replacement = "", fixed = TRUE)
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="rubiconproject.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "zone_id", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "zone_id=", replacement = "", fixed = TRUE)
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="optimatic.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "id=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "id=", replacement = "", fixed = TRUE)
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="pubmatic.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "adId=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "adId=", replacement = "", fixed = TRUE)
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="btrll.com") {
    if(grepl(pattern = "mobile.btrll.com", x = adSourcesDF$prerollAdTag[i], fixed = TRUE)) {
      split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
      split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
      zone<-sapply(split, function(x) grep(pattern = "siteId=", x = x, fixed = TRUE))
      split<-split[[1]][zone]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "siteId=", replacement = "", fixed = TRUE)
    } else if(grepl(pattern = "http://vast", x = adSourcesDF$prerollAdTag[i], fixed = TRUE)) {
      split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
      split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
      split<-split[[1]][5]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      adSourcesDF$advertiserTagId[i]<-split
    } else {
      adSourcesDF$advertiserTagId[i]<-"error"
    }
  } # end of brightroll
  
  if(adSourcesDF$adServerDomainCom[i]=="thirdpresence.com") {
    
    if(grepl(pattern = "adid=", x = adSourcesDF$prerollAdTag[i], fixed = TRUE)) {
      split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
      split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
      zone<-sapply(split, function(x) grep(pattern = "adid=", x = x, fixed = TRUE))
      split<-split[[1]][zone]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "adid=", replacement = "", fixed = TRUE)
      
    } else if(grepl(pattern = "playerid=", x = adSourcesDF$prerollAdTag[i], fixed = TRUE)) {
      split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
      split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
      zone<-sapply(split, function(x) grep(pattern = "playerid=", x = x, fixed = TRUE))
      split<-split[[1]][zone]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "playerid=", replacement = "", fixed = TRUE)
      
    } else {
      adSourcesDF$advertiserTagId[i]<-"error"
    }
    
  } # end of thirdpresence
  
  if(adSourcesDF$adServerDomainCom[i]=="videoplaza.tv") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "s=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "s=", replacement = "", fixed = TRUE)
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="springserve.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
    split<-split[[1]][5]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-split
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="tubemogul.com") {
    if(grepl(pattern = "rtb.tubemogul.com", x = adSourcesDF$prerollAdTag[i], fixed = TRUE)) {
      split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
      split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
      split<-split[[1]][5]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      adSourcesDF$advertiserTagId[i]<-split
    } else if(grepl(pattern = "pv.tubemogul.com", x = adSourcesDF$prerollAdTag[i], fixed = TRUE)) {
      split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
      split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
      split<-split[[1]][6]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      adSourcesDF$advertiserTagId[i]<-split
    } else {
      adSourcesDF$advertiserTagId[i]<-"error"
    }
  } # end of tubemogul
  
  if(adSourcesDF$adServerDomainCom[i]=="pokkt.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "appId=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "appId=", replacement = "", fixed = TRUE)
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="streamrail.net") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
    split<-split[[1]][7]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    if(is.na(split)) {
      adSourcesDF$advertiserTagId[i]<-"error"
    } else {
      adSourcesDF$advertiserTagId[i]<-split
    }
    
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="altitude-arena.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "uid=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "uid=", replacement = "", fixed = TRUE)
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="yashi.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][1], split = "&", fixed = TRUE)
    split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
    split<-split[[1]][4]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-split
  }
  
  
  if(adSourcesDF$adServerDomainCom[i]=="smartadserver.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "pgid=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "pgid=", replacement = "", fixed = TRUE)
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="rollmob.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
    split<-split[[1]][5]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-split
  }
  
  if(adSourcesDF$adServerDomainCom[i]=="provenpixel.com") {
    split<-strsplit(x = adSourcesDF$prerollAdTag[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "zoneid=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    adSourcesDF$advertiserTagId[i]<-sub(x = split, pattern = "zoneid=", replacement = "", fixed = TRUE)
  }
  
  print(i)
} # end of big loop


writePath<-"C:\\Users\\yossi.spektor\\Documents\\Reports\\Environment\\adSourcesDF.csv"
write.csv(x = adSourcesDF, file = writePath, row.names = FALSE)

#################################################### Ironsource
#get tagtify demand tags
tagtify<-jsonlite::fromJSON("C:\\Users\\yossi.spektor\\Documents\\Reports\\tagtify1109.txt")

# str(tagtify)
# tagtify$name[1]

#prepare the DF for
tagtifyDF<-data.frame(matrix(nrow = length(tagtify$name), ncol = 8))

colnames(tagtifyDF)[1]<-"name"
colnames(tagtifyDF)[2]<-"id"
colnames(tagtifyDF)[3]<-"url"
colnames(tagtifyDF)[4]<-"advertiserTagId"
colnames(tagtifyDF)[5]<-"adServerDomain"
colnames(tagtifyDF)[6]<-"adServerDomainSuffix"
colnames(tagtifyDF)[7]<-"adServerDomainCom"
colnames(tagtifyDF)[8]<-"match"
#extract the adserver domain com and populate the DF with demand tags properties
for(i in 1:length(tagtify$name)) {
  tagtifyDF$name[i]<-tagtify$name[i]
  tagtifyDF$id[i]<-tagtify$id[i]
  tagtifyDF$url[i]<-tagtify$url[i]
  tagtifyDF$adServerDomain[i]<-as.character(urltools::suffix_extract(domain(tagtifyDF$url[i]))[3])
  tagtifyDF$adServerDomainSuffix[i]<-as.character(urltools::suffix_extract(domain(tagtifyDF$url[i]))[4])
  tagtifyDF$adServerDomainCom[i]<-paste(tagtifyDF$adServerDomain[i], tagtifyDF$adServerDomainSuffix[i], sep = ".")
  
}


View(tagtifyDF)

# get the list if unique ad servers in tagtify
uniqueAdServers<-unique(tagtifyDF$adServerDomainCom)
uniqueAdServers<-uniqueAdServers[order(uniqueAdServers, decreasing = FALSE )]

#write the tagtify csv
writePath<-"C:\\Users\\yossi.spektor\\Documents\\Reports\\tagtify2streamTransition\\tagtifyDF.csv"
write.csv(x = tagtifyDF, file = writePath, row.names = FALSE)

##################################################################################################################

# extract ad server ID's in tagtify demand tags
for(i in 1:nrow(tagtifyDF)) {
  if(tagtifyDF$adServerDomainCom[i]=="lkqd.net") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "sid=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "sid=", replacement = "", fixed = TRUE)
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="advertising.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
    split<-split[[1]][6]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-split
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="tremorhub.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "adCode=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "adCode=", replacement = "", fixed = TRUE)
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="spotxchange.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
    split<-split[[1]][6]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-split
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="aerserv.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    split<-split[[1]][1]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "plc=", replacement = "", fixed = TRUE)
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="yumenetworks.com") {
    if(grepl(pattern = "dynamic_preroll_playlist", x = tagtifyDF$url[i], fixed = TRUE)) {
      split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
      split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
      split<-split[[1]][1]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "domain=", replacement = "", fixed = TRUE)
    } else if(grepl(pattern = "http://plg", x = tagtifyDF$url[i], fixed = TRUE)) {
      split<-strsplit(x = tagtifyDF$url[i], split = "/", fixed = TRUE)   #split the vast url
      split<-split[[1]][6]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      tagtifyDF$advertiserTagId[i]<-split
    } else if(grepl(pattern = "https://spl", x = tagtifyDF$url[i], fixed = TRUE)) {
      split<-strsplit(x = tagtifyDF$url[i], split = "/", fixed = TRUE)   #split the vast url
      split<-split[[1]][6]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      tagtifyDF$advertiserTagId[i]<-split
    } else{
      tagtifyDF$advertiserTagId[i]<-"error"
    }
    } # end of Yume
  
  if(tagtifyDF$adServerDomainCom[i]=="stickyadstv.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "&", fixed = TRUE)   #split the vast url
    
    # find where the zoneId id
    zone<-sapply(split, function(x) grep(pattern = "zoneId", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "zoneId=", replacement = "", fixed = TRUE)
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="inmobi.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    split<-split[[1]][1]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "plid=", replacement = "", fixed = TRUE)
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="rubiconproject.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "zone_id", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "zone_id=", replacement = "", fixed = TRUE)
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="optimatic.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "id=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "id=", replacement = "", fixed = TRUE)
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="pubmatic.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "adId=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "adId=", replacement = "", fixed = TRUE)
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="btrll.com") {
    if(grepl(pattern = "mobile.btrll.com", x = tagtifyDF$url[i], fixed = TRUE)) {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "siteId=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "siteId=", replacement = "", fixed = TRUE)
    } else if(grepl(pattern = "http://vast", x = tagtifyDF$url[i], fixed = TRUE)) {
      split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
      split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
      split<-split[[1]][5]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      tagtifyDF$advertiserTagId[i]<-split
    } else {
      tagtifyDF$advertiserTagId[i]<-"error"
    }
  } # end of brightroll
  
  if(tagtifyDF$adServerDomainCom[i]=="thirdpresence.com") {
    
    if(grepl(pattern = "adid=", x = tagtifyDF$url[i], fixed = TRUE)) {
      split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
      split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
      zone<-sapply(split, function(x) grep(pattern = "adid=", x = x, fixed = TRUE))
      split<-split[[1]][zone]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "adid=", replacement = "", fixed = TRUE)
      
    } else if(grepl(pattern = "playerid=", x = tagtifyDF$url[i], fixed = TRUE)) {
      split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
      split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
      zone<-sapply(split, function(x) grep(pattern = "playerid=", x = x, fixed = TRUE))
      split<-split[[1]][zone]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "playerid=", replacement = "", fixed = TRUE)
      
    } else {
      tagtifyDF$advertiserTagId[i]<-"error"
    }
    
  } # end of thirdpresence
  
  if(tagtifyDF$adServerDomainCom[i]=="videoplaza.tv") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "s=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "s=", replacement = "", fixed = TRUE)
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="springserve.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
    split<-split[[1]][5]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-split
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="tubemogul.com") {
    if(grepl(pattern = "rtb.tubemogul.com", x = tagtifyDF$url[i], fixed = TRUE)) {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
    split<-split[[1]][5]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-split
    } else if(grepl(pattern = "pv.tubemogul.com", x = tagtifyDF$url[i], fixed = TRUE)) {
      split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
      split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
      split<-split[[1]][6]  #find the part that contains the tag ID
      
      # replace that "parameter=" with ""
      tagtifyDF$advertiserTagId[i]<-split
    } else {
      tagtifyDF$advertiserTagId[i]<-"error"
    }
  } # end of tubemogul
  
  if(tagtifyDF$adServerDomainCom[i]=="pokkt.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "appId=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "appId=", replacement = "", fixed = TRUE)
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="streamrail.net") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
    split<-split[[1]][7]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    if(is.na(split)) {
      tagtifyDF$advertiserTagId[i]<-"error"
    } else {
      tagtifyDF$advertiserTagId[i]<-split
    }
    
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="altitude-arena.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "uid=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "uid=", replacement = "", fixed = TRUE)
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="yashi.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][1], split = "&", fixed = TRUE)
    split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
    split<-split[[1]][4]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-split
  }
  
  
  if(tagtifyDF$adServerDomainCom[i]=="smartadserver.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "pgid=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "pgid=", replacement = "", fixed = TRUE)
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="rollmob.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][1], split = "/", fixed = TRUE)
    split<-split[[1]][5]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-split
  }
  
  if(tagtifyDF$adServerDomainCom[i]=="provenpixel.com") {
    split<-strsplit(x = tagtifyDF$url[i], split = "?", fixed = TRUE)   #split the vast url
    split<-strsplit(x = split[[1]][2], split = "&", fixed = TRUE)
    zone<-sapply(split, function(x) grep(pattern = "zoneid=", x = x, fixed = TRUE))
    split<-split[[1]][zone]  #find the part that contains the tag ID
    
    # replace that "parameter=" with ""
    tagtifyDF$advertiserTagId[i]<-sub(x = split, pattern = "zoneid=", replacement = "", fixed = TRUE)
  }
} # end of big loop

View(tagtifyDF[tagtifyDF$adServerDomainCom=="provenpixel.com", c("url", "advertiserTagId", "name")])
##################################################################################################################

sum(tagtifyDF$adServerDomainCom=="optimatic.com")

#count all ad servers
adServerCount<-sapply(uniqueAdServers, function(x) sum(tagtifyDF$adServerDomainCom==x))

adServerCount[2][[1]]

# create a df with adserver names and counts
countDF<-data.frame(matrix(nrow = length(uniqueAdServers), ncol = 2))
countDF$adServerName<-NULL
countDF$count<-NULL
for(i in 1:length(uniqueAdServers)) {
  countDF$adServerName[i]<-uniqueAdServers[i]
  countDF$count[i]<-adServerCount[i][[1]]
}
countDF<-countDF[, c(3,4)]
countDF<-countDF[order(countDF$count, decreasing = TRUE),]

##############################################################

################      MATCH          ###############
for(i in 1:nrow(tagtifyDF)) {
  
  for(k in 1:nrow(adSourcesDF)) {
    if(tagtifyDF$advertiserTagId[i] %in% adSourcesDF$advertiserTagId) {
      tagtifyDF$match[i]<-"true"
    }
  }
  
}

View(tagtifyDF)

sum(tagtifyDF$match=="true", na.rm = TRUE)

# read the file with ad servers done
adServersDone<-read.csv(file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\tagtify2streamTransition\\adServersDone.csv",
                       skip = 0, stringsAsFactors=FALSE, dec = ".",
                       header=TRUE) 

#create the final DF
final<-data.frame()

#subset to only the adServersDone
final<-tagtifyDF[tagtifyDF$adServerDomainCom %in% adServersDone$adServers,]
sum(final$match=="true", na.rm = TRUE)



# read the file with tagtify imps last month
tagtifyImps<-read.csv(file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\tagtify2streamTransition\\tagtifyImps.csv",
                        skip = 0, stringsAsFactors=FALSE, dec = ".",
                        header=TRUE) 
tagtifyImps<-tagtifyImps[,c(1,7)]    #subset the DF to demand name and imps

#merge final and tagtifyImps based on imps
merged<-merge(x = final, y = tagtifyImps, by.x = "name", by.y = "demand", all.x = TRUE)
View(merged)
# subset merged to only where there was no match
mergedFinal<-merged[is.na(merged$match),]

View(mergedFinal)


writePath<-"C:\\Users\\yossi.spektor\\Documents\\Reports\\tagtify2streamTransition\\mergedFinal.csv"
write.csv(x = mergedFinal, file = writePath, row.names = FALSE)



