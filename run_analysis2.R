# get file and Unzip

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "DataZip.zip")
unzip(zipfile = "DataZip.zip")

# Merges the training and the test sets to create one data set

x.train <- read.table('./UCI HAR Dataset/train/X_train.txt')
x.test <- read.table('./UCI HAR Dataset/test/X_test.txt')
x <- rbind(x.train, x.test)

y.train <- read.table('./UCI HAR Dataset/train/y_train.txt')
y.test <- read.table('./UCI HAR Dataset/test/y_test.txt')
y <- rbind(y.train, y.test)

subj.train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subj.test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
subj <- rbind(subj.train, subj.test)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table('./UCI HAR Dataset/features.txt')
mean.sd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
x.mean.sd <- x[, mean.sd]

# Uses descriptive activity names to name the activities in the data set
names(x.mean.sd) <- features[mean.sd, 2]


activities <- read.table('./UCI HAR Dataset/activity_labels.txt')


y[, 1] = activities[y[, 1], 2]
names(y) <- 'activity'
names(subj) <- 'subject'

# Appropriately labels the data set with descriptive variable names. 

data <- cbind(subj, x.mean.sd, y)
write.table(data, 'Rawdataset.txt', row.names = F)

# From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.

average.df <- aggregate(x=data, by=list(activities=data$activity, subj=data$subject), FUN=mean)
average.df <- average.df[, !(colnames(average.df) %in% c("subj", "activity"))]
write.table(average.df, 'Pivotmeandataset.txt', row.names = F)
