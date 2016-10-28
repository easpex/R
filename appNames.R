
require(XML)
require(RCurl)

bundleIdPath<-"C:\\Users\\yossi.spektor\\Documents\\Reports\\bundleIds\\bundleIds.csv"


bundleIds<-read.csv(file = bundleIdPath,
                       skip = 0, stringsAsFactors=FALSE, dec = ".",
                       header=TRUE) 

head(bundleIds)

# FOR Android
resultAndroid<-""
for(i in 1:nrow(bundleIds)) {
  bundleString<-sprintf("https://play.google.com/store/apps/details?id=%s",bundleIds[[1]][i])  
  
  #download HTML
  html <- getURL(bundleString, followlocation = TRUE)
  
  # parse html
  doc = htmlParse(html, asText=TRUE)
  plain.text <- xpathSApply(doc, "//text()[not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)][not(ancestor::form)]", xmlValue)
  resultAndroid<-sprintf("%s^%s=%s", resultAndroid, bundleIds[[1]][i], plain.text [1])
  
}

resultAndroid<-strsplit(x = resultAndroid, fixed = TRUE, split = "^")
write.csv(x = resultAndroid, file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\bundleIds\\bundleIdsAndroid.csv", row.names = FALSE)




# FOR IOS
resultIOS<-""
for(i in 1:nrow(bundleIds)) {
  bundleString<-sprintf("http://itunes.apple.com/en/app/id%s",bundleIds[[1]][i])  
  
  #download HTML
  html <- getURL(bundleString, followlocation = TRUE, ssl.verifyhost = 0L, ssl.verifypeer = 0L)
  
  # parse html
  doc = htmlParse(html, asText=TRUE)
  plain.text <- xpathSApply(doc, "//text()[not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)][not(ancestor::form)]", xmlValue)
  resultIOS<-sprintf("%s^%s=%s", resultIOS, bundleIds[[1]][i], plain.text[1])
  
}


resultIOS<-strsplit(x = resultIOS, fixed = TRUE, split = "^")
write.csv(x = resultIOS, file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\bundleIds\\bundleIdsIOS.csv", row.names = FALSE)


browseURL(url = "http://cnn.com")
