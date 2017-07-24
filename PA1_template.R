#                   Reproducible Research(project-1)
#Author: Lopamudra Satpathy
#Topic:Activity Monitoring Data

rm(list = ls())
setwd("C:/Users/Gunjan/Desktop/My desktop/coursera/Reproducible reserach/DataProject1")

#Loading and processing/transforming the data
if(!file.exists("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip")) {
  temp <- tempfile()
  download.file("http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip",temp)
  unzip(temp)
  unlink(temp)
}
dataset <- read.csv("./activity.csv")
str(dataset)
complete.cases(dataset)
#Processing of Data
dataset$date <- weekdays(as.Date(dataset$date))
dataset$DateTime <- as.POSIXct(dataset$date, format = "%Y-%m-%d")
#pulling data without NAs
cleandata <-dataset[!is.na(dataset$steps),]

##What is the mean total number of steps taken per day?
#Calculate the total number of steps taken per day
#Histogram of total no of steps taken each day
#Mean and Median of total no of steps taken per day
totalsteps <- aggregate(steps ~ date ,data = dataset, sum)
hist(totalsteps$steps,breaks = 5,main = paste("Total Number of steps taken per day"),xlab = "Steps taken",col = 'purple')
   
mean <- mean(totalsteps$steps, na.rm = TRUE)
median <- median(totalsteps$steps, na.rm = TRUE)

##What is the average activity daily pattern?
#Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average
#number of steps taken, averaged across all days (y-axis)
#Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
avgdaily <- aggregate(steps ~ interval, data = cleandata,FUN = "mean")
library(ggplot2)
ggplot(data = avgdaily,aes(x = interval, y = steps))+
  geom_line()+
  xlab("5-min interval")+
  ylab("Average no of steps taken")
maxsteps <- avgdaily[which.max(avgdaily$steps),1]

##Imputing missing values(mice package helps to find the pattern of missing data)
#Calculate and report the total number of missing values in the dataset 
#(i.e. the total number of rows with NAs)
 missing <- is.na(dataset$steps)
 table(missing)
#Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated.
#For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
library(plyr)
##create average no of steps per weekday and interval
 avgstepswd <- ddply(cleandata,.(interval,date),summarize, Avg = mean(steps))
 str(avgstepswd)
##create dataset with all NAs
 dataNAs <- dataset[is.na(dataset$steps),]
 str(dataNAs)
##Merging weekly data(avgstepwd) with dataset with all NAs(dataNAs)
  newdata1<-merge(dataNAs, avgstepswd, by=c("interval", "date"))
  str(newdata1)
##Create a new dataset that is equal to the original dataset but with the missing data filled in
compldata <- rbind.fill(list(cleandata, newdata1))
str(compldata)
#Make a histogram of the total number of steps taken each day and Calculate and report the mean 
#and median total number of steps taken per day. Do these values differ from the estimates from the 
#first part of the assignment? What is the impact of imputing missing data on the estimates of the 
#total daily number of steps?
avgcompl <- aggregate(steps ~ date, data = compldata,FUN = "mean")

meancompl <- mean(avgcompl$steps,na.rm = TRUE)
mediancompl <- median(avgcompl$steps,na.rm = TRUE)
## Creating the histogram of total steps per day, categorized by data set to show impact
hist(avgcompl$steps,main = paste("Total Steps per Day with NAs Fixed"),breaks = 5,
     xlab = "No of steps",col = 'red')
hist(avgdaily$steps,main = paste("Total Steps per Day without NAs Fixed"),breaks = 5,
     xlab = "No of steps",col = 'blue')

#Are there differences in activity patterns between weekdays and weekends?
#Create a new factor variable in the dataset 
#with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
install.packages(dplyr)
library(dplyr)
str(compldata)
compldata$DayIndicator <- ifelse(compldata$date %in% c("Saturday", "Sunday"), "Weekend", "Weekday")
## Summarize data by interval and type of day
averagesOfDay <- ddply(compldata,.(interval,DayIndicator),summarize, Avg = mean(steps))
str(averagesOfDay)
summary
head(averagesOfDay)
#Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the 
#average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file 
#in the GitHub repository to see an example of what this plot should look like using simulated data.
averages <- aggregate(steps ~ interval, data = compldata,FUN = "mean")
##Plot data in a panel plot
library(lattice)
xyplot(Avg ~  interval|DayIndicator, data= compldata, type="l", lwd = 1,layout = c(1,2),
       main="Average Steps per Interval Based on Type of Day", 
       ylab="Average Number of Steps", xlab="Interval")







