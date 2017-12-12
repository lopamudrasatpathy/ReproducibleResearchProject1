##################  Reproducible Research (Project1) ############
##By Lopamudra Satpathy


rm(list = ls())
#Loading and preprocessing the data
if(!file.exists("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip")) {
  temp <- tempfile()
  download.file("http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip",temp)
  unzip(temp)
  unlink(temp)
}
activitydata <- read.csv("./activity.csv", sep = ",")
names(activitydata)
str(activitydata)
head(activitydata)
#Packages need to install
install.packages("lubridate")
install.packages("dplyr")
install.packages("reshape2")
install.packages("ggplot2")
library(ggplot2)
library(dplyr)
library(lubridate)
library(reshape2)
#Convert date from factor to date
activitydata$date <- as.Date(activitydata$date)
###Part 1
##What is mean total number of steps taken per day?
#Using reshape2 package
actMeltDat <- melt(activitydata, id= "date",measure.vars = "steps", na.rm = TRUE)
actCastDat <- dcast(actMeltDat,date ~ variable,sum)
# Plot histogram with frequency of steps by day and add a red line showing the mean value
plot(actCastDat$date, actCastDat$steps, type="h", main="Histogram of Daily Steps", xlab="Date", 
     ylab="Steps per Day", col="blue", lwd= 8)
abline(h=mean(actCastDat$steps, na.rm=TRUE), col="red", lwd=2)
Mean <- mean(actCastDat$steps, na.rm = TRUE)
Median <- median(actCastDat$steps, na.rm = TRUE)

###Part2
##What is the average daily activity pattern?
#Average daily pattern by interval
actMeltInt <- melt(activitydata, id="interval", measure.vars = "steps", na.rm = TRUE)
actCastInt <- dcast(actMeltInt, interval ~ variable, sum)
#Time series plot of the average number of steps taken (Average frequency of steps by interval )
plot(actCastInt$interval, actCastInt$steps, type="l",main = "Frequeny of steps per interval",
     xlab = "Interval", ylab = "Steps", col= "purple", lwd = 3 )
abline(h = mean(actCastInt$steps, na.rm = TRUE),col = "blue", lwd = 2)
maxInterval <- actCastInt[which.max(actCastInt$steps),1]

###Part3
##Strategy for imputing missing values
#Calculate totall number of missing values
#To fill the missing value,we choose to replace the value with the mean value.
#We create the function na_fill(data,pervalue), in which data is the activitydata dataframe and pervalue is 
#actCastInt dataframe
sum(is.na(activitydata$steps))
naFill <- function(activitydata, pervalue) {
  naIndex <- which(is.na(activitydata$steps))
  naReplace <- unlist(lapply(naIndex, FUN=function(idx){
    interval = activitydata[idx,]$interval
    pervalue[pervalue$interval == interval,]$steps
  }))
  fillSteps <- activitydata$steps
  fillSteps[naIndex] <- naReplace
  fillSteps
}

activitydataFill <- data.frame(  
  steps = naFill(activitydata, actCastInt),  
  date = activitydata$date,  
  interval = activitydata$interval)
str(activitydataFill)
#check the missing value
sum(is.na(activitydataFill$steps))
#Histogram of total no of steps taken each day
#install.packages("ggplot2")
#library(ggplot2)
totalSteps <- aggregate(steps ~ date, activitydataFill,sum)
colnames(totalSteps) <- c("date", "steps")
hist(totalSteps$steps,totalSteps$date, main = "Histogram of total steps taken per day", 
     xlab = "Total steps per day", ylab = "Number of days", 
     breaks = 10, col = "steel blue")
abline(v = mean(totalSteps$steps), lty = 1, lwd = 2, col = "red")
abline(v = median(totalSteps$steps), lty = 2, lwd = 2, col = "black")
legend(x = "topright", c("Mean", "Median"), col = c("red", "black"), 
       lty = c(2, 1), lwd = c(2, 2))
#Number of rows with NA values
sum(is.na(activitydata$steps))
sum(is.na(activitydata$steps))*100/nrow(activitydata)

#Part 4
#Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends
#compare the activities in weekday and weekend 
#For this I have used the dataset in which the missing data is filled in.
# Using dplyr,mutate to create new column dayIndicator
#Calculation of average steps interval in 5min 
#Using ggplot2 for the plotting of timeseries of 5min of weekday and weekend and compare the average steps
activitydataFill <- mutate(activitydataFill, dayIndicator = 
                             ifelse(weekdays(activitydataFill$date) == "Saturday" | 
                                      weekdays(activitydataFill$date) == "Sunday", "weekend", "weekday"))
activitydataFill$dayIndicator <- as.factor(activitydataFill$dayIndicator)
head(activitydataFill) 
averageInterval <- activitydataFill %>%
  group_by(interval, dayIndicator) %>%
  summarise(steps = mean(steps))
g <- ggplot(averageInterval, aes(x=interval, y=steps, color = dayIndicator)) +
  geom_line() +
  facet_wrap(~dayIndicator, ncol = 1, nrow=2)
print(g)

