%% Main
close all
clear
clc

cd('C:\dev\Continuous_Monitoring_project2\Data BHQ\')
addpath('C:\dev\Continuous_Monitoring_project2\')

% Read recordings
d=dir('*.label.xlsx');

X_event = cell(size(d,1),1);    % Feature cell
Y_event = cell(size(d,1),1);    % Label cell

%% Read data

for r=1:length(d)

    % Read data from recordings
    recording = strrep(d(r).name,'.label','');
    
    % Read data from BHQ recording
    [record_features,dates] = record_data(recording);
    
    % Read data from label file
    [label_features] = label_data(d(r).name,dates);
    
    % Creating feature matrix and label vector
    curr_X = [record_features,label_features];
    curr_Y = label_classifier(dates);

    X_event{r} = curr_X;
    Y_event{r} = curr_Y;

    disp(recording)
end














%% Extract features




%% Normalize data




%% Split to train and Test




%% Feature selection




%% Create model Train/Test




%% Show results




%% Create final model from all of the data



