## Getting and Cleansing Data 
## Assignment 
##  Stephen Eaton <seaton@strobotics.com.au>
##

# modify the variable 'wd' below to suit your working directory
wd <- "~/Documents/Coursera/datacleansing/project"

# ---- do not modify anything below below this line ----
data_url  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data_file <- "dataset.zip"
data_path <- file.path(wd, "data", "UCI HAR Dataset")  # Data Set Path

setwd(wd)

library(data.table)
library(reshape2)
library(plyr) 
library(dplyr) 

# Check that data file exists, if not then download
if(!file.exists(data_file)){
        download.file(data_url, file.path(wd, data_file))
}

# Check for data directory and create if necessary
if (!dir.exists("data")){
        dir.create("data")
}

# Refresh data regardless by unpacking the dataset to data directory
unzip(data_f, overwrite = TRUE, exdir = "data" )

# list files
#list.files(data_path, recursive = TRUE)

# Read in the required files
dtSubjectTrain  <- read.table(file.path(data_path, "train", "subject_train.txt"), header = FALSE)
dtSubjectTest   <- read.table(file.path(data_path, "test", "subject_test.txt"), header = FALSE)

dtActivityTrain <- fread(file.path(data_path, "train", "Y_train.txt"), header = FALSE)
dtActivityTest  <- read.table(file.path(data_path, "test", "Y_test.txt"), header = FALSE)

dtFeaturesTrain <- read.table(file.path(data_path, "train", "X_train.txt"), header = FALSE) 
dtFeaturesTest  <- read.table(file.path(data_path, "test", "X_test.txt"), header = FALSE)

activityType <- read.table(file.path(data_path, "activity_labels.txt"),header = FALSE)


# 1. Merges the training and the test sets to create one data set.

dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
dtActivity<- rbind(dtActivityTrain, dtActivityTest)
dtFeatures<- rbind(dtFeaturesTrain, dtFeaturesTest)

names(dtSubject)<-c("subjectId")
names(dtActivity)<- c("activityId")
dtFeaturesNames <- read.table(file.path(data_path, "features.txt"), header=FALSE)
names(dtFeatures)<- dtFeaturesNames$V2

# merge to get data table for all Data
dataCombine <- cbind(dtSubject, dtActivity)
Data <- cbind(dtFeatures, dataCombine)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
subdataFeaturesNames<-dtFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dtFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subjectId", "activityId" )
Data<-subset(Data,select=selectedNames)

# 3. Uses descriptive activity names to name the activities in the data set
colnames(activityType)   <- c('activityId','activityType');
Data <- merge(Data, activityType, by='activityId', all.x=TRUE);

# 4. Appropriately labels the data set with descriptive variable names.
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# create the Tidy data set 
TidyData <- aggregate(. ~subjectId + activityType, Data, mean)
TidyData <- TidyData[order(Data2$subjectId,Data2$activityType),]
write.table(TidyData, file = "HumanActivitySmartPhoneRecognitionDataSet.txt", sep = '\t')
