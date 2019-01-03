#Install
install.packages("itunesr") # for scraping reviews
install.packages("wordcloud") # for generating word clouds
install.packages("highcharter") # graphing
install.packages("dplyr") #table binding
install.packages("lubridate") # time series plotting
install.packages("sentimentr") # sentiment analysis
install.packages("tm")  # for text mining
install.packages("SnowballC") # for text stemming
install.packages("RColorBrewer") # color palettes
#Load
library(itunesr)
library(plyr)
library(highcharter)
library(lubridate)
library(highcharter)
library(dplyr)
library(lubridate)
library(sentimentr)
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

#Review Scraper

nbc_reviews <- bind_rows(lapply(1:10, function(n) {getReviews(442839435,'us',n)}))

write.csv(nbc_reviews, file = "nbc2.csv")

#Ratings Trend

#reviews into date table
dt <- nbc_reviews
# extract dates column
dt$Date <- as.Date(dt$Date)
# extract ratings column
dt$Rating <- as.numeric(dt$Rating)
#Combine date and rating
dt <- dt %>% select(Date,Rating) %>% group_by(Date) %>% summarise(Rating = round(weighted.mean(Rating),1))
#graph
highchart() %>%   hc_add_series_times_values(dt$Date,dt$Rating, name = 'Average Rating')

#Sentiment Analysis 

# Column with only reviews
reviews_only <- as.character(nbc_reviews$Review)
#sentimentr table
sentiment_scores <- reviews_only %>% sentiment_by(by=Date)
#Graph Sentiment over time
highchart() %>% hc_xAxis(sentiment_scores$element_id) %>% hc_add_series(sentiment_scores$ave_sentiment, name = 'Reviews Sentiment Scores')

highchart() %>%   hc_add_series_times_values(dt$Date,sentiment_scores$ave_sentiment, name = 'Average Rating')


#Wordcloud
wordcloud::wordcloud(reviews_only,max.words = 200, random.order = FALSE,colors = brewer.pal(2, 'Dark2'))




#Column Names
names(nbc_reviews)

#Export CSV
write.csv(nbc_reviews,file = "nbc.csv")
write.csv(sentiment_scores, file = "Sentiment_Scores.csv")



write.csv(t,file="NBC_Total.csv")

