library(dplyr)

## Assignment requirements
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Used for debugging - set to -1 to run for all rows
numRows<- -1

## Preparation
#First read in the features.txt (column headers for the testing and training data)
col_headers<-read.table("UCI HAR Dataset\\features.txt")
#Now read in the activity labels (table that takes the activity code and shows the text name of the activity)
act_headers<-read.table("UCI HAR Dataset\\activity_labels.txt", col.names=c("activityCD", "activity"))

# Train data - (3 datasets containing the train data, activities for the train data, and subjects for the train data)
# Note: while reading in the data, this step also meets the step 4 requirement by setting the column names
train_dat<-read.table("UCI HAR Dataset\\train\\X_train.txt", header=FALSE, col.names=col_headers$V2, nrows=numRows)
train_act<-read.table("UCI HAR Dataset\\train\\Y_train.txt", header=FALSE, col.names="activityCD", nrows=numRows)
train_subj<-read.table("UCI HAR Dataset\\train\\subject_train.txt", header=FALSE, col.names="subject", nrows=numRows)
full_train<-cbind(train_dat, train_act, train_subj)

# Test Data - (3 datasets containing the test data, activities for the test data, and subjects for the test data)
# Note: while reading in the data, this step also meets the step 4 requirement by setting the column names
test_dat<-read.table("UCI HAR Dataset\\test\\X_test.txt", header=FALSE, col.names=col_headers$V2, nrows=numRows)
test_act<-read.table("UCI HAR Dataset\\test\\Y_test.txt", header=FALSE, col.names="activityCD", nrows=numRows)
test_subj<-read.table("UCI HAR Dataset\\test\\subject_test.txt", header=FALSE, col.names="subject", nrows=numRows)
full_test<-cbind(test_dat, test_act, test_subj)

# Merging the datasets together - step 1 requirement
mergeDS<-rbind(full_test, full_train)

# Multiple manipulations of the data using dplyr
# 1) Start with the mergeDS
# 2) Bring in the descriptive activity names for each activity by using merge - Meets step 3 requirement
# 3) Pull out only the mean and standard deviation columns using select - Meets step 2 requirement
# 4) Group the data for the final summarization - required for the next step to assist in meeting step 5 requirement
# 5) Summarize the data by averaging each measurement column (that is not in the group_by clause above) - assist in meeting step 5 requirement
mean_std<- mergeDS %>%
           merge(act_headers) %>%
           select(subject,activity,contains("mean"), contains("std")) %>%
           group_by(subject,activity) %>%
           summarise_each(funs(mean))

# Gets rid of intermediate features not saved with the data - allows for comparison of tidyDS to reading the
# data back into another variable using read.table("tidyds.txt", header=TRUE) and comparing with all.equal
tidyDS<-data.frame(mean_std)

# Write out the data - Meets step 5 requirement
write.table(tidyDS, "tidyds.txt", row.names=FALSE, quote=FALSE)

