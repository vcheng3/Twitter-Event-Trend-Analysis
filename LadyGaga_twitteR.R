install.packages("twitteR")
install.packages("ggmap")
install.packages("RSQLite")

library(twitteR)
library(ggmap)
library(plyr)
library(RSQLite)

#The keys left blank, these need to be configured to your own twitter account. You must have a twitter dev account.

CONSUMERKEY = 
CONSUMERSECRET = 
ACCESSTOKEN =
ACCESSSECRET = 

setup_twitter_oauth(CONSUMERKEY,CONSUMERSECRET,ACCESSTOKEN,ACCESSSECRET)

tweets1 <- searchTwitteR('#ladygaga', n=2000)
head(tweets1)

df1 <- twListToDF(tweets1)
head(df1)

df1$screenName

userInfo <- lookupUsers(df1$screenName)
userInfoDF <- twListToDF(userInfo)

locations <- geocode(userInfoDF$location)
head(locations)

na.omit(locations)
omitDataFrame <- na.omit(locations) 

mapofusa <-data("usaMapEnv")
map(database = "state", col = "black", fill = FALSE)
map.text("state")

# points(omitDataFrame$lon, omitDataFrame$lat)

bubbledf <- count(omitDataFrame)
points(bubbledf$lon, bubbledf$lat, cex = bubbledf$freq*0.3, pch = 21, bg = "red")

sql_lite_file = tempfile()
register_sqlite_backend(sql_lite_file)
store_tweets_db(tweets1)

from_db = load_tweets_db()
head(from_db)
from_db_df <- twListToDF(from_db)

