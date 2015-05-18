# clear Environment, show working directory
rm(list=ls())
curwd <- getwd()
GCDProjectWD <- "/Users/fholden/coursea/GetCleanData/ProjectWork/finalSubmission"
setwd(GCDProjectWD)
# show UCI HAR Dataset
dir()
debug <- FALSE
if (debug) {
     # load the test dataset
     source("ProjectWork1_loadTest_10rows.R")
     source("ProjectWork2_loadTrain_10rows.R")
     source("ProjectWork3_Clean.R")
     print("finished debug")}
#
# load the full dataset
rm(list=ls())
source("ProjectWork1_loadTest.R")
source("ProjectWork2_loadTrain.R")
source("ProjectWork3_Clean.R")
summaryTBL <- aggregate(meltedDataTBL$value, 
                        list(Subject=meltedDataTBL$Subjects,Activity=meltedDataTBL$ActDescription,Variable=meltedDataTBL$variable),
                        FUN=mean)
names(summaryTBL) <- c(names(summaryTBL[,1:3]),"MeanValue")
write.table(summaryTBL,"./tidyGCDProjectDataset.txt",row.names=FALSE)
print("finished")
