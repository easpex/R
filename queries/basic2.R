require(RPostgreSQL)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv = drv, 
                 dbname = "video",
                 host = "isvid.infra-team.com",
                 user = "yossi_spektor",
                 password = "2eWV6cLn",
                 port = 5439)                 
q2<-"SELECT 
TRUNC(ts) AS DATE,
--EXTRACT(HOUR FROM ts) AS HOUR,
playermode,
vpaidmode,
demand,
--abg,
--demand,
SUM(DECODE(state,'inventory',1)) AS inventory,
SUM(DECODE(state,'waterfallOK',1)) AS waterfallOK,
SUM(DECODE(state,'adAttempt',1)) AS ad_attempts,
SUM(DECODE(state,'adOpportunity',1)) AS ad_opportunities,
SUM(DECODE(state,'impression',1)) AS impressions,
SUM(DECODE(state,'start',1)) AS start,
SUM(DECODE(state,'complete',1)) AS complete
FROM video_player_logs
WHERE ts BETWEEN '2016-03-01' AND '2016-04-10' 
--WHERE (ts BETWEEN '2016-03-17' AND '2016-03-20')  --campaign in ('2160765', '2169868', '2169869')
--WHERE ts > getdate() - interval '120 minutes'
GROUP BY 1,2,3,4;
"

#  data2<-dbGetQuery(con, q2)
head(data2)
nrow(data2)

aggr<-with(data2, aggregate(cbind(inventory = inventory,
                                 # waterfallOK = waterfallOK,
                                 ad_attempts = ad_attempts,
                                 ad_opportunities = ad_opportunities,
                                 impressions = impressions,
                                 complete = complete,
                                 start = start),
                           
                           by=list(uid = uid
                                   #c_ver = c_ver
                                   #,platform = platform
                           ),
                           FUN = sum, na.rm = TRUE))

aggr<-aggr[aggr$c_ver %in% c("1.1.9", "1.0.22"),]
aggr<-aggr[aggr$platform %in% c("mobile", "desktop"),]
aggr["imps/inv"]<-aggr$impressions/aggr$inventory
aggr["att/inv"]<-aggr$ad_attempts/aggr$inventory
aggr["opps/inv"]<-aggr$ad_opportunities/aggr$inventory
aggr["opps/att"]<-aggr$ad_opportunities/aggr$ad_attempts
aggr["imps/opps"]<-aggr$impressions/aggr$ad_opportunities
aggr["completion"]<-aggr$complete/aggr$start
aggr["wtfOK/inv"]<-aggr$waterfallok/aggr$inventory
aggr["imps/att"]<-aggr$impressions/aggr$ad_attempts

data2[order(data2$hour, decreasing = TRUE),]
aggr<-data2[data2$c_ver %in% c('1.1.12', '1.1.14'),]
data2[is.na(data2$uid),]
data2["imps/att"]<-data2$impressions/data2$ad_attempts
data2["opps/att"]<-data2$ad_opportunities/data2$ad_attempts
data2["completion"]<-data2$complete/data2$start
data2["completion_imps"]<-data2$complete/data2$impressions
file<-aggr
file<-data2
writePath<-"C:\\Users\\yossi.spektor\\Documents\\Reports\\mar-apr_crMoreThan100.csv"
write.csv(x = file, file = writePath, row.names = FALSE)



aggr<-data2
data2[is.na(data2$longitude),]
data2[is.na(data2$latitude),]
data2[!is.na(data2$longitude), ]
data2[!is.na(data2$latitude),]



aggr<-read.csv(file = "",
         skip = 0, stringsAsFactors=FALSE, dec = ".",
         header=TRUE) 

