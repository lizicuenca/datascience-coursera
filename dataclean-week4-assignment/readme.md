# Tidy data 

### What this is for:

This is for assignment of data cleaning as part of coursera data science course. 


### What's included 
In this project, a tidy data set is created out of the data provided by the assignment. 

List of file: 
+ Readme.md 
+ CodeBook.md - schema for tidy data
+ run_analysis.R - a script that is used to create this tidy data from original data
+ tidySmartphonesDataset.csv -  Average of each variable for each activity and each subject. You could reproduce the data using run_analysis.R. 


### Assumption
Assuming that in original data, records are link by order, and one-one mapping. For example, row #1 at subject_* , X_* and y_* are for same observation : 
* : test or train
*/subject_*: represent tester id, 
*/X_*.txt  : oberved data 
*/y_*.txt: directive activity


### Original data source 

Original data source - Coursera Data cleaning week 4 assignment. 

Below is copy from original read me file. 

==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws