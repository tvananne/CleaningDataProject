

setwd("~/Analytics/Coursera/03 Getting and Cleaning Data/CourseProj")

require('data.table')
require('dplyr')
library(data.table)
library(dplyr)


# Initialize script variables *************************************************************************** 
       library(data.table)
       #set your location for the data files here in file.loc
       file.loc <- '~/Analytics/Coursera/03 Getting and Cleaning Data/CourseProjData/UCI HAR Dataset/' 
       activity_labels <- fread(paste(file.loc, "activity_labels.txt", sep = ""))
       activityNumber <- 'actyNumb'
       subjectNumber <- 'subjectNumber'
       feature <- fread(paste(file.loc, "features.txt", sep = ""))
       feature_labels <- feature$V2; rm(feature)       

# Combine TEST data into one file ***********************************************************************
       X_test <- fread(paste(file.loc, "test/X_test.txt", sep = ""))
       colnames(X_test) <- feature_labels
       
       test_subjects <- fread(paste(file.loc, "test/subject_test.txt", sep = ""))
       colnames(test_subjects) <- subjectNumber
       
       Y_test <- fread(paste(file.loc, "test/y_test.txt", sep = ""))
       colnames(activity_labels) <- c(activityNumber, 'actyLabel')
       colnames(Y_test) <- activityNumber
       test <- cbind(X_test, test_subjects, Y_test) #put the activity type label at the end of each observation
       rm(X_test, Y_test)
       
       #subjects, data, and activities are all merged, now need to join the activity label descriptions to activity number:
       setkey(test, 'actyNumb')
       setkey(activity_labels, 'actyNumb')
       new_test <- test[activity_labels]
       head(new_test)
       
       rm(test)      #keep global environment clean
       
# Combine TRAIN data into one file **********************************************************************
       X_train <- fread(paste(file.loc, "train/X_train.txt", sep = ""))
       colnames(X_train) <- feature_labels
       
       train_subjects <- fread(paste(file.loc, "train/subject_train.txt", sep = ""))
       colnames(train_subjects) <- subjectNumber
       
       
       Y_train <- fread(paste(file.loc, "train/y_train.txt", sep = ""))
       colnames(activity_labels) <- c(activityNumber, 'actyLabel')
       colnames(Y_train) <- activityNumber
       
       train <- cbind(X_train, train_subjects, Y_train) #put the activity type label at the end of each observation
       rm(X_train, Y_train)
       head(train)
       
       #match the activity label to the activity number
       setkey(train, 'actyNumb')
       setkey(activity_labels, 'actyNumb')
       new_train <- train[activity_labels]
       
       head(new_train)
       
       
                     #interesting - how the subjects broke down for train/test
                     unique(new_train$subjectNumber)
                     unique(new_test$subjectNumber)
       
# Combine TEST and TRAIN into 'combined' data set ***************************************************    
       
       #need both data sets in a list for combining data.table
       l = list(new_test, new_train)
       
       #this is the combined (train and test) data table
       combined <- data.table()
       combined <- rbindlist(l, use.names = TRUE, fill = TRUE)
              #get rid of the test and train data.tables
              if(length(combined) > 0) {
                     rm(new_test, new_train, l)
                     print("train and test have been combined!")
              } else {
                     print("Something went wrong! 'combined' data.table has a length of 0")
              }
       

# This block builds the actual tidy data set we are after ******************************************
       feature_labels <- c(feature_labels, subjectNumber, activityNumber, 'actyLabel')
       rm(train, activityNumber)
       
       #this will hold the logical vector which will be used to subset combined for mean / std
       trueMean = character()      
       
              for(i in 1:length(feature_labels)) {
                     trueMean[i] <- (grepl('mean|std|acty|subjectNumber', feature_labels[i]))
              }
       
       #trueMean must be logical:
       trueMean <- as.logical(trueMean)
       
       #extraction is the list of features labels that have 'mean' and/or 'std'
       extraction <- feature_labels[trueMean] ; tail(extraction) ; #subjectNumber, actyNumb, and actyLabel still here
       combinedDF <- as.data.frame(combined)     #this type of subset doesn't work on DT, only DF
       meanAndStd <- (combinedDF[extraction])
       class(meanAndStd); rm(combinedDF)         #meanAndStd is a DF of the features we want, remove combinedDF

       #meanAndStd is our data.frame with mean / standard deviation and the activity number / label
       meanAndStd <- as.data.table(meanAndStd)

       
       subDF <- as.data.frame(meanAndStd)
       if(ncol(subDF > 0)) { rm(meanAndStd)} else {print("subDF was not created properly")}
       
       #all column names except the last 3
       dirtyCols <- names(subDF[1:(ncol(subDF) - 3)])
       dirtyCols
       
       #just the last three columns
       cleanCols <- 1:length(dirtyCols)
       cleanCols.2 <- names(subDF[(length(dirtyCols)+1):ncol(subDF)])
       cleanCols.3 <- c(cleanCols, cleanCols.2)
       cleanCols.3
       
       #make the columns more manageable to work with... for now
       colnames(subDF) <- cleanCols.3
       colnames(subDF)
       
       #these will be the new columns after the dyplr summarizing
       newColNames <- c('Subject', 'Activity', dirtyCols)
       
       #going to convert to a data.table for dypler functions (for speed I guess?)
       subDT <- as.data.table(subDF)
       
       subDT <- arrange(subDT, actyNumb)
       subDT <- arrange(subDT, subjectNumber)
       
       head(subDT, 100)
       
       subDT.grp <- group_by(subDT, subjectNumber, actyLabel) 
       
       #has to be a better way, but this function took 10 seconds to produce in excel
       #see 'FormulaHelper.xlsx' file in this repo for a reference
       subDT.summ <- summarize(subDT.grp, `1` = mean(`1`),
                               `2` = mean(`2`),
                               `3` = mean(`3`),
                               `4` = mean(`4`),
                               `5` = mean(`5`),
                               `6` = mean(`6`),
                               `7` = mean(`7`),
                               `8` = mean(`8`),
                               `9` = mean(`9`),
                               `10` = mean(`10`),
                               `11` = mean(`11`),
                               `12` = mean(`12`),
                               `13` = mean(`13`),
                               `14` = mean(`14`),
                               `15` = mean(`15`),
                               `16` = mean(`16`),
                               `17` = mean(`17`),
                               `18` = mean(`18`),
                               `19` = mean(`19`),
                               `20` = mean(`20`),
                               `21` = mean(`21`),
                               `22` = mean(`22`),
                               `23` = mean(`23`),
                               `24` = mean(`24`),
                               `25` = mean(`25`),
                               `26` = mean(`26`),
                               `27` = mean(`27`),
                               `28` = mean(`28`),
                               `29` = mean(`29`),
                               `30` = mean(`30`),
                               `31` = mean(`31`),
                               `32` = mean(`32`),
                               `33` = mean(`33`),
                               `34` = mean(`34`),
                               `35` = mean(`35`),
                               `36` = mean(`36`),
                               `37` = mean(`37`),
                               `38` = mean(`38`),
                               `39` = mean(`39`),
                               `40` = mean(`40`),
                               `41` = mean(`41`),
                               `42` = mean(`42`),
                               `43` = mean(`43`),
                               `44` = mean(`44`),
                               `45` = mean(`45`),
                               `46` = mean(`46`),
                               `47` = mean(`47`),
                               `48` = mean(`48`),
                               `49` = mean(`49`),
                               `50` = mean(`50`),
                               `51` = mean(`51`),
                               `52` = mean(`52`),
                               `53` = mean(`53`),
                               `54` = mean(`54`),
                               `55` = mean(`55`),
                               `56` = mean(`56`),
                               `57` = mean(`57`),
                               `58` = mean(`58`),
                               `59` = mean(`59`),
                               `60` = mean(`60`),
                               `61` = mean(`61`),
                               `62` = mean(`62`),
                               `63` = mean(`63`),
                               `64` = mean(`64`),
                               `65` = mean(`65`),
                               `66` = mean(`66`),
                               `67` = mean(`67`),
                               `68` = mean(`68`),
                               `69` = mean(`69`),
                               `70` = mean(`70`),
                               `71` = mean(`71`),
                               `72` = mean(`72`),
                               `73` = mean(`73`),
                               `74` = mean(`74`),
                               `75` = mean(`75`),
                               `76` = mean(`76`),
                               `77` = mean(`77`),
                               `78` = mean(`78`),
                               `79` = mean(`79`))
       
       colnames(subDT.summ) <- newColNames
       
       write.csv(subDT.summ, file = "CleanAndTidy.csv")
       write.table(subDT.summ, file = "CleanAndTidy.txt", row.names = FALSE)
       
      rm(activity_labels, combined, subDF, subDT, subDT.grp, test_subjects, train_subjects)
       