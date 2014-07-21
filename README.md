#Merged Accelerometer data from Train and Test

##Srinivasa Mathkur


The scope of this project is to merge Test and Train data, provided in course project in Getting and Cleaning Data course, and generate a new tidy 
data set grouped on Activity and Subject.

This directory includes 4 files:

1. run_analysis.R
2. run_Analysis_TidyData_CodeBook
3. run_analysis_GroupedTidyData_CodeBook
4. README.md

1. On sourcing and running run_analysis.R in the same directory as where the datasets for Test and Train data sets are present, two new files named and 
described as below are generated:
	a. TidyData.txt - This is a comma separated text file that will have all merged data from Test and Train with fields related to only mean 
	   and standard deviation. This will also include descriptive Activity field, Subject field and TestorTrainIndicator.
	b.GroupedTidyData.txt - This is the final output from the above dataset where averages of means and standard deviations based on Activity and Subject.
2. run_Analysis_TidyData_CodeBook will provide the details of all variables for TidyData.txt (See a. above)
2. run_analysis_GroupedTidyData_CodeBook will provide the details of all variables for GroupedTidyData.txt (See b. above)