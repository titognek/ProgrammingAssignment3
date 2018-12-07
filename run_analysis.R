## download the data files from database
setwd("~/Documents/DataScienceToolbox/Course 3/WD")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./downloads/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", method = "curl")

## set working directory to work on train and test datasets
setwd("~/Documents/DataScienceToolbox/Course 3/WD/downloads/UCI HAR Dataset/")

## list the downlodded files and directories
dir()

## load common files to both sets (variable and activity)
activityLables <- read.table("./activity_labels.txt", header = FALSE, sep ="")
variables <- read.table("./features.txt", header = FALSE, sep = "")

## load data files for the test set
testSbjID <- read.table("./test/subject_test.txt", header = FALSE, sep = "")
testData <- read.table("./test/X_test.txt", header= FALSE, sep =  "")
testActivity <- read.table("./test/y_test.txt", header= FALSE, sep =  "")
colnames(testData) <- variables[,2] # change the non-descriptive column names to the ones provided in variables

## creat the group label for the test subjects 
testLabel <- rep("test", nrow(testData))

## assign to secondary variables for later check
testActivityNum <- testActivity
testActivityName <- testActivity

################ ASSIGNMENT TASK 3 ############
## change activity number with activity name
for(i in activityLables[,1]){
        testActivityName <- replace(testActivityName, testActivity == i, as.character(activityLables[i,2]))
}
## this task is performed here to create a comple test dataset 
############

## check that activity names have been properly assigned
checkActivityName <-cbind(testActivityNum, testActivityName)
table(checkActivityName[,1], checkActivityName[,2])

## combine the subjectID, subjectGroup and Activity description to the variables of the test dataset
testData2 <- cbind(as.factor(testSbjID[,1]), as.factor(testLabel), testActivityName, testData)
colnames(testData2)[1:3] <- c("sbjID", "sbjGroup", "Activity")
head(testData2[,1:5])

############### repeat the same procedure to the training dataset ########################

## load data files for the train set
trainSbjID <- read.table("./train/subject_train.txt", header = FALSE, sep = "")
trainData <- read.table("./train/X_train.txt", header= FALSE, sep =  "")
trainActivity <- read.table("./train/y_train.txt", header= FALSE, sep =  "")
colnames(trainData) <- variables[,2]

## creat the group label for these subjects
trainLabel <- rep("train", nrow(trainData))

## assign to secondary variables for later check
trainActivityNum <- trainActivity
trainActivityName <- trainActivity

################ ASSIGNMENT TASK 3 ############
## change activity number with activity description/name
for(i in activityLables[,1]){
        trainActivityName <- replace(trainActivityName, trainActivity == i, as.character(activityLables[i,2]))
}
## this task is performed here to create a comple train dataset 
############

## check that activity names have been properly assigned
checkActivityName <-cbind(trainActivityNum, trainActivityName)
table(checkActivityName[,1], checkActivityName[,2])

## combine the subjectID, subjectGroup and Activity description to the variables of the train dataset
trainData2 <- cbind(as.factor(trainSbjID[,1]), as.factor(trainLabel), trainActivityName, trainData)
colnames(trainData2)[1:3] <- c("sbjID", "sbjGroup", "Activity")
head(trainData2[,1:5])


## now the training and test datasets are ready to be combined 
## check the all names are identical before merging the two datasets
all(names(testData2)==names(trainData2))

########### ASSIGNMENT TASK 1 ##################
## merge the two datasets (train and test)
dataComplete <- rbind(trainData2, testData2)
dim(dataComplete)
################

## find the columns with that contain  mean and std values
library(data.table)
meanCol <- colnames(dataComplete) %like% "mean"
MeanCol <- colnames(dataComplete) %like% "Mean"
stdCol  <- colnames(dataComplete) %like% "std"

########## ASSIGNMENT TASK 2 ###################
## select only the columns with mean and std values
dataMeanStd <- dataComplete[, meanCol | stdCol | MeanCol]
dim(dataMeanStd)
###############

## add the subjects, group and activity information
dataMeanStd <- cbind(dataComplete[,1:3], dataMeanStd)

################ ASSIGNMENT TASK 4 ######################
## improve readability of variable names to be descriptive but still short
dataNames <- names(dataMeanStd)

## improve column names in the combined dataset
dataNames <- gsub("\\()", "", dataNames)
dataNames <- gsub("-", "_", dataNames)
dataNames <- gsub("^t", "time_", dataNames)
dataNames <- gsub("^f", "freq_", dataNames)
dataNames <- gsub("X$", "X_axis", dataNames)
dataNames <- gsub("Y$", "Y_axis", dataNames)
dataNames <- gsub("Z$", "Z_axis", dataNames)
dataNames <- gsub("\\(", "_", dataNames)
dataNames <- gsub(",", "_", dataNames)
dataNames <- gsub("\\)", "", dataNames)
dataNames <- gsub("_std","_stdDev", dataNames)
dataNames <- gsub("([Gg]ravity)","Gravity", dataNames)
dataNames <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body", dataNames)
dataNames <- gsub("AccMag","AccMagnitude", dataNames)
dataNames <- gsub("JerkMag","JerkMagnitude", dataNames)
dataNames <- gsub("GyroMag","GyroMagnitude", dataNames)
###############

## assign the new variable names to the dataset
names(dataMeanStd) <- dataNames
dataMeanStd$Activity <- as.factor(dataMeanStd$Activity)

############### ASSIGNMENT TASK 5 ######################
## group by Activity and Subject
library(dplyr)
newTidyData <- dataMeanStd[,c(1, 3:89)] %>% group_by(Activity, sbjID) %>% summarise_all(funs(mean))
write.table(newTidyData, file = "tidyDataset.txt", quote = FALSE, row.name=FALSE)
###########

## ASSIGNMENT TASK 1. Merges the training and the test sets to create one data set.

## ASSIGNMENT TASK 2. Extracts only the measurements on the mean and standard deviation for each measurement.

## ASSIGNMENT TASK 3. Uses descriptive activity names to name the activities in the data set

## ASSIGNMENT TASK 4. Appropriately labels the data set with descriptive variable names.

## ASSIGNMENT TASK 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
