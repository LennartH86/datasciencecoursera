# load needed packages
library(stringr)
library(plyr)
library(reshape2)

# read in the names of the variables and the descriptive activities
variableNames <- read.table("./data/features.txt")
activities <- read.table("./data/activity_labels.txt")

# read in the test data set, name the variables according to the variableNames file
# and name the activity and subject data appropriatly
X_test <- read.table("./data/test/X_test.txt")
names(X_test) <- variableNames$V2
subject_test <- read.table("./data/test/subject_test.txt")
names(subject_test) <- "subject"
y_test <- read.table("./data/test/y_test.txt")
names(y_test) <- "activity"

# read in the train data set, name the variables according to the variableNames file
# and name the activity and subject data appropriatly
X_train <- read.table("./data/train/X_train.txt")
names(X_train) <- variableNames$V2
subject_train <- read.table("./data/train/subject_train.txt")
names(subject_train) <- "subject"
y_train <- read.table("./data/train/y_train.txt")
names(y_train) <- "activity"

# combine all training and test data
# 1. combine the test data with the data set, the subjects and activies
# 2. combine the train data with the data set, the subjects and activies
# 3. combine the combined train and test data
test <- cbind(subject_test, y_test, X_test)
train <- cbind(subject_train, y_train, X_train)
data <- rbind(test, train)

# create a new data frame which inclued the activies, subjects and all variables
# providing information about the mean and std. Only variables with mean() or std()
# in its name are choosen
data_mean_std <- cbind(data[,1:2],data[,names(data)[str_detect(names(data), "mean\\(\\)")]],
                       data[,names(data)[str_detect(names(data), "std\\(\\)")]])

# the numeric activies are replaced with descriptive identifiers from the activity_labes.text
activity_char <- c()
for (i in 1:length(data_mean_std$activity)) {
        char <- as.character(activities$V2[activities$V1 == data_mean_std$activity[i]])
        activity_char <- c(activity_char, char)
}
data_mean_std$activity <- activity_char

# a tidy data set is created with the mean for every variable for every subject and activity
data_molten <- melt(data_mean_std, id = c("subject", "activity"))
data_tidy <- dcast(data_molten, subject + activity ~ variable, mean)

write.table(data_tidy, "data_tidy.txt", row.names = FALSE, sep= ";")


