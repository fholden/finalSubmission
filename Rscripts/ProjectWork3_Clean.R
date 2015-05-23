# script 3  Clean up and do work
subDataTBL <- rbind(subTrainTBL,subTestTBL)
GE <- ls()  #get global environment objects
GEtrain <- GE[][grep("*train",GE,ignore.case=T)]
GEtest <- GE[][grep("*test",GE,ignore.case=T)]
# we want to keep :subActivityLables
#trylll
rm(list=GEtrain)
rm(list=GEtest)
# 
# try to put the activitylables into the table with an inner join
#
# first correct the names in the two tables
names(subActivityLables) <- c("ActivityID","ActDescription")
niceDataTBL <- inner_join(subDataTBL,subActivityLables,by=c("Activities" = "ActivityID"))
# bread the data set apart into ID columns ds1, Mean columns ds2 STD columns ds3 recolumn bind them
dataIDcols <- select(niceDataTBL,Subjects,ActDescription)
meanCols <- select(niceDataTBL,contains("mean",ignore.case=TRUE))
stdCols <- select(niceDataTBL,contains("std",ignore.case=TRUE))
# get rid of the dots.  use gsub with the dots as "\\."
names(meanCols) <- gsub("\\.","",names(meanCols))
names(stdCols) <- gsub("\\.","",names(stdCols))

#
nicerDataTBL <- cbind(dataIDcols,meanCols,stdCols)
#
#melt the tbl but set up a vector of the Measure.Vars first
measureVars <- names(nicerDataTBL)

# make nicer names:
newSub <- function(x,y,z) { sub(y,z,x)}
vU1 <- measureVars %>% newSub("Gyro","Rotation") %>% newSub("Mag","Magnitude") %>% newSub("AccJerk","Jerk") %>% 
     newSub("Acc","Acceleration") %>% newSub("mean","_mean") %>% newSub("std","_stDev") %>%
     newSub("X","_X-axis") %>% newSub("Y","_Y-axis") %>% newSub("Z","_Z-axis")
vU2 <- vU1 %>% newSub("^t","") %>% newSub("^f","FourierTransform_")
head(vU2)
names(nicerDataTBL) <- vU2
# now melt
measureVars <- vU2[3:length(vU2)]
if (!any(installed.packages()=="reshape2")) {install.packages("reshape2")}
library(reshape2)
meltedDataTBL <- melt(nicerDataTBL, id=c("Subjects","ActDescription"), measure.vars = measureVars)
##
library(plyr)
ddply(meltedDataTBL,.(ActDescription),summarize,mean(value))
#
# messing around:
table(meltedDataTBL$ActDescription,meltedDataTBL$variable)
byAct <- meltedDataTBL %>% group_by(ActDescription,variable)
byAct %>% summarise_each(funs(mean,sd))
#done with the work 
