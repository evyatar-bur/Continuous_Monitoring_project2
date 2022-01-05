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
    curr_recording = strrep(d(r).name,'.label','');
    
    % Read data from BHQ recording
    [curr_record_features,curr_dates] = record_data(curr_recording);
    
    % Read data from label file
    [curr_label_features] = label_data(d(r).name,curr_dates);
    
    % Creating feature matrix and label vector
    curr_X = [curr_record_features,curr_label_features];
    curr_Y = label_classifier(curr_dates);
    
    % Remove rows with more than 4 nans
    curr_dates(sum(isnan(curr_X),2)>4) = [];
    curr_X(sum(isnan(curr_X),2)>4,:) = [];
    
    % Normalize features using first two weeks
    curr_dates = cellfun(@(x) datetime(x,'InputFormat','dd/MM/uuuu'),curr_dates);  % Convert to datetime
    curr_norm_dates = caldays(between(curr_dates(1),curr_dates,'Days'))<14;             % Take only first two weeks
    curr_norm_ind = 1:11;                                                     % Features to normalize
    
    % finding normalization parameters
    [~,curr_C,curr_S] = normalize(curr_X(curr_norm_dates,curr_norm_ind));
    
    % Normalize with aformentioned parameters
    curr_X(:,curr_norm_ind) = normalize(curr_X(:,curr_norm_ind),'center',curr_C,'scale',curr_S);
    
    % Adding features and labels to the data cells
    X_event{r} = curr_X;
    Y_event{r} = curr_Y;

    disp(curr_recording)
end

clear -regexp ^curr;
clear d currentFolder

%% Split to train and Test




%% Feature selection




%% Create model Train/Test




%% Show results




%% Create final model from all of the data



