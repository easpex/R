
env<-read.csv(file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\Environment\\environment15.09.16.csv",
                       skip = 0, stringsAsFactors=FALSE, dec = ".",
                       header=TRUE) 
head(env)
env$adSourceENV<-NULL

#determine ad source env
for(i in 1:nrow(env)) {
  env$adSource[i]<-tolower(env$adSource[i])
  
  if(grepl(pattern = "-mw-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"mw"
  } else if(grepl(pattern = "-app-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"app"
  } else if(grepl(pattern = "-small-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  } else if(grepl(pattern = "-large-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  } else if(grepl(pattern = "-medium-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  } else if(grepl(pattern = "-mix-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  } else if(grepl(pattern = "-m/l-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  } else if(grepl(pattern = "-mobileweb-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"mw"
  } else if(grepl(pattern = "-m-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  } else if(grepl(pattern = "-s-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  } else if(grepl(pattern = "-l-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  }else if(grepl(pattern = "-meium/large-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  } else if(grepl(pattern = "-medium/large-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  }else if(grepl(pattern = "- large-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  }else if(grepl(pattern = "-large/medium-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  }else if(grepl(pattern = "- m/l-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  }else if(grepl(pattern = "-s/m-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"desktop"
  }else if(grepl(pattern = "-inapp-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"app"
  }else if(grepl(pattern = "- mw-", x = env$adSource[i], fixed = TRUE, ignore.case = TRUE)) {
    env$adSourceENV[i]<-"mw"
  }else {
    env$adSourceENV[i]<-"error"
  }
} # end of for
View(env[env$adSourceENV=="error",])



# loop to find the platform of traffic channels
env$tcENV<-NULL
env$surrounding<-NULL
for(i in 1:nrow(env)) {
  env$trafficChannel[i]<-tolower(env$trafficChannel[i])
  
  if(grepl(pattern = "mw", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
          env$tcENV[i]<-"mw"
  # last<-regexpr(pattern = "mw", text = env$trafficChannel[i], fixed = TRUE)
  # before<-substring(text = env$trafficChannel[i], first = last-2, last = last)
  # after<-substring(text = env$trafficChannel[i], first = last+2, last = last+4)
  # env$surrounding[i]<-paste(before, after, sep = "|")
  } else if(grepl(pattern = "-app-", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"app"
  } else if(grepl(pattern = "-small-", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"desktop"
  } else if(grepl(pattern = "-large-", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"desktop"
  } else if(grepl(pattern = "-medium-", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"desktop"
  } else if(grepl(pattern = "-mix-", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"desktop"
  } else if(grepl(pattern = "-m/l-", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"desktop"
  } else if(grepl(pattern = "-mobileweb-", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"mw"
  } else if(grepl(pattern = "-m-", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"desktop"
  } else if(grepl(pattern = "-s-", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"desktop"
  } else if(grepl(pattern = "-l-", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"desktop"
  }else if(grepl(pattern = "_dp_", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"desktop"
  } else if(grepl(pattern = "_mw_", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"mw"
  }else if(grepl(pattern = "_app_", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"app"
  }else if(grepl(pattern = "large-", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"desktop"
  }else if(grepl(pattern = "-inapp-", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"app"
  } else if(grepl(pattern = "-mw-", x = env$trafficChannel[i], fixed = TRUE, ignore.case = TRUE)) {
    env$tcENV[i]<-"mw"
  }else {
    env$tcENV[i]<-"error"
  }
} # end of for
View(env[env$tcENV=="error",])

# see breakdown by platform
sapply(unique(env$adSourceENV), function(x) sum(env$adSourceENV==x, na.rm = TRUE))
sapply(unique(env$tcENV), function(x) sum(env$tcENV==x, na.rm = TRUE))

View(env[env$adSourceENV=="error",])

# match
env$match<-NULL
for(i in 1:nrow(env)) {
  if(env$adSourceENV[i]==env$tcENV[i] && env$tcENV[i]=="error") {
    env$match[i]<-"error"

  } else
  if(env$adSourceENV[i]==env$tcENV[i]) {
    env$match[i]<-"true"
  } else {
    env$match[i]<-"false"
  }
}

View(env[env$match=="false",])



writePath<-"C:\\Users\\yossi.spektor\\Documents\\Reports\\Environment\\result15.09.16.csv"
write.csv(x = env, file = writePath, row.names = FALSE)
