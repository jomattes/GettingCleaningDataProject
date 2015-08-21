###Getting and Cleaning Data Course Project

library(dplyr)

##reads in data
train_data <- read.table("C:/Users/jmattes/Desktop/datasciencecoursera/Getting.and.Cleaning.Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("C:/Users/jmattes/Desktop/datasciencecoursera/Getting.and.Cleaning.Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
train_IDs <- read.table("C:/Users/jmattes/Desktop/datasciencecoursera/Getting.and.Cleaning.Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
test_data <- read.table("C:/Users/jmattes/Desktop/datasciencecoursera/Getting.and.Cleaning.Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("C:/Users/jmattes/Desktop/datasciencecoursera/Getting.and.Cleaning.Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
test_IDs <- read.table("C:/Users/jmattes/Desktop/datasciencecoursera/Getting.and.Cleaning.Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
features <- read.table("C:/Users/jmattes/Desktop/datasciencecoursera/Getting.and.Cleaning.Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")

#changes numbers in labels files to represent actual names from activity_labels.txt file
train_labels[train_labels == 1] <- "WALKING"
train_labels[train_labels == 2] <- "WALKING_UPSTAIRS"
train_labels[train_labels == 3] <- "WALKING_DOWNSTAIRS"
train_labels[train_labels == 4] <- "SITTING"
train_labels[train_labels == 5] <- "STANDING"
train_labels[train_labels == 6] <- "LAYING"
test_labels[test_labels == 1] <- "WALKING"
test_labels[test_labels == 2] <- "WALKING_UPSTAIRS"
test_labels[test_labels == 3] <- "WALKING_DOWNSTAIRS"
test_labels[test_labels == 4] <- "SITTING"
test_labels[test_labels == 5] <- "STANDING"
test_labels[test_labels == 6] <- "LAYING"

#appends test to train data, creates activity labels and subject IDs
full_data <- rbind(train_data, test_data)
full_labels <- rbind(train_labels, test_labels)
full_labels <- full_labels[,1]
subject_IDs <- rbind(train_IDs, test_IDs)
subject_IDs <- subject_IDs[,1]

#determines which columns relate to std or mean, then selects only those columns
features <- features[,2]
mean_loc <- grep("-mean", features)
std_loc <- grep("-std", features)
all_loc <- c(mean_loc, std_loc)
meanandstd_data <- select(full_data, all_loc)

#adds labels to columns, then appends activity descriptions and subject ID
names(meanandstd_data) <- features[all_loc]
meanandstd_data$Activity <- full_labels
meanandstd_data$Subject.IDs <- subject_IDs

#creates tidy data set
tidy_data <- tbl_df(meanandstd_data)
tidy_data <- tidy_data %>% group_by(Subject.IDs, Activity) %>% summarise_each(funs(mean))
write.table(tidy_data, "C:/Users/jmattes/Desktop/datasciencecoursera/Getting.and.Cleaning.Data/tidy_data.txt", sep = ",", row.name=FALSE)