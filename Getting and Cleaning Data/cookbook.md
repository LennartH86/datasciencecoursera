# Cookbook

This cookbook descripes the transformations done with the data set you may download here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
it also describes the variables created as the output of the transformations

## transformations

The following transformations were done:
* the test and training data sets were load into R and the column names wre changed according to the features.txt
* the different tables for the test and training data sets are merged together
* the merged test and training tables are merged to one data set
* only the variables having mean() or std() in the name, the subject variable and the activity variable are left in the data set, every other variable is thrown out
* the activity variable is numeric, the activity_labels.txt contains desciptive names for these numbers, therefor the activity_labels.txt is used to replace the numbers in the activity variable with descripitve names
* the data set gets reshaped, with subject and activity as ids, the variables (mean and std) are changed from horizontal to vertical
* the reshaped data gets reshaped again, the variables are spread into horizontal but the mean for every variable within each subject and activity is caculatd this time

## result data set

A tidy data set is the result of the transformations. It includes for every subject and activity the mean for each variable.

## variables
subject - numeric, for each individual participating in the study  
activity - string, the activity the subject did according to the data

the following variables are data from the the smartphone transformed as described above  
tBodyAcc-mean()-X          
tBodyAcc-mean()-Y          
tBodyAcc-mean()-Z          
tGravityAcc-mean()-X       
tGravityAcc-mean()-Y       
tGravityAcc-mean()-Z       
tBodyAccJerk-mean()-X      
tBodyAccJerk-mean()-Y      
tBodyAccJerk-mean()-Z      
tBodyGyro-mean()-X         
tBodyGyro-mean()-Y         
tBodyGyro-mean()-Z         
tBodyGyroJerk-mean()-X     
tBodyGyroJerk-mean()-Y     
tBodyGyroJerk-mean()-Z     
tBodyAccMag-mean()         
tGravityAccMag-mean()      
tBodyAccJerkMag-mean()     
tBodyGyroMag-mean()        
tBodyGyroJerkMag-mean()    
fBodyAcc-mean()-X          
fBodyAcc-mean()-Y          
fBodyAcc-mean()-Z          
fBodyAccJerk-mean()-X      
fBodyAccJerk-mean()-Y      
fBodyAccJerk-mean()-Z      
fBodyGyro-mean()-X         
fBodyGyro-mean()-Y         
fBodyGyro-mean()-Z         
fBodyAccMag-mean()        
fBodyBodyAccJerkMag-mean()  
fBodyBodyGyroMag-mean()      
fBodyBodyGyroJerkMag-mean()  
tBodyAcc-std()-X             
tBodyAcc-std()-Y           
tBodyAcc-std()-Z           
tGravityAcc-std()-X        
tGravityAcc-std()-Y        
tGravityAcc-std()-Z        
tBodyAccJerk-std()-X       
tBodyAccJerk-std()-Y       
tBodyAccJerk-std()-Z       
tBodyGyro-std()-X          
tBodyGyro-std()-Y          
tBodyGyro-std()-Z          
tBodyGyroJerk-std()-X      
tBodyGyroJerk-std()-Y     
tBodyGyroJerk-std()-Z      
tBodyAccMag-std()         
tGravityAccMag-std()      
tBodyAccJerkMag-std()      
tBodyGyroMag-std()      
tBodyGyroJerkMag-std()     
fBodyAcc-std()-X           
fBodyAcc-std()-Y           
fBodyAcc-std()-Z           
fBodyAccJerk-std()-X       
fBodyAccJerk-std()-Y      
fBodyAccJerk-std()-Z      
fBodyGyro-std()-X         
fBodyGyro-std()-Y          
fBodyGyro-std()-Z          
fBodyAccMag-std()           
fBodyBodyAccJerkMag-std()   
fBodyBodyGyroMag-std()  
fBodyBodyGyroJerkMag-std()  
