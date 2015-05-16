## test loading data...  only 10 rows
rm(list=ls())
curWD <- getwd()
tgtWD <- "/Users/fholden/coursea/GetCleanData"
dir("./")
subDir <- "UCI HAR Dataset"
subTestSubIDFile <- "test/subject_test.txt"
subTestActIDFile <- "test/y_test.txt"
subTestDataFile <- "test/x_test.txt"
subActLabelFile <- "activity_labels.txt"
subFeaturesFile <- "features.txt"
testDim <- c(2947,561)

subTestSubIDs <- read.table(paste(".",subDir,subTestSubIDFile,sep="/"),sep = " ",nrows = -1)
subTestActIDs <- read.table(paste(".",subDir,subTestActIDFile,sep="/"),sep = " ", nrows= -1)
subTestData <- read.table(paste(".",subDir,subTestDataFile,sep="/"),header = F, nrows = -1)  #note that when sep=" " is used the result is not correct
dim(subTestData)
#expect
testDim

subActivityLables <- read.table(paste(".",subDir,subActLabelFile,sep= "/"),sep = " ")
subFeatures <- read.table(paste(".",subDir,subFeaturesFile,sep= "/"),sep = " ")
#
subTestDF <- data.frame(subTestData,subTestActIDs,subTestSubIDs)
#make the subColNames acceptable to R: with make.names()
subColNames <- make.names(as.vector(as.character(subFeatures$V2)),unique=T, allow_=T)

subColNames <- c(subColNames,c("Activities","Subjects"))

names(subTestDF) <- subColNames
library(dplyr)
subTestTBL <- tbl_df(subTestDF)
subTestTBL
# 
