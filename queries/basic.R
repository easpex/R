require(RPostgreSQL)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv = drv, 
                 dbname = "ironlabs",
                 host = "redshift-ironlabs.infra-team.com",
                 user = "yossi_spektor",
                 password = "2eWV6cLn",
                 port = 5439)                 
q<-"SELECT 
--TRUNC(ts) AS DATE,
      --EXTRACT(HOUR FROM ts) AS HOUR,
waterfall,
domain,
uid,
SUM(DECODE(state,'inventory',1)) AS inventory,
SUM(DECODE(state,'waterfallOK',1)) AS waterfallOK,
SUM(DECODE(state,'adAttempt',1)) AS ad_attempts,
SUM(DECODE(state,'adOpportunity',1)) AS ad_opportunities,
SUM(DECODE(state,'impression',1)) AS impressions,
SUM(DECODE(state,'start',1)) AS start,
SUM(DECODE(state,'complete',1)) AS complete
FROM video_player_logs
WHERE ts >= CURRENT_DATE AND waterfall='gginapp_wl_app_161_us' 
--WHERE (ts BETWEEN '2016-03-13' AND '2016-03-13') AND waterfall='batteryDoctorVPAID_app_dc_us' --AND demand='Aerserv-App-US-RON-6'
--WHERE ts > getdate() - interval '2 hours'
GROUP BY 1,2,3;
"

#  data<-dbGetQuery(con, q)
head(data)
nrow(data)

aggr<-with(data, aggregate(cbind(inventory = inventory,
                                 waterfallok = waterfallok,
                                 ad_attempts = ad_attempts,
                                 ad_opportunities = ad_opportunities,
                                 impressions = impressions,
                                 complete = complete,
                                 start = start),
                           
                           by=list(# demand = demand
                             c_ver = c_ver
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

data[order(data$hour, decreasing = TRUE), ]
aggr<-data[data$c_ver %in% c('1.1.19', '1.1.20'), ]

data["imps/att"]<-data$impressions/data$ad_attempts
data["opps/att"]<-data$ad_opportunities/data$ad_attempts
data["completion"]<-data$complete/data$start
data["completion_imps"]<-data$complete/data$impressions
file<-aggr<-data
writePath<-"C:\\Users\\yossi.spektor\\Documents\\Reports\\abid7785_brightroll.csv"
write.csv(x = file, file = writePath, row.names = FALSE)

aggr<-aggr[aggr$c_ver %in% c('1.1.23', '1.1.22', '1.1.21'),]


sum(data[is.na(data$uid), "inventory"], na.rm=TRUE)
head(data[order(data$inventory, decreasing = TRUE),])

write.csv(x = data[is.na(data$uid),], 
          file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\blankuid161May6.csv", row.names = FALSE)