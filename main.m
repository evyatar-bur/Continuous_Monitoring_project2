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
    curr_ind = sum(isnan(curr_X),2)>4;

    curr_dates(curr_ind) = [];
    curr_X(curr_ind,:) = [];
    curr_Y(curr_ind) = [];
    
    % Normalize features using first two weeks
    curr_dates = cellfun(@(x) datetime(x,'InputFormat','dd/MM/uuuu'),curr_dates);   % Convert to datetime
    curr_norm_dates = caldays(between(curr_dates(1),curr_dates,'Days'))<14;         % Take only first two weeks
    curr_norm_ind = 1:14;                                                           % Features to normalize
    
    % finding normalization parameters
    [~,curr_C,curr_S] = normalize(curr_X(curr_norm_dates,curr_norm_ind));
    
    % Normalize with aformentioned parameters
    curr_X(:,curr_norm_ind) = normalize(curr_X(:,curr_norm_ind),'center',curr_C,'scale',curr_S);
    
    % Adding features and labels to the data cells
    X_event{curr_r} = curr_X;
    Y_event{curr_r} = curr_Y;

    disp(curr_recording)
end

% Clear unnecessary variables
clear -regexp ^curr;
clear d currentFolder

% Feature names
feature_names = {'call count','call dur','mean light','mean screen usage','Last screen time'...
    ,'still','foot','tilt','vehicle','mean battery','mean wifi signal','sleep time','wake up'...
    ,'feeling','study','sport','family','work/study','stayed home','hangout','late hangout'};

%% Split to train and Test

X_train = cell2mat(X_event(1:14));
Y_train = cell2mat(Y_event(1:14));

X_test = cell2mat(X_event(15:end));
Y_test = cell2mat(Y_event(15:end));

X_event = cell2mat(X_event);
Y_event = cell2mat(Y_event);

%% Feature selection

% Calc Relieff weights
len = size(X_train,2);
W = zeros(len,1);

for j=1:len
    [~,W(j)] = relieff(X_train(:,j),Y_train,10);
end

% Sort features by feature weights
[W,ind] = sort(W,'descend');

X_train = X_train(:,ind);
X_test = X_test(:,ind);
X_event = X_event(:,ind);

feature_names = feature_names(ind);

% % Delete corralated features
% for i = 1:size(X_train,2)
% 
%     if i<size(X_train,2)
% 
%         R = corr(X_train,'type','Spearman');
%         R = R(i,:);
% 
%         ind = (abs(R)>0.7 & R~=1);
% 
%         X_train(:,ind) = [];
%         X_test(:,ind) = [];
%         X_event(:,ind) = [];
%         feature_names(ind) = [];
%         W(ind) = [];
%     end
% end

%% Forward selection for model 1 - RUSboost

best_feature_list_1 = [];
best_score_1 = 0;
method = 'PRC'; % 'F1', 'ROC' or 'PRC' (F1 will not work)'

% Find best feature
[best_feature_list_1,best_score_1] = Add_feature(X_train,X_test,Y_train,Y_test,best_feature_list_1,best_score_1,method,'RUSboost');

% best feature
disp(['The best feature is number: ',num2str(best_feature_list_1(1)),' - ',feature_names{best_feature_list_1(1)}])
disp(['The best PRC score is: ',num2str(best_score_1)])
disp('------------------------------------------')

% Add more features

for i = 1:4

    [best_feature_list_1,best_score_1] = Add_feature(X_train,X_test,Y_train,Y_test,best_feature_list_1,best_score_1,method,'RUSboost');
    disp(['The new best feature is number: ',num2str(best_feature_list_1(end)),' - ',feature_names{best_feature_list_1(end)}])
    disp(['The best PRC score is: ',num2str(best_score_1)])
    disp('------------------------------------------')

end

%% Forward selection for model 2 - Random forest

best_feature_list_2 = [];
best_score_2 = 0;
method = 'PRC'; % 'F1', 'ROC' or 'PRC' (F1 will not work)'

% Find best feature
[best_feature_list_2,best_score_2] = Add_feature(X_train,X_test,Y_train,Y_test,best_feature_list_2,best_score_2,method,'Bag');

% best feature
disp(['The best feature is number: ',num2str(best_feature_list_2(1)),' - ',feature_names{best_feature_list_2(1)}])
disp(['The best PRC score is: ',num2str(best_score_2)])
disp('------------------------------------------')

% Add more features

for i = 1:4

    [best_feature_list_2,best_score_2] = Add_feature(X_train,X_test,Y_train,Y_test,best_feature_list_2,best_score_2,method,'Bag');
    disp(['The new best feature is number: ',num2str(best_feature_list_2(end)),' - ',feature_names{best_feature_list_2(end)}])
    disp(['The best PRC score is: ',num2str(best_score_2)])
    disp('------------------------------------------')

end

clear i j method ind len 

rus_train = X_train(:,best_feature_list_1);
bag_train = X_train(:,best_feature_list_2);

%% Create models Train/Test

% Define tree tamplate
t = templateTree('MaxNumSplits',10);

% RUSboost

% Train RUSboost model
model_RUSboost = fitcensemble(rus_train,Y_train,'method','RUSBoost','NumLearningCycles',100,'Learners',t);

[rus_label,rus_scores] = predict(model_RUSboost,rus_train);

% Compute AUC - PRC
[X,Y,T,score] = perfcurve(Y_train,rus_scores(:,1),'0','XCrit','tpr','YCrit','ppv');




% Train Bag model
model_Bag = fitcensemble(bag_train,Y_train,'method','Bag','NumLearningCycles',100,'Learners',t);


%% Show results




%% Create final model from all of the data



