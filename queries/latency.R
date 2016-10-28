drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv = drv, 
                 dbname = "ironlabs",
                 host = "redshift-ironlabs.infra-team.com",
                 user = "yossi_spektor",
                 password = "2eWV6cLn",
                 port = 5439)                 
qLatency<-

#  dataLatency<-dbGetQuery(con, qLatency)