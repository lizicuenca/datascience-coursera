# Read data
# 
#
#
library(futile.logger)

flog.threshold(DEBUG)

flog.info("Hello, %s", "Week 4 assignment")

#
# Get feature names
#
readFeatureFieldsName <- function(){
  
  fileName <- "features_name.txt"
  featureNameDF <- read.csv(fileName,sep = " ",header = FALSE)
  gsub("[[:punct:]]", "_", featureNameDF[,2])
  
}

#
# Convert fixed width feature data into csv format1
#
createCSVFile <- function(inputFile, outputFile){
  
  print("work in progress")
  fileName=inputFile
  con=file(fileName,open="r")
  line=readLines(con ) 
  
  vector <- c()
  
  long=length(line)
  for (i in 1:long){
    linn=line[i]
    sprintf("Line= %s",i)
    commastring <-substr(linn, 1, 16)
    
    for (j in 1:560){
      commastring<- paste(commastring, substr(linn, 16*j+1, 16*j+16), sep=',')  
    }
    vector <- c(vector, commastring)
  }
  close(con)
  
  fileConn<-file(outputFile)
  writeLines(vector, fileConn)
  close(fileConn)
  print("job completed")
}

#
# Convert feature data into csv file
#
converFeaturesToCSV <- function(){
  # convert for test data 
  fileName_Features <- "./UCI HAR Dataset/test/X_test.txt" 
  fileName_FeaturesCSV <-  "x_test.csv"
  
  createCSVFile(fileName_Features, fileName_FeaturesCSV)
  
  # convert for training data
  fileName_Features <- "./UCI HAR Dataset/train/X_train.txt" 
  fileName_FeaturesCSV <-  "x_train.csv"
  
  createCSVFile(fileName_Features, fileName_FeaturesCSV)
  
}

#
# For feature data in csv file format, read the data, clean out the axial from the dataset
#
getCleanDataFeatures <- function(featuresCSVFile){
  
  featuresDF <- read.csv(featuresCSVFile,header = FALSE )
  
  flog.info("read features - read from csv: length  %d", length(featuresDF))
  
  
  # add fields name for 
  fieldnames <- readFeatureFieldsName()
  names(featuresDF)<- c(fieldnames )
  
  #select only required data field
  featuresDFSub <- featuresDF[,grep("_mean_|_std_",fieldnames)]
  
#   #split each field into two fields
#   fieldnames <- names(featuresDFSub)
#   
#   splitDF  <- data.frame()
#   
#   splitlist <- list() #create an empty list
#   splitColNames <- list()
#   
#   for (i in 1:length(fieldnames)){
#     
#     fieldNameToSplit = fieldnames[i]
#     asplit <- strsplit(as.character(featuresDFSub[,i]),'e[-+]')
#     
#     splitlist[[i]] <- sapply(asplit, "[[", 1)
#     #splitlist[[i*2]] <- sapply(asplit, "[[", 2)
#     
#     splitColNames[i] <- fieldNameToSplit
#     
#     
#     # foo <- data.frame(do.call('rbind',strsplit(as.character(featuresDFSub$fieldNameToSplit),'e-',fixed=TRUE))
#     
#   }
#   
#   flog.info("read features - A list")
#   
#   
#   df <- do.call("rbind",splitlist) #combine all vectors into a matrix
#   df <- data.frame(t(df))
#   
#   names(df) <- splitColNames
#   
#   flog.info("read features - set data type")
#   
#   # transform data into right data format: 
#   #features <- grep(".axial", names(df),invert = TRUE)
# #  df[, ] <- sapply(df[,], as.numeric)
#   # work on axial 
#   #features <- grep(".axial", names(df))
#   #df[, features] <- sapply(df[, features], as.factor)
  
#  flog.info("read features - Finished - result data size %d", length(df))
  
#  df

}

#
# For given file name of subject, activity and feature csv files, combine the data into one dataset
#  
getCleanData <- function(subjectFile,activityFile,featuresCSVFile  ){

  subjectDF <- read.csv(subjectFile, header = FALSE )
  activityDF <- read.csv(activityFile, header = FALSE)

  
  # reduce data volume by only number of that we need - using activity table row number
  #### NOTE: for some reason, my computer always dead on this , i have to create csv file instead
  #featuresDF <- read.fwf(fileName_Features, widths=fieldWidths, header = FALSE, n=2)
  df <- getCleanDataFeatures(featuresCSVFile)
 
  #combine subject, featuresDF and activity together
  
  df["subject"] <- subjectDF[,1]
  df["activity"] <- activityDF[,1]
  
  df[, "subject"] <- sapply(df[, "subject"], as.factor)
  df[, "activity"] <- sapply(df[, "activity"], as.factor)
  
  flog.info("appended subject and activity data")
  
  df

}

#
# Merge Test data and training data together
#
combineData <- function(){
  
  fileName_Subject <- "./UCI HAR Dataset/test/subject_test.txt"
  fileName_Activity <- "./UCI HAR Dataset/test/y_test.txt"
  fileName_FeaturesCSV <-  "x_test.csv"

  testDF <- getCleanData(fileName_Subject,fileName_Activity,  fileName_FeaturesCSV)
  
  fileName_FeaturesCSV <-  "x_train.csv"
  fileName_Subject <- "./UCI HAR Dataset/train/subject_train.txt"
  fileName_Activity <- "./UCI HAR Dataset/train/y_train.txt"  
   
  trainDF <- getCleanData(fileName_Subject,fileName_Activity, fileName_FeaturesCSV)
  
  allDF <- rbind(testDF, trainDF)
  
}

#
# Group by subject and activity, and get mean for all other data set
#
getTidyData <- function(richDF){
  
  #library(dplyr)
  
  #tidyDF <- testDF[,grep(".axial", names(df),invert = TRUE)]
  #tidyDF$subject <- richDF[,"subject"]
  #tidyDF$activity <- richDF[,"activity"]
  
 # tidyDF1 <- tidyDF %>% group_by(subject, activity) %>% 
  #        summarise_each(funs(mean),-(133:134))
  tidy <- aggregate(. ~ subject + activity, richDF, mean)
  
}


# due performance issue with my machine, convert feature into csv first
flog.info("convert feature data into csv ")
converFeaturesToCSV()

# combine test data and train data 
flog.info("combine test data and train data ")
allDF <- combineData()

# combine test data and train data 
flog.info("get final clean data ")
tidyDF<- getTidyData(allDF)

# writ complete tidy data set into file
flog.info("writ complete tidy data set into file ")
write.csv(tidyDF, "tidySmartphonesDataset.csv")

