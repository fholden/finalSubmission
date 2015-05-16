---
title: "CodeBook.md"
author: "Frank Holden"
date: "May 15, 2015"
output: html_document
---
This is work done as part of the "Getting and Cleaning Data" Coursera course May 4->24,, 2015.  The objective is to prepare tidy data (named tidyGCDProjectDataSet.csv) that can be used for later analysis.

This is the code book that describes the variables, the data, and the transformations and work that cleaned up the data

The full description of the original data sets is contained in:  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

In summary, however, the original dataset, named: "UCI HAR Dataset" was prepared in order to determine the output of a six-degree of freedom movement chip as used in Fitbit, Nike, Jawbone, iPhone6 etc. for each of six physical activities:

- 1 WALKING
- 2 WALKING_UPSTAIRS
- 3 WALKING_DOWNSTAIRS
- 4 SITTING
- 5 STANDING
- 6 LAYING

The document that describes the creation of the datasets describes them as follows: 

```{r}
# The experiments have been carried out with a group of 30 volunteers within an age
# bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, 
# WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) 
# on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear 
# acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments 
# have been video-recorded to label the data manually. The obtained dataset has been 
# randomly partitioned into two sets, where 70% of the volunteers was selected for 
# generating the training data and 30% the test data. 
```


The provided data folder:
```{r}
dir("UCI HAR Dataset")
```
 contained six items of which there are three data tables:
 
- activity_labels.txt -> the lables of the activities and their associated key
- features.txt -> the 561 variables that were measured and subsequently filtered 
- features_info.txt -> a more complete description of the variables measured and filtered

a README.txt file that is similar to the http://archive.ics URL referenced above,  and two data folders named "test" and "train" respectively.

Each datafolder contains three data tables, 

- subject_test.txt -> a 2947 X 1 vector of the subject ID's 
- Y_test.txt -> a 2947 X 1 vector of the activity ID's 
- X_test.txt -> a 2947 X 561 matrix each row being an observation and each of the 561 columns the value of the outcome variable

and a folder  "inertial Signals" of the raw signals which I was able to read:

```{r}
baxtestIS <- "UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt"
baxtestISDF <- read.fwf(baxtestIS,widths = c(18,rep(16,each=127)))
dim(baxtestISDF)
readLines(baxtestIS,n=1)
baxtestISDF[1,c(1,128)]
```

but considered as not relevant to the assignment.

The datafolder for the train data is identical to the test folder with "test" replacing "train" and the length of the vecors and matrix being 7352 rows long.

After reviewing the datasets, it became clear that in the end, we wanted a 4 colum data.frame where each row was an observation, and the four columns would be named: Subjects, ActDescription, variable, value.
```{r}
# I considered the names: variable, and value, to be sufficiently description column names.
```
This was accomplished by performing the following steps:

- 1 load the training datasets (X_train.txt, y_train.txt, and subject_train.txt)
- 2 column bind the three dataset into on matrix,
- 3 load the activity label dataset and join it to the working matrix, (objective 3 of the Project assignment)
- 4 repeat 1 to 3 for the testing dataset
- 5 row bind the two matricies into one (objective 1 of the Project assignment)
- 6 select the columns from the matrix that had the words ("mean","std",ignore.case = TRUE), (objective 2 of the Project assignment)
```{r}
# for me this required changing the column names because the original ones contained characters that were hard to use in the "select" function
```
- 7 label the columns with descriptive variable names (objective 4 of the Project assignment)
```{r}
# I thought that after removing the "(" and other bothersome R characters, the names were perfect!
```

- 8 make and export a tidy data set showing the average of each variable (already computed in the dataset) for each Subject and each Activity
```{r}
tGCDDF <- read.csv("tidyGCDProjectDataSet.csv")
dim(tGCDDF)
names(tGCDDF)
variableNames <- unique(tGCDDF["variable"])
dim(variableNames)
variableNames
