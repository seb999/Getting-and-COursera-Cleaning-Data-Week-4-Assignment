#install packages
install.packages("data.table")
install.packages("reshape2")
install.packages("knitr")
library(tidyverse)
library(data.table)
library(knitr)

# read all data from files and put them in datatable
xTrain <- read.table("./UCI HAR Dataset/train/xTrain.txt")
xTest <- read.table("./UCI HAR Dataset/test/xTest.txt")
yTrain <- read.table("./UCI HAR Dataset/train/yTrain.txt")
yTest <- read.table("./UCI HAR Dataset/test/yTest.txt")
subTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activityLabels <- read.table("./UCI HAR Dataset/activityLabels.txt")

# We merge training and test sets to create one data set.
X <- rbind(xTrain, xTest)
Y <- rbind(yTrain, yTest)
all <- rbind(subTrain, subTest)

# We take mean and standard deviation for each measurement
featuresSelected <- features[grep("mean|std",features[,2]),]
X <- X[,featuresSelected[,1]]

# We rename columns
colnames(Y) <- "label"
Y$activity <- factor(Y$label, labels = as.character(activityLabels[,2]))
activity <- Y$activity

# Appropriately labels the data set with descriptive variable names
colnames(X) <- features[featuresSelected[,1],2]

# We create a second, independent tidy data set with the average of each variable for each activity and each subject.
colnames(all) <- "subject"
combine <- cbind(X, activity, all)
temp <- group_by(combine,activity, subject)
final <- summarize_all(temp,funs(mean))

# And we write the final result in a new file
write.table(final, file = "./resultTidyData.txt", row.names = FALSE, col.names = TRUE)
