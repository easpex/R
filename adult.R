adult<-read.csv(file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\ADULT BLACKLIST\\adult.csv",
                  skip = 0, stringsAsFactors=FALSE, dec = ".",
                  header=TRUE) 
adultKeywords<-read.csv(file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\ADULT BLACKLIST\\adultKeywords.csv",
                skip = 0, stringsAsFactors=FALSE, dec = ".",
                header=TRUE) 
head(adultKeywords)
head(adult)
adult$positiveMatch<-""

for(i in 1:nrow(adult)) {
  
  for(k in 1:nrow(adultKeywords)) {
    
    if(grepl(pattern = adultKeywords$KEYWORDS[k], x = adult$domain[i], fixed = TRUE)) {
      adult$positiveMatch[i]<-"true"
      k<-nrow(adultKeywords)
    } # end of if
    
  
} # end of k loop
  
  if( (i %% 500) == 0) {
    print(paste("i=", i))
  }
} # end of i loop

adult[adult$positiveMatch != "",]
View(adult[adult$positiveMatch=="true",])

grepl(pattern = adultKeywords$KEYWORDS[1], x = adult$domain[1], fixed = TRUE)


