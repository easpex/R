spotDailyrev<-function(date = "2015-3-19") {

options("scipen"=100, "digits"=4)  #no scientific notation!
require(mailR) #in order to send the email with the report as attachment

if(missing(date)) stop("Enter a date!")
# if(nchar(date) != 10) stop("Enter a date in this format: yyyy-mm-dd !")

  # yesterdayDate<-as.character(Sys.Date()-1)

yesterdayDate<-date



#declaring all paths to files
URLbyChannelPath<-sprintf("T:\\Video\\AdOps\\spotDailyReport\\original\\IronSource URL by Channel %s.csv",
                          yesterdayDate)
URLbyDealByChannelPath<-sprintf("T:\\Video\\AdOps\\spotDailyReport\\original\\IronSource URL by Deal by Channel %s.csv",
                                yesterdayDate)
writePath<-sprintf("T:\\Video\\AdOps\\spotDailyReport\\result\\spotFeesReport-%s.csv",
                   yesterdayDate)

#reads the URL by Channel report
URLbyChannel<-read.csv(file = URLbyChannelPath,
                       skip = 0, stringsAsFactors=FALSE, dec = ".",
                       header=TRUE) 
#################   URLbyChannel



#finals
unmonetizedCallsFee<-0.007  #fixed unmonetized calls fee
spotShare<-0.2 #spot revshare
directDemandCPMFee<-0.15 #spot CPM fees for direct demand

#fees columns
URLbyChannel$unmonetizedCalls<-URLbyChannel$calls - URLbyChannel$impressions
URLbyChannel$callsFee<-URLbyChannel$unmonetizedCalls * unmonetizedCallsFee / 1000

#aggregates a table by subaffiliate & channel name
URLbyChannelAggr<-with(data = URLbyChannel, aggregate(x = cbind(unmonetizedCallsFee = URLbyChannel$callsFee,
                                                                calls = URLbyChannel$calls),
                                                      by = list(SubAffiliate = SubAffiliate,
                                                                channel_name = channel_name),
                                                      FUN = sum, na.rm = TRUE)
) #end of with()

#creates a mergeId column for later merge with URLByDealByChannelAggr
URLbyChannelAggr$mergeId<-paste(URLbyChannelAggr$SubAffiliate, URLbyChannelAggr$channel_name, sep="|")







#####################        URLbyDealByChannel


#reads the URL by Channel report
URLbyDealByChannel<-read.csv(file = URLbyDealByChannelPath,
                             skip = 0, stringsAsFactors=FALSE, dec = ".",
                             header=TRUE) 


#creates a NULL "demand" column
URLbyDealByChannel$demand<-NULL

#subsets all "deal_id" rows with "spotx" as "spot demand and ALL other rows as "non-spot demand"
URLbyDealByChannel[URLbyDealByChannel$deal_id == "spotx", "demand"]<-"Spot demand"
URLbyDealByChannel[URLbyDealByChannel$deal_id != "spotx", "demand"]<-"non-Spot demand"
URLbyDealByChannelAggr<-with(data = URLbyDealByChannel,
                             aggregate(x = cbind(impressions = URLbyDealByChannel$impressions,
                                                 revenue = URLbyDealByChannel$revenue),
                                       by = list(SubAffiliate = SubAffiliate,
                                                 channel_name = channel_name,
                                                 demand = demand),
                                       FUN = sum, na.rm = TRUE)
) #end of with()


# creates a demandFees column filled with '""' values  
URLbyDealByChannelAggr$demandFees<-""


#the loop checks by row which fees are relevant: either Spot as demand or Spot as ad server
for(i in 1:nrow(URLbyDealByChannelAggr)) {
  if(URLbyDealByChannelAggr$demand[i] == "Spot demand") {
    URLbyDealByChannelAggr$demandFees[i]<-URLbyDealByChannelAggr$revenue[i] * spotShare
  } else {
    if(URLbyDealByChannelAggr$demand[i] == "non-Spot demand") {
      URLbyDealByChannelAggr$demandFees[i]<-URLbyDealByChannelAggr$impressions[i] * directDemandCPMFee / 1000
    } else {
      URLbyDealByChannelAggr$demandFees[i]<-"Warning: Calculation Problem!"
    }
  }
}

# converts the demandFees col to numeric
URLbyDealByChannelAggr$demandFees<-as.numeric(URLbyDealByChannelAggr$demandFees)

# calculates the netRevenue
URLbyDealByChannelAggr$netRevenue<-URLbyDealByChannelAggr$revenue - URLbyDealByChannelAggr$demandFees

#aggregates the table
URLbyDealByChannelAggr<-with(data = URLbyDealByChannelAggr,
                             aggregate(x = cbind(impressions = URLbyDealByChannelAggr$impressions,
                                                 netRevenue = URLbyDealByChannelAggr$netRevenue,
                                                 demandFees = URLbyDealByChannelAggr$demandFees),
                                       by = list(SubAffiliate = SubAffiliate,
                                                 channel_name = channel_name),
                                       FUN = sum, na.rm = TRUE)
) #end of with()

#creates mergeId col for merge with URLByChannelAggr
URLbyDealByChannelAggr$mergeId<-paste(URLbyDealByChannelAggr$SubAffiliate,
                                      URLbyDealByChannelAggr$channel_name, sep="|")


#final table via merge of the 2 sub tables by mergeId
finalTable<-merge(x = URLbyChannelAggr,
                  y = URLbyDealByChannelAggr, by = "mergeId", all.x = TRUE)



#renames the columns to remove the ".x"
colnames(finalTable)[2]<-"SubAffiliate"
colnames(finalTable)[3]<-"channel_name"

finalTable<-finalTable[order(finalTable$netRevenue, decreasing = TRUE),]

#add costCPM column
finalTable$costCPM<-""

#the loop will find all cells which have the word "cost" and then extract the number between "$" and "cost"
#excel recognizes this as numbers, no need to convert to numeric
for(i in 1:nrow(finalTable)) {
  finalTable$costCPM[i]<-substr(x = finalTable[i, "channel_name"],
                                regexpr(pattern = "$", text = finalTable[i, "channel_name"], fixed = TRUE) + 1,
                                regexpr(pattern = "cost", text = finalTable[i, "channel_name"], fixed = TRUE) - 1)
}
#convert costCPM col to num
finalTable$costCPM<-as.numeric(finalTable$costCPM)

#calc rev CPM
finalTable$revenueCPM<-with(finalTable, 1000 * netRevenue / impressions)
#calc the cost
finalTable$cost<-finalTable$costCPM * finalTable$impressions / 1000

#reorders columns
finalTable<-finalTable[, c("SubAffiliate",
                           "channel_name",
                           "calls",
                           "impressions",
                           "cost",
                           "netRevenue",
                           "costCPM",
                           "revenueCPM",
                           "demandFees",
                           "unmonetizedCallsFee")]

write.csv(x = finalTable, file = writePath, row.names = FALSE)

#send an email with the finalTable as attachment
sender <- "yossi.spektor@ironsrc.com"
recipients <- c("yossi.spektor@ironsrc.com",
                "david.amar@ironsrc.com", 
                "yaniv.avigdorov@ironsrc.com",
                "amit.halperin@ironsrc.com",
                "danielle.rosenfeld@ironsrc.com",
                "alejandra.morales@ironsrc.com")
                
                
# send.mail(from = sender,
#           to = recipients,
#           subject = "Daily Spotxchange Ad Server Report",
#           body = "Attached is the daily Spotxchange report which includes affiliates cost and net revenue.",
#           smtp = list(host.name = "smtp.gmail.com", port = 465, 
#                       user.name = "yossi.spektor@ironsrc.com",            
#                       passwd = "sgxndoqnqqalcvjz", ssl = TRUE),
#           authenticate = TRUE,
#           attach.files = writePath,
#           send = TRUE)



} #end of function