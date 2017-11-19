> library(dplyr)

Attaching package: ‘dplyr’

The following objects are masked from ‘package:stats’:

    filter, lag

The following objects are masked from ‘package:base’:

    intersect, setdiff, setequal, union

Warning message:
package ‘dplyr’ was built under R version 3.4.2 

> zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
> zipFile <- "UCI HAR Dataset.zip"
> zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
> if (!file.exists(zipFile)) {
  download.file(zipUrl, zipFile, mode = "wb")
}
trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
Content type 'application/zip' length 62556944 bytes (59.7 MB)
downloaded 59.7 MB

> dataPath <- "UCI HAR Dataset"
> if (!file.exists(dataPath)) {
  unzip(zipFile)
 }
> trainingSubjects <- read.table(file.path(dataPath, "train", "subject_train.txt"))
> trainingValues <- read.table(file.path(dataPath, "train", "X_train.txt"))
> trainingActivity <- read.table(file.path(dataPath, "train", "y_train.txt"))
> testSubjects <- read.table(file.path(dataPath, "test", "subject_test.txt"))
> testValues <- read.table(file.path(dataPath, "test", "X_test.txt"))
> testActivity <- read.table(file.path(dataPath, "test", "y_test.txt"))
> features <- read.table(file.path(dataPath, "features.txt"), as.is = TRUE)
> activities <- read.table(file.path(dataPath, "activity_labels.txt"))
> colnames(activities) <- c("activityId", "activityLabel")
> humanActivity <- rbind(
  cbind(trainingSubjects, trainingValues, trainingActivity),
  cbind(testSubjects, testValues, testActivity)
 )
> rm(trainingSubjects, trainingValues, trainingActivity, 
   testSubjects, testValues, testActivity)
> colnames(humanActivity) <- c("subject", features[, 2], "activity")
> columnsToKeep <- grepl("subject|activity|mean|std", colnames(humanActivity))
> humanActivity <- humanActivity[, columnsToKeep]
> humanActivity$activity <- factor(humanActivity$activity,levels = activities[, 1], labels = activities[, 2])
> humanActivityCols <- colnames(humanActivity)
> humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)
> humanActivityCols <- gsub("^f", "frequencyDomain", humanActivityCols)
> humanActivityCols <- gsub("^t", "timeDomain", humanActivityCols)
> humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
> humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
> humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
> humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
> humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
> humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)
> humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)
> colnames(humanActivity) <- humanActivityCols
> humanActivityMeans <- humanActivity %>% 
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
> write.table(humanActivityMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)
