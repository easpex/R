## necessary libraries
if(!require(httr)) {
  install.packages("httr")
  require(httr)
}
if(!require(xml2)) {
  install.packages("xml2")
  require(xml2)
}
if(!require(jsonlite)) {
  install.packages("jsonlite")
  require(jsonlite)
}
### CONSTANTS ###

# the result json is surrounded by whitespace. get rid of it
whitespaceForStartIndex<-9

# keyword for searching the json is 'DeferredJS.addBundles('
keywordForJSON<-'DeferredJS.addBundles('

# length of the keyword for json for substring offset
keywordForJSONLength<-nchar('DeferredJS.addBundles(')

# the result json is surrounded by whitespace. get rid of it
whitespaceForLastIndex<-9

# keyword for finding the end of json
keywordForEndOfJSON<-');'

## get the response from okcupid
okcupidResponse<-httr::GET(url = "https://www.okcupid.com/match", 
                    add_headers(c(':authority' = 'www.okcupid.com',
                                  ':method' = 'GET',
                                  ':path' = '/match',
                                  ':scheme' = 'https',
                                  'accept' = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
                                  'accept-encoding' = 'gzip, deflate, sdch, br',
                                  'accept-language' = 'en-US,en;q=0.8',
                                  'cache-control' = 'max-age=0',
                                  'cookie' = '__cfduid=da3981514ff484af750df4840da38a3ae1480956632; signup_exp_2014_09_13=2014_simpleblue; _gat=1; override_session=0; secure_login=1; secure_check=1; session=1931977677529398482%3a13777624405064050050; authlink=76e74a57; __gads=ID=ad321f15111fc125:T=1480956647:S=ALNI_MaqY-gQdfkxzoMRJfFB6fAd5MeN9A; _ga=GA1.2.871898372.1480956635; nano=k%3Diframe_prefix_lock_2%2Ce%3D1480956713023%2Cv%3D1',
                                  'referer' = 'https://www.okcupid.com/profile/Liran-op?cf=home_matches,profile_quickview',
                                  'upgrade-insecure-requests' = '1',
                                  'user-agent' = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36'
                    )))
## get the content from the response
okcupidContent<-content(x = okcupidResponse, type = 'text/html', encoding = 'utf-8')   

# convert the html content into string
okcupidContentString<-toString(okcupidContent)

# the index where the json begins
startIndex<-regexpr(pattern = keywordForJSON,
                    text = okcupidContentString,
                    fixed = TRUE) + keywordForJSONLength + whitespaceForStartIndex

# substring based on the startIndex
okcupidContentString<-substring(text = okcupidContentString, 
                                first = startIndex,
                                last = nchar(okcupidContentString))

# offest the lastIndex with whitespaceForLastIndex
lastIndex<-regexpr(pattern = keywordForEndOfJSON,
                   text = okcupidContentString,
                   fixed = TRUE) - whitespaceForLastIndex
# substring again with lastIndex
okcupidContentString<-substring(text = okcupidContentString, 
                                first = 0, # we only substring from the end
                                last = lastIndex)
# parse the json string into json object
okcupidJSON<-jsonlite::fromJSON(txt = okcupidContentString)

okcupidJSON$param[[2]]$data[[1]]$username

length(okcupidJSON$param[[2]]$data[[1]])
