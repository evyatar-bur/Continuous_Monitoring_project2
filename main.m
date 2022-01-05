%% Main
close all
clear
clc

% Save current directory
currentFolder = pwd;

% Changing current directory to data folder
cd('C:\dev\Continuous_Monitoring_project2\Data BHQ\')
addpath(currentFolder)

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
    
    % Remove rows with more than 4 nans
    curr_X(sum(isnan(curr_X),2)>4,:) = [];

    % Normalize features using first two weeks

    dates = cellfun(@(x) datetime(x,'InputFormat','dd/MM/uuuu'),dates);  % Convert to datetime
    norm_dates = caldays(between(dates(1),dates,'Days'))<14;             % Take only first two weeks
    norm_ind = 1:11;                                                     % Features to normalize
    
    % finding normalization parameters
    [~,C,S] = normalize(curr_X(norm_dates,norm_ind));
    
    % Normalize with aformentioned parameters
    curr_X(:,norm_ind) = normalize(curr_X(:,norm_ind),'center',C,'scale',S);
    
    % Adding features and labels to the data cells
    X_event{r} = curr_X;
    Y_event{r} = curr_Y;

    disp(recording)
end

clear r norm_ind label_features 

%% Split to train and Test




%% Feature selection




%% Create model Train/Test




%% Show results




%% Create final model from all of the data



