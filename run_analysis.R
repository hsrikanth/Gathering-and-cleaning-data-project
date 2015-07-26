#Download and unzip file into working directory
download.file('http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',destfile='getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip')
unzip('getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip')

#Read training data
X_train <- read.table('UCI HAR Dataset/train/X_train.txt',header=F)
y_train <- read.table('UCI HAR Dataset/train/y_train.txt',header=F)
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt',header=F)

#Combine X_train, y_train and subject_train into one table
all_train <- cbind(y_train,subject_train,X_train)

#Read test data
X_test <- read.table('UCI HAR Dataset/test/X_test.txt',header=F)
y_test <- read.table('UCI HAR Dataset/test/y_test.txt',header=F)
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt',header=F)

#Combine X_test, y_test and subject_test into one table
all_test <- cbind(y_test,subject_test,X_test)

#Combine train and test data
#This completes Step 1 in the course project
all_data <- rbind(all_train,all_test)

#Read feature list
feature_list <- read.table('UCI HAR Dataset/features.txt',header=F)

#Assign descriptive column names to combined train and test data
#This is also useful for completing Step 4 in the course project
colnames(all_data) <- c('Activity.ID','Subject.ID',as.character(feature_list$V2))

#Extract columns containing mean() and std() into a new data frame using grep
#This completes Step 2 in the course project
df_meanstd <- all_data[,c(1,2,grep('mean()',colnames(all_data),fixed=T),grep('std()',colnames(all_data),fixed=T))]

#Read activity labels and assign column names for merging with df_meanstd
act.labels <- read.table('UCI HAR Dataset/activity_labels.txt',header=F)
colnames(act.labels) <- c('Activity.ID','Activity.Label')

#Merge activity labels with df_meanstd by the Activity.ID column in order to assign descriptive activity names to name the activities in the data set
df_meanstd_merged <- merge(act.labels,df_meanstd,by='Activity.ID')

#Remove the Activity.ID column from the dataset as it is no longer required
#The updated data frame df_meanstd_merged has descriptive activity names for activities as well as descriptive column names for all the columns
#This completes steps 1-4 in the course project
df_meanstd_merged <- df_meanstd_merged[,2:ncol(df_meanstd_merged)]

#Use the aggregate function to compute the mean of all columns grouped by Activity.Label and Subject.ID
df_meanstd_merged_aggregated <- aggregate(df_meanstd_merged[,3:ncol(df_meanstd_merged)],by=list(df_meanstd_merged$Activity.Label,df_meanstd_merged$Subject.ID),FUN=mean,na.rm=T)

#Give descriptive column names for df_meanstd_merged_aggregated by denoting that the columns represent averaged values
colnames(df_meanstd_merged_aggregated) <- c('Activity.Label','Subject.ID',paste('Average of',colnames(df_meanstd_merged_aggregated)[3:ncol(df_meanstd_merged_aggregated)]))

#Write df_meanstd_merged_aggregated to a txt file
write.table(df_meanstd_merged_aggregated,'project_output.txt',row.name=F)




