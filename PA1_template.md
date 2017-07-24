---
title: "Reproducible Research-Activity Monitoring"
author: "Lopamudra Satpathy"
date: "24 July 2017"
output: html_document
---
###Reproducible Research - Activity Monitoring
##Loading and Preprocessing the data
DownLoading , unzip and processing/transforming the data


##What is mean total number of steps taken per day?
Calculate the total number of steps taken per day
Histogram of total no of steps taken each day
Mean and Median of total no of steps taken per day


![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png)
##What is the average daily activity pattern?
Average activity daily pattern
Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average
number of steps taken, averaged across all days (y-axis)
Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png)
##Imputing missing values
Calculate and report the total number of missing values in the dataset 
(i.e. the total number of rows with NAs)


```
## missing
## FALSE  TRUE 
## 15264  2304
```
Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated.
(For example, you could use the mean/median for that day, or the mean for that 5-minute interval, )
##create dataset with all NAs
##Merging weekly data(avgstepwd) with dataset with all NAs(dataNAs)
##Create a new dataset that is equal to the original dataset but with the missing data filled in




#Make a histogram of the total number of steps taken each day and Calculate and report the mean 
#and median total number of steps taken per day. Do these values differ from the estimates from the 
#first part of the assignment? What is the impact of imputing missing data on the estimates of the 
#total daily number of steps?
#Creating the histogram of total steps per day, categorized by data set to show impact

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-1.png)![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-2.png)
#Are there differences in activity patterns between weekdays and weekends?
#Create a new factor variable in the dataset 
#With two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
##Summarize data by interval and type of day

#Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the 
#average number of steps taken, averaged across all weekday days or weekend days (y-axis).

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14-1.png)


