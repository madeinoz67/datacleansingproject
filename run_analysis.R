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
library(plyr) # 
library(dplyr) # for fancy data table manipulations and organization

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
list.files(data_path, recursive = TRUE)

# Read in the required files
dtSubjectTrain  <- fread(file.path(data_path, "train", "subject_train.txt"))
dtSubjectTest   <- fread(file.path(data_path, "test", "subject_test.txt"))

dtActivityTrain <- fread(file.path(data_path, "train", "Y_train.txt"))
dtActivityTest  <- fread(file.path(data_path, "test", "Y_test.txt"))

dtFeaturesTrain <- fread(file.path(data_path, "train", "X_train.txt")) 
dtFeaturesTest  <- fread(file.path(data_path, "test", "X_test.txt"))

# 1. Merges the training and the test sets to create one data set.
dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
dtActivity<- rbind(dataActivityTrain, dtActivityTest)
dataFeatures<- rbind(dtFeaturesTrain, dtFeaturesTest)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# 3. Uses descriptive activity names to name the activities in the data set

# 4. Appropriately labels the data set with descriptive variable names.


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

