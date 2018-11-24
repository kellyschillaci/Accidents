install.packages("jsonlite")
library(jsonlite)

install.packages("RCurl")
library("RCurl")
MarylandURL <-
  "http://data.maryland.gov/api/views/pdvh-tf2u/rows.json?accessType=DOWNLOAD"
apiResult <- getURL(MarylandURL)
head(apiResult)
results <- fromJSON(apiResult)
results[2]
results$data
WorkingData <- results$data
str(WorkingData)
WorkingData <- WorkingData[,-1:-8]
WorkingData
colnames(WorkingData) <- c("CASE_NUMBER", "BARRACK", "ACC_DATE", "ACC_TIME","ACC_TIME_CODE","DAY_OF_WEEK","ROAD","INTERSECT_ROAD","DIST_FROM_INTERSECT","DIST_DIRECTION","CITY_NAME","COUNTY_CODE","COUNTY_NAME","VEHICLE_COUNT","PROP_DEST","INJURY","COLLISION_WITH_1","COLLISION_WITH_2")
b <- unlist(WorkingData)
a <- as.data.frame.matrix(b)
a
str(b)
colnames(a)
CountSunday <- length(which(a$DAY_OF_WEEK == "SUNDAY   "))
CountInjury <- length(which(a$INJURY == "YES"))

install.packages("sqldf")
install.packages("RSQLite")
install.packages("tcltk2")
library("sqldf")
library("RSQLite")
library("tcltk2")


Accidents_On_Sunday <- sqldf('select count(DAY_OF_WEEK) as Accidents_On_Sunday from a where DAY_OF_WEEK = "SUNDAY   "')
Accidents_With_Injury <- sqldf('select count(*) as Accidents_With_Injury from a where INJURY = "YES"')

List_of_Injuries_by_Day <- sqldf('select DAY_OF_WEEK, count(*) as Number_Of_Accidents from a group by DAY_OF_WEEK')

Sunday <- tapply(a$CASE_NUMBER, a$DAY_OF_WEEK=='SUNDAY   ', length)

Injuries <- tapply(a$CASE_NUMBER, a$INJURY, length)

AccidentsAndInjuriesList <- tapply(a$CASE_NUMBER, list(a$INJURY=='YES', a$DAY_OF_WEEK),length)