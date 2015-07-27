@@ -0,0 +1,48 @@
> library(plyr)

# Download and unzip the dataset:
fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="dataset.zip", method="curl")
unzip("dataset.zip", exdir="dataset")

#read raw data
testY<- read.table("dataset/UCI HAR Dataset/test/y_test.txt", header=F)
trainY<- read.table("dataset/UCI HAR Dataset/train/y_train.txt", header=F)
testX<- read.table("dataset/UCI HAR Dataset/test/X_test.txt", header=F)
trainX<- read.table("dataset/UCI HAR Dataset/train/X_train.txt", header=F)
subjectTrain<- read.table("dataset/UCI HAR Dataset/train/subject_train.txt", header=F)
subjectTest<- read.table("dataset/UCI HAR Dataset/test/subject_test.txt", header=F)

#combine subject, activity, features files & give col names
subject<- rbind(subjectTrain, subjectTest)
activity<- rbind(trainY, testY)
features<- rbind(trainX, testX)
colnames(subject)[1]="subject"
colnames(activity)[1]="activity"
FeaturesNames<- read.table("dataset/UCI HAR Dataset/features.txt", header=F)
names(features)<- FeaturesNames$V2

#merge subject, activity and features

 Data<- cbind(subject, activity)
 allData<- cbind(features, Data)

 #subset name of features
 subFeatures<- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
 selectedNames<- c(as.character(subFeatures), "subject", "activity")
 allData<- subset(allData, select=selectedNames)

#read activity labels to label the merge data
activityLables<- read.table("dataset/UCI HAR Dataset/activity_labels.txt", header=F)
names(allData)<- gsub("^t", "time", names(allData))
names(allData)<- gsub("^f", "frequency", names(allData))
names(allData)<- gsub("Acc", "Accelerometer", names(allData))
names(allData)<- gsub("Gyro", "Gyroscope", names(allData))
names(allData)<- gsub("Mag", "Magnitude", names(allData))
names(allData)<- gsub("BodyBody", "Body", names(allData))
names(allData)

#count average and write the tidy data
allData2<- aggregate(. ~subject + activity, allData, mean)
allData2<- allData2[order(allData2$subject, allData2$activity),]
write.table(allData2, file="tidydata.txt", row.names=F, col.names=T, sep="\t", quote=F) 
