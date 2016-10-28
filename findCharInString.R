tagtify<-read.csv(file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\tagtify2streamTransition\\tagtify2streamTransition.csv",
                       skip = 0, stringsAsFactors=FALSE, dec = ".",
                       header=TRUE) 
head(tagtify)
##   c("[DOMAIN]",	"[WIDTH]",	"[HEIGHT]",	"[BUNDLE_ID]",	"[APP_NAME]",	"[APP_URL]")
appMacros<-c("[BUNDLE_ID]",	"[APP_NAME]",	"[APP_URL]", "[UID]")
nonAppMacros<-c("[DOMAIN]")


tagtify$macrosMissing<-""
for(i in 1:nrow(tagtify)) {
  
  count<-0
  if(grepl(pattern = "App", x = tagtify$Name[i], fixed = TRUE)){
  for(j in 1:length(appMacros)) {
    
    if(!grepl(pattern = appMacros[j], x = tagtify$URL[i], fixed = TRUE)) {
      count<-count+1
      tagtify$macrosMissing[i]<-count
    }
  }
  } # end of 1st inner for
  
    
    if(!grepl(pattern = "App", x = tagtify$Name[i], fixed = TRUE)){

      for(k in 1:length(nonAppMacros)) {
      if(!grepl(pattern = nonAppMacros[k], x = tagtify$URL[i], fixed = TRUE)) {

          count<-count+1
          tagtify$macrosMissing[i]<-count
        } # end of if

      } # end of 2nd inner for
     } # end of if != App
  
  }# end of outer for


    
  
View(tagtify)


  !grepl(pattern = appMacros[4], x = tagtify$URL[1], fixed = TRUE)



write.csv(x = tagtify, 
          file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\tagtify2streamTransition\\tagtify2streamTransitionResult.csv",
          row.names = FALSE)



