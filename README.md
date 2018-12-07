==========================================================================================
Description of the file run_analysis.R script useful to download and process the dataset 
Human Activity Recognition Using Smartphones (programming assignment 3)
==========================================================================================
Files of these datasets were downloaded from the provided url using the download.file 
function and store in an appropriate directory on local hard drive.

The first step of the analysis is to load the variable files common to both the training 
and test sets, thus "activity_labels.txt" and "feature.txt" are read and assigned to two 
variables.

========================= Loading and processing of Test dataset =========================
1. The test dataset is loaded into three variables containing information of the subjects 
assigned to the test group, the activity coded with a number from 1 to 6, and the dataset
with all the measures.
2. An additional variable is created to assign the group "test" to the subjects
3. For readability, already here the activity codes are converted to activity names thus 
thus partially addressing task 3 of the assignment. An extra step is performed to check 
that the conversion is without errors.
4. Finally, the complete test dataset is created by combining all the different information,
consisting in, Subject ID, Subject Group, Activity Name, and measured data.

========================= Loading and processing of Train dataset ========================
The same procedure 1 through 4 described for the test set is performed for the training set

========================= Merging of the two datasets ====================================
Before merging of the two complete training and test sets I check that there are no mistakes
in the order of the columns. Then the two datasets are merged with the rbind() function.

========================= column selection ===============================================
The complete dataset (training and test) is subsetted by selecting those columns that provide
mean and standard deviation measures using the %like% function in the data.table package.
After this subsetting column with information about subject ID, Group and Activity is 
combined to the selected columns.

============================ Improve readability of the columns ==========================
Improved readability of the column names is achieved with different steps using the gsub()
function.

============================ creating Tidy dataset =====================================
Before creating the new tidy dataset, the Activity column of the subsetted dataset is conver_
ted to factor.
Grouping by subject ID and activity is performed simultaneously with the group_by() function.
Calculation of the mean for all the numeric variables in the dataset is performed with the 
summarize_all function and argument funs(mean). These two steps are run using the chaining 
command %>%.
The final tidy dataset is stored in the variable called "newTidyData" as saved as a comma
separated table.



