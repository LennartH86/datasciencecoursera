# Practical Machine Learning: Project

Welcome to my write up of the Practical Machine Learning Project. This time we would like to build a algorithm to predict the manner in which participants did excercises which thy tracked with their Jawbone Up, Nike FuelBand, Fitbit or other divices. While building the algorithm I will describe how I build the altorithm, how I use cross validation, what I think the expected out of sample error is and why I made the choices I made.

## Data Preparation
Let's start with the data. We will download and prepare it a little bit. The data is provided devided in training and test data sets.


```r
require(data.table)
setInternet2(TRUE)
url <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
trainingSet <- fread(url)
url <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
testSet <- fread(url)
```

In another step we will exclude any variables from the model and training dataset which do have NA values.

```r
coloumsWhereNAsAre <- sapply(testSet, function (x) any(is.na(x) | x == ""))
coloumsWhereNoNAsAre <- !coloumsWhereNAsAre & grepl("belt|[^(fore)]arm|dumbbell|forearm", names(coloumsWhereNAsAre))
predCandidates <- names(coloumsWhereNAsAre)[coloumsWhereNoNAsAre]

predictors <- c("classe", predCandidates)
```

In a next step we need to make the classes variable a factor variable and we will split the training dataset again into a training and test dataset.


```r
trainingSet <- trainingSet[, classe := factor(trainingSet[, classe])]

require(caret)
set.seed(1337)
toIncludeInTrainingSet <- createDataPartition(trainingSet$classe, p=0.6)
trainingSetTrain <- trainingSet[toIncludeInTrainingSet[[1]]]
trainingSetTest <- trainingSet[-toIncludeInTrainingSet[[1]]]
```

We will center and scale the left predictors in the training dataset, apply the centering and scaling to the test dataset and check vor variables with zero variance.


```r
X <- trainingSetTrain[, predCandidates, with=FALSE]
preProc <- preProcess(X)
preProc
```

```
## 
## Call:
## preProcess.default(x = X)
## 
## Created from 11776 samples and 52 variables
## Pre-processing: centered, scaled
```

```r
XCS <- predict(preProc, X)
trainingSetTrainCS <- data.table(data.frame(classe = trainingSetTrain[, classe], XCS))

X <- trainingSetTest[, predCandidates, with=FALSE]
XCS <- predict(preProc, X)
trainingSetTestCS <- data.table(data.frame(classe = trainingSetTest[, classe], XCS))

nzv <- nearZeroVar(trainingSetTrainCS, saveMetrics=TRUE)
if (any(nzv$nzv)) nzv else message("No variables with near zero variance")
```

```
## No variables with near zero variance
```

## Model building

We will use RandomForrest and parallel processing to find the best fitting predictors in a decent amount of time. 


```r
require(parallel)
```

```
## Loading required package: parallel
```

```r
require(doParallel)
```

```
## Loading required package: doParallel
## Loading required package: foreach
## foreach: simple, scalable parallel programming from Revolution Analytics
## Use Revolution R for scalability, fault tolerance and more.
## http://www.revolutionanalytics.com
## Loading required package: iterators
```

```r
cl <- makeCluster(detectCores() - 1)
registerDoParallel(cl)

require(randomForest)
require(e1071)
```

```
## Loading required package: e1071
```

```r
ctrl <- trainControl(classProbs=TRUE,
                     savePredictions=TRUE,
                     allowParallel=TRUE)

system.time(trainingModel <- train(classe ~ ., data=trainingSetTrainCS, method="rf"))
```

```
##    user  system elapsed 
##   31.03    0.17  961.15
```

```r
stopCluster(cl)
```

## Model Evaluation

To evaluate the model we will implement the model on the training test set to get the out of sample error. An error rate of about 3-4% or below would be pretty good.


```r
prediction <- predict(trainingModel, trainingSetTrainCS)
confusionMatrix(prediction, trainingSetTrainCS[, classe])
```

```
## Error in eval(expr, envir, enclos): object 'classe' not found
```

```r
prediction <- predict(trainingModel, trainingSetTestCS)
confusionMatrix(prediction, trainingSetTestCS[, classe])
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 2230   27    0    0    0
##          B    2 1485   14    0    0
##          C    0    6 1350   26    1
##          D    0    0    4 1259    5
##          E    0    0    0    1 1436
## 
## Overall Statistics
##                                           
##                Accuracy : 0.989           
##                  95% CI : (0.9865, 0.9912)
##     No Information Rate : 0.2845          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9861          
##  Mcnemar's Test P-Value : NA              
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9991   0.9783   0.9868   0.9790   0.9958
## Specificity            0.9952   0.9975   0.9949   0.9986   0.9998
## Pos Pred Value         0.9880   0.9893   0.9761   0.9929   0.9993
## Neg Pred Value         0.9996   0.9948   0.9972   0.9959   0.9991
## Prevalence             0.2845   0.1935   0.1744   0.1639   0.1838
## Detection Rate         0.2842   0.1893   0.1721   0.1605   0.1830
## Detection Prevalence   0.2877   0.1913   0.1763   0.1616   0.1832
## Balanced Accuracy      0.9971   0.9879   0.9909   0.9888   0.9978
```

