## train loading data... only 10 rows
#rm(list=ls())
curWD <- getwd()
tgtWD <- "/Users/fholden/coursea/GetCleanData"
dir("./")
subDir <- "UCI HAR Dataset"
subTrainSubIDFile <- "train/subject_train.txt"
subTrainActIDFile <- "train/y_train.txt"
subTrainDataFile <- "train/x_train.txt"
#subActLabelFile <- "activity_labels.txt"
#subFeaturesFile <- "features.txt"
trainDim <- c(7352,561)

subTrainSubIDs <- read.table(paste(".",subDir,subTrainSubIDFile,sep="/"),sep = " ", nrows = -1)
subTrainActIDs <- read.table(paste(".",subDir,subTrainActIDFile,sep="/"),sep = " ", nrows = -1)
subTrainData <- read.table(paste(".",subDir,subTrainDataFile,sep="/"),header = F, nrows = -1)  #note that when sep=" " is used the result is not correct
dim(subTrainData)
#expect
trainDim

#subActivityLables <- read.table(paste(".",subDir,subActLabelFile,sep= "/"),sep = " ")
#subFeatures <- read.table(paste(".",subDir,subFeaturesFile,sep= "/"),sep = " ")
#
subTrainDF <- data.frame(subTrainData,subTrainActIDs,subTrainSubIDs)
#subColNames <- as.vector(as.character(subFeatures$V2))
#subColNames <- c(subColNames,c("Activities","Subjects"))
names(subTrainDF) <- subColNames
#library(dplyr)
subTrainTBL <- tbl_df(subTrainDF)
subTrainTBL
# 
