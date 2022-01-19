function [confusion_matrix] = main(path)


% Save current directory
currentFolder = pwd;

% Changing current directory to data folder
cd(path)
addpath(currentFolder)

% Read recordings
d=dir('*.label.xlsx');

X_cell = cell(size(d,1),1);    % Feature cell
Y_cell = cell(size(d,1),1);    % Label cell

%% Read data

for curr_r=1:length(d)

    % Read data from recordings
    curr_recording = strrep(d(curr_r).name,'.label','');
    
    % Read data from BHQ recording
    [curr_record_features,curr_dates] = record_data(curr_recording);
    
    % Read data from label file
    [curr_label_features] = label_data(d(curr_r).name,curr_dates);
    
    % Creating feature matrix and label vector
    curr_X = [curr_record_features,curr_label_features];
    curr_Y = label_classifier(curr_dates);
    
    % Remove rows with more than 4 nans
    curr_ind = sum(isnan(curr_X),2)>5; 
    
    curr_dates(curr_ind) = [];    
    curr_X(curr_ind,:) = [];          
    curr_Y(curr_ind) = [];             

    % Normalize features using first two weeks
    curr_dates = cellfun(@(x) datetime(x,'InputFormat','dd/MM/uuuu'),curr_dates);   % Convert to datetime
    curr_norm_dates = caldays(between(curr_dates(1),curr_dates,'Days'))<14;         % Take only first two weeks
    curr_norm_ind = 1:16;                                                           % Features to normalize
    
    % Finding normalization parameters
    [~,curr_C,curr_S] = normalize(curr_X(curr_norm_dates,curr_norm_ind));
    
    % Normalize with aformentioned parameters
    curr_X(:,curr_norm_ind) = normalize(curr_X(:,curr_norm_ind),'center',curr_C,'scale',curr_S);
    
    % Adding features and labels to the data cells
    X_cell{curr_r} = curr_X;
    Y_cell{curr_r} = curr_Y;

    %disp(curr_recording)
end

% Combine cells to data matrices
X = cell2mat(X_cell);
Y = cell2mat(Y_cell);

% Use only relevant features, in the correct order
features = [17 23 11 20 19 21 18 16 10 8];
X = X(:,features);

% Load trained RUSboost model
model_struct = load('RUSboost_model.mat');
model = model_struct.final_model;

% Predict
prediction = predict(model,X);

% Calculate confusion matrix
confusion_matrix = confusionmat(Y,prediction);
