---
title: "README.md"
author: "Frank Holden"
date: "May 15, 2015"
output: html_document
---

This file explains and contains the scripts I used to develop the submissions for the Getting and Cleaning Data Coursea course .

Please read CodeBook.md (or CodeBook.Rmd) for a description of the data and analysis strategies.  Also, look at the file: run_analysis.R for the actual code I used.

-1  I first set up the workind directory and confirm that I have access to the "UCI HAR Dataset"" folder
```{r}
rm(list=ls())
curwd <- getwd()
GCDProjectWD <- "<path to working directory>"
if (!GCDProjectWD == "path to working directory>") {setwd(GCDProjectWD)}
# show UCI HAR Dataset
print(dir())
```
-2 I then used a switch so that as I developed the code I would not be using the whole dataset
```{r}
debug <- FALSE
if (debug) {
     # load the test dataset
     source("ProjectWork1_loadTest_10rows.R")
     source("ProjectWork2_loadTrain_10rows.R")
     source("ProjectWork3_Clean.R")
     stop("finished debug")}
#
# load the full dataset
```

-3 I developed three scripts (shown above for the 10 row debug).  I'll detail the first script as the second is identical with the exception of the target dataset;

#ProjectWork1-loadTest.R
```{r}
## test loading data... all rows  Assume (but test) that you are in the correct working directory
rm(list=ls())
# set up pointers to the target input datasets for "test"
subDir <- "UCI HAR Dataset"
subTestSubIDFile <- "test/subject_test.txt"
subTestActIDFile <- "test/y_test.txt"
subTestDataFile <- "test/x_test.txt"
subActLabelFile <- "activity_labels.txt"
subFeaturesFile <- "features.txt"
testDim <- c(2947,561)   # used to check the dimensions of the uploaded datasets
# read the data tables
subTestSubIDs <- read.table(paste(".",subDir,subTestSubIDFile,sep="/"),sep = " ",nrows = -1)
subTestActIDs <- read.table(paste(".",subDir,subTestActIDFile,sep="/"),sep = " ", nrows= -1)
subTestData <- read.table(paste(".",subDir,subTestDataFile,sep="/"),header = F, nrows = -1)  #note that when sep=" " is used the result is not correct
dim(subTestData)
#expect
testDim
#  read the label tables  (excuse my spelling)
subActivityLables <- read.table(paste(".",subDir,subActLabelFile,sep= "/"),sep = " ")  # Activity Labaels
subFeatures <- read.table(paste(".",subDir,subFeaturesFile,sep= "/"),sep = " ")  # variable Labels
# make the DF with the data, subjectIDs and ActivityIDS
subTestDF <- data.frame(subTestData,subTestActIDs,subTestSubIDs)
#make the subColNames acceptable to R: with make.names().  The selection of "mean" and "std" fails if the column names contain characters such as "("
subColNames <- make.names(as.vector(as.character(subFeatures$V2)),unique=T, allow_=T)
# add the new column names to the names of the subColumnNames
subColNames <- c(subColNames,c("Activities","Subjects"))
# add the new names (most of them stay the same) to the DF
names(subTestDF) <- subColNames
# make a dplyr table from the data frame
library(dplyr)
subTestTBL <- tbl_df(subTestDF)
subTestTBL
```

- 4 The hard work is done the the script called:

#ProjectWork3_Clean.R

```{r}
# script 3  Clean up and do work
# row bind the two data tables 
subDataTBL <- rbind(subTrainTBL,subTestTBL)
# clean up the environment to clear out unneeded stuff
GE <- ls()  #get global environment objects
GEtrain <- GE[][grep("*train",GE,ignore.case=T)]
GEtest <- GE[][grep("*test",GE,ignore.case=T)]
# we want to keep :subActivityLables
rm(list=GEtrain)
rm(list=GEtest)
# 
# Join the activity lables into the table with an inner_join
#
# first correct the names in the two tables the were "V1" and "V2"
names(subActivityLables) <- c("ActivityID","ActDescription")
niceDataTBL <- inner_join(subDataTBL,subActivityLables,by=c("Activities" = "ActivityID"))
# break the data set apart into ID columns ds1, Mean columns ds2 STD columns ds3 recolumn bind them
dataIDcols <- select(niceDataTBL,Subjects,ActDescription)
meanCols <- select(niceDataTBL,contains("mean",ignore.case=TRUE))
stdCols <- select(niceDataTBL,contains("std",ignore.case=TRUE))
#
nicerDataTBL <- cbind(dataIDcols,meanCols,stdCols)
#
#melt the tbl but set up a vector of the Measure.Vars first
measureVars <- names(nicerDataTBL)
# drop the first two measureVars as they are "Subjects" and "ActDescription"
measureVars <- measureVars[3:length(measureVars)]
# now melt check first to see that "reshape2" package is installed
if (!any(installed.packages()=="reshape2")) {install.packages("reshape2")}
library(reshape2)
meltedDataTBL <- melt(nicerDataTBL, id=c("Subjects","ActDescription"), measure.vars = measureVars)
#
library(plyr)
ddply(meltedDataTBL,.(ActDescription),summarize,mean(value))
#
# messing around:
table(meltedDataTBL$ActDescription,meltedDataTBL$variable)
byAct <- meltedDataTBL %>% group_by(ActDescription,variable)
byAct %>% summarise_each(funs(mean,sd))
#done with the work 
```

- 5 The table "meltedDataTBL" is then exported:
```{r}
write.table(meltedDataTBL,"./tidyGCDProjectDataSet.txt",row.names=FALSE)
```
