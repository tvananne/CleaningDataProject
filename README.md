# CleaningDataProject

Getting and Cleaning Data Course Project 
This script reads in data from a directory (UCI HAR Dataset) and puts that data in a "tidy" format.

## How To:

### 1) Set the location of your data
First things first, find this line of code in my script and make sure it points to the your UCI HAR Dataset file (make sure to include the '/' at the end so the code that references this string works properly).

       file.loc <- '~/Analytics/Coursera/03 Getting and Cleaning Data/CourseProjData/UCI HAR Dataset/'

### 2) Execute the run_analysis.R script

After the file.loc script variable has been changed to your data directory, the script can be executed.
The run_analysis.R script: 

1. combines train and test data
2. filters the dataset to only look at variables that deal with mean or standard deviation
3. computes the mean of those fields for each subject / activity combination (ex: Subject 1 - Walking)
4. applies meaningful column names to the data set
5. generates the CleanAndTidy.csv and CleanAndTidy.txt files in your working directory

### 3) Output 

The run_analysis.R script generates the CleanAndTidy.csv and CleanAndTidy.txt files

## Codebook:

Please see the code book in this repo for more information regarding the variables in the output files and 