```r
varImp(trainingModel)
```

```
## rf variable importance
## 
##   only 20 most important variables shown (out of 52)
## 
##                      Overall
## roll_belt             100.00
## pitch_forearm          59.12
## yaw_belt               51.87
## magnet_dumbbell_y      43.60
## pitch_belt             43.28
## magnet_dumbbell_z      43.28
## roll_forearm           40.54
## accel_dumbbell_y       21.14
## accel_forearm_x        16.74
## roll_dumbbell          16.72
## magnet_dumbbell_x      15.30
## magnet_belt_z          15.21
## accel_dumbbell_z       13.54
## total_accel_dumbbell   13.18
## magnet_belt_y          12.80
## magnet_forearm_z       12.59
## accel_belt_z           12.20
## gyros_belt_z           10.93
## yaw_arm                10.16
## magnet_belt_x          10.05
```

```r
trainingModel$finalModel
```

```
## 
## Call:
##  randomForest(x = x, y = y, mtry = param$mtry) 
##                Type of random forest: classification
##                      Number of trees: 500
## No. of variables tried at each split: 27
## 
##         OOB estimate of  error rate: 0.84%
## Confusion matrix:
##      A    B    C    D    E class.error
## A 3341    4    2    0    1  0.00209080
## B   17 2256    6    0    0  0.01009215
## C    0   17 2029    8    0  0.01217137
## D    0    0   26 1902    2  0.01450777
## E    0    2    5    9 2149  0.00739030
```

```r
save(trainingModel, file="trainingModel.RData")
```

## Test Data Assesment

In the final step we will predict the classes of the 20 test datasets.


```r
load(file="trainingModel.RData", verbose=TRUE)
```

```
## Loading objects:
##   trainingModel
```

```r
testSetCS <- predict(preProc, testSet[, predCandidates, with=FALSE])
prediction <- predict(trainingModel, testSetCS)
testSet <- cbind(prediction , testSet)
subset(testSet, select=names(testSet)[grep("belt|[^(fore)]arm|dumbbell|forearm", names(testSet), invert=TRUE)])
```

```
##     prediction V1 user_name raw_timestamp_part_1 raw_timestamp_part_2
##  1:          B  1     pedro           1323095002               868349
##  2:          A  2    jeremy           1322673067               778725
##  3:          B  3    jeremy           1322673075               342967
##  4:          A  4    adelmo           1322832789               560311
##  5:          A  5    eurico           1322489635               814776
##  6:          E  6    jeremy           1322673149               510661
##  7:          D  7    jeremy           1322673128               766645
##  8:          B  8    jeremy           1322673076                54671
##  9:          A  9  carlitos           1323084240               916313
## 10:          A 10   charles           1322837822               384285
## 11:          B 11  carlitos           1323084277                36553
## 12:          C 12    jeremy           1322673101               442731
## 13:          B 13    eurico           1322489661               298656
## 14:          A 14    jeremy           1322673043               178652
## 15:          E 15    jeremy           1322673156               550750
## 16:          E 16    eurico           1322489713               706637
## 17:          A 17     pedro           1323094971               920315
## 18:          B 18  carlitos           1323084285               176314
## 19:          B 19     pedro           1323094999               828379
## 20:          B 20    eurico           1322489658               106658
##       cvtd_timestamp new_window num_window problem_id
##  1: 05/12/2011 14:23         no         74          1
##  2: 30/11/2011 17:11         no        431          2
##  3: 30/11/2011 17:11         no        439          3
##  4: 02/12/2011 13:33         no        194          4
##  5: 28/11/2011 14:13         no        235          5
##  6: 30/11/2011 17:12         no        504          6
##  7: 30/11/2011 17:12         no        485          7
##  8: 30/11/2011 17:11         no        440          8
##  9: 05/12/2011 11:24         no        323          9
## 10: 02/12/2011 14:57         no        664         10
## 11: 05/12/2011 11:24         no        859         11
## 12: 30/11/2011 17:11         no        461         12
## 13: 28/11/2011 14:14         no        257         13
## 14: 30/11/2011 17:10         no        408         14
## 15: 30/11/2011 17:12         no        779         15
## 16: 28/11/2011 14:15         no        302         16
## 17: 05/12/2011 14:22         no         48         17
## 18: 05/12/2011 11:24         no        361         18
## 19: 05/12/2011 14:23         no         72         19
## 20: 28/11/2011 14:14         no        255         20
```

And finally the submission to Coursera.


```r
pml_write_files = function(x){
  n = length(x)
  path <- ""
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=file.path(path, filename),quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}
pml_write_files(lapply(prediction, as.character))
```

Thanks a lot for reading.

All the best,
Lennart
