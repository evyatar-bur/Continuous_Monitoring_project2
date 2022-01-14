#### README file - Continuous_Monitoring_project2 ####
 
Chosen classification problem - Weekdays vs. Weekend

Our project contains the following scripts and functions:

## make_models.m ##
This script reads all the recordings in the data folder (directory can be changed at the begining of the script - line 10),
extracts features from user data files and label files,
performs feature selection for two different models (Random forest and RUSboost),
Shows relevant graphs and confusion matrices,
and saves the chosen model (RUSboost model) and the final confusion matrix on the test set to .mat files.

## main.m ## 
This function recieves a path containing the data and labels files, 
extracts relevant features from them,
loads the pretrained RUSboost model,
predicts labels using the extracted features and returns a confusion matrix.
