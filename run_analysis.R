# clear Environment, show working directory
rm(list=ls())
curwd <- getwd()
GCDProjectWD <- "/Users/fholden/coursea/GetCleanData/ProjectWork/"
setwd(GCDProjectWD)
# show UCI HAR Dataset
dir()
debug <- FALSE
if (debug) {
     # load the test dataset
     source("ProjectWork1_loadTest_10rows.R")
     source("ProjectWork2_loadTrain_10rows.R")
     source("ProjectWork3_Clean.R")
     stop("finished debug")}
#
# load the full dataset
rm(list=ls())
source("ProjectWork1_loadTest.R")
source("ProjectWork2_loadTrain.R")
source("ProjectWork3_Clean.R")
write.csv(meltedDataTBL,"./tidyGCDProjectDataSet.csv",row.names=FALSE)
stop("finished")