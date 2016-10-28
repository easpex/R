landingPage<-"https://www.vidbooster.tv"
picture<-"https://deltacdn12.net/pics/vidbooster/vidbooster300x250.jpg"


opening<-'<div id="isp_player"></div>\n<script>\nvar params = {'

platform<-"       platform: 'desktop',"
publisher<-"       publisher: '161',"
campaign<-"       campaign: '${CampID}',"
exchange  <-  "       exchange: '${Pub}',"
placement   <- "       placement: '${CrID}',"
demandType  <-  "       demandType: 'url',"
waterfall <-   "       waterfall: 'WATERFALL_NAME_REPLACE',"
domain  <-  "       domain: '${DetectedDomain}',"
width <-   "       width: 300,"
height  <-  "       height: 250,"
trackingId  <-  "       trackingId: 'index.html',"
passbackTag   <- paste("       passbackTag: ", "'", "<a href=", '"', landingPage, '"', " target=", '"_blank"', "><img src=", '"', picture, '"', "></a", ">',", sep = "")
clickid <-   "       clickid: '${ImpID}',"
autoPlay  <-  "       autoPlay: true,"
autoSound   <- "       autoSound: false,"
playCount   <- "       playCount: 9,"
containerId   <- "       containerId: 'isp_player',"
videoContentUrl <-   "       videoContentUrl: 'https://deltacdn12.net/Penalty_Short.mp4',"
coverImg  <-  paste("       coverImg: ", "'", picture, "'", '"', sep = "")
paidPrice   <- "       paidPrice: '${AdvCost}',"
preRoll <-   "       preRoll: 3,"
urls<-"           urls: {"
WATERFALL_URL   <-   paste('              WATERFALL_URL: ','"joey.kosheryashin.com"',',', sep = "")
CDN_URL  <-    paste('              CDN_URL: ', '"xmax.kosheryashin.com"', ',', sep = "")
SERVICE_URL    <-  paste('              SERVICE_URL: ', '"maximus.kosheryashin.com"', ',', sep = "")
EVENT_URL   <-   paste('              EVENT_URL: ', '"amalek.kosheryashin.com"', ',', sep = "")
RTVP_URL   <-   paste('              RTVP_URL: ', '"amalek.kosheryashin.com"', ',', sep = "")
REPORTING_URL   <-   paste('              REPORTING_URL: ', '"j.ToWambleesha.com"', "\n}};", sep = "")
    
    
ending<-paste("</script>\n", '<script src=', '"https://xmax.kosheryashin.com/player/player.min.js"', "></script>", sep = "")  

creative<-paste(opening, "\n",
                platform, "\n",
                publisher, "\n",
                campaign, "\n", 
                exchange, "\n",
                placement, "\n",
                demandType, "\n",
                waterfall, "\n",
                domain, "\n",
                width, "\n",
                height, "\n",
                trackingId, "\n",
                passbackTag, "\n",
                clickid, "\n", 
                autoPlay, "\n",
                autoSound, "\n",
                playCount, "\n",
                containerId, "\n",
                videoContentUrl, "\n",
                coverImg, "\n",
                paidPrice, "\n",
                preRoll, "\n",
                urls, "\n",
                WATERFALL_URL, "\n", 
                CDN_URL, "\n",
                SERVICE_URL, "\n",
                EVENT_URL, "\n",
                RTVP_URL, "\n",
                REPORTING_URL, "\n",
                ending, sep = "")

write(x = creative, file = "C:\\Users\\yossi.spektor\\Documents\\Reports\\autoCreative\\autoCreativeTest.txt")
      