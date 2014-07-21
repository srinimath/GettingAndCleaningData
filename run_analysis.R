run_analysis <- function(){
  #read features
features <- read.table("./features.txt")
##assign new column names --only for mean and std
features[2] <- sapply(features[2],function(x){x <- as.character(droplevels(x))})

#get and combine test and train data sets
trainData <- read.table("./train/X_train.txt")
testData <- read.table("./test/X_test.txt")
trainActivities <- read.table("./train/Y_train.txt")
testActivities <- read.table("./test/Y_test.txt")
trainSubjects <- read.table("./train/subject_train.txt")
testSubjects <- read.table("./test/subject_test.txt")
allActivities <- rbind(trainActivities,testActivities)
allSubjects <- rbind(trainSubjects,testSubjects)

#rename columns using features data set
names(trainData) <- sapply(names(trainData), function(x){x <- features[as.integer(gsub("V","",x)),2]})
names(testData) <- sapply(names(testData), function(x){x <- features[as.integer(gsub("V","",x)),2]})

#Indicator for Train or Test
trainData <- cbind(TrainorTestIndicator="Train",trainData)
testData <- cbind(TrainorTestIndicator="Test",testData)

#combine Test and Train datasets
allData <- rbind(trainData,testData)

#create a DF to generate Activity names
activityDF <- data.frame(V1=1:6,Activity=c("WALKING", "WALKING_UPSTAIRS",
                                           "WALKING_DOWNSTAIRS", "SITTING", 
                                           "STANDING","LAYING"))

#Generate activity label in all activities data frame
allActivities <- merge(allActivities,activityDF,by=1)
names(allActivities)
lapply(allActivities,class)
#get data relevant to only standard deviation and mean along with Subject and Activity
allData <- cbind(as.character(allActivities$Activity),Subject=allSubjects[1],allData[1],allData[,grep("mean\\()",colnames(allData))],
                 allData[,grep("std\\()",colnames(allData))])


#rename columns of allData to be more descriptive
names(allData)[1] <- "Activity"
names(allData)[2] <- "Subject"
allData$Activity <- as.character(allData$Activity)
names(allData) <- sapply(names(allData),function(x){x <- gsub("*-mean\\()","Mean",x)})
names(allData) <- sapply(names(allData),function(x){x <- gsub("*-std\\()","StdDev",x)})
names(allData) <- sapply(names(allData),function(x){x <- gsub("*-X","AlongX",x)
                                              x <- gsub("*-Y","AlongY",x)
                                              x <- gsub("*-Z","AlongZ",x)})
#write combined data into a file
write.table(allData,"TidyData.txt",sep=",",row.names=FALSE)

#generate average of mean and std far each Activity, Subject 
groupedStdDevT <- aggregate( allData[,grep("StdDev",colnames(allData))], 
                             as.data.frame(allData[,1:2]), FUN = mean )
names(groupedStdDevT)[3:length(names(groupedStdDevT))] <- sapply(names(groupedStdDevT)[3:length(names(groupedStdDevT))],
                                                                 function(x){x <- paste("Avg",x,sep="")})
groupedMeanT <- aggregate( allData[,grep("Mean",colnames(allData))], 
                           as.data.frame(allData[,1:2]), FUN = mean )
names(groupedMeanT)[3:length(names(groupedMeanT))] <- sapply(names(groupedMeanT)[3:length(names(groupedMeanT))],
                                                             function(x){x <- paste("Avg",x,sep="")})
groupedDataT <- merge(groupedMeanT,groupedStdDevT,by = c("Activity", "Subject"))
groupedDataT$Activity <- as.character(groupedDataT$Activity)

#sort data based on grouped columns
groupedDataT <- groupedDataT[order(groupedDataT[1],groupedDataT[2]),]

#write grouped data into a file
write.table(groupedDataT,"GroupedTidyData.txt",sep=",",row.names=FALSE)
}