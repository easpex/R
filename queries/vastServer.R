require(RPostgreSQL)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv = drv, 
                 dbname = "ironlabs",
                 host = "redshift-ironlabs.infra-team.com",
                 user = "yossi_spektor",
                 password = "2eWV6cLn",
                 port = 5439)     



v<-"SELECT
TRUNC(ts) AS DATE,
--EXTRACT(HOUR FROM ts) AS HOUR,
placement, 
waterfall,
countrycode,
demand,
SUM(DECODE(state,'inventory',1)) AS inventory,
--SUM(DECODE(state,'waterfallOK',1)) AS waterfallOK,
SUM(DECODE(state,'adAttempt',1)) AS ad_attempts,
SUM(DECODE(state,'adOpportunity',1)) AS ad_opportunities,
SUM(DECODE(state,'impression',1)) AS impressions,
SUM(DECODE(state,'complete',1)) AS complete,
SUM(DECODE(state,'start',1)) AS start,
SUM(DECODE(state,'clicks',1)) AS click  
FROM  afcast.video_player_logs 
--WHERE ts > getdate() - interval '2 days' AND placement LIKE '%outfit%' AND s_ver IS NOT NULL
WHERE ts >= CURRENT_DATE AND s_ver IS NOT NULL AND placement LIKE '%outfit%' AND countrycode='IN'
--WHERE (ts BETWEEN '2016-03-11' AND '2016-03-12') AND placement LIKE '%outfit%' AND s_ver IS NOT NULL
GROUP BY 1,2,3,4,5;
--ORDER BY ad_attempts DESC;
"

#  vvData<-dbGetQuery(con, v)

vv<-vvData
head(vv)
nrow(vv)


vv["imps/inv"]<-vv$impressions/vv$inventory
vv["att/inv"]<-vv$ad_attempts/vv$inventory
vv["opps/inv"]<-vv$ad_opportunities/vv$inventory
vv["opps/att"]<-vv$ad_opportunities/vv$ad_attempts
vv["imps/opps"]<-vv$impressions/vv$ad_opportunities
vv["completion"]<-vv$complete/vv$start
View(vv)

vv[!is.na(vv$uid),]
