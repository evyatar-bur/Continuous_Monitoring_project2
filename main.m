%% Main
close all
clear
clc

cd('C:\dev\Continuous_Monitoring_project2\Data BHQ\')
addpath('C:\dev\Continuous_Monitoring_project2\')

% Read recordings
d=dir('*.label.xlsx');

X_event=zeros(50000,10)-99;    % Allocate memory for matrix X, with default value -99
Y_event=zeros(50000,1)-99;     % Allocate memory for label vector Y

%% Read data

for r=1:length(d)

    % Read data from recordings
    recording = strrep(d(r).name,'.label','');
    
    % Read data from BHQ recording
    [raw,dates,accelerometer,activity_recognition,battery,bluetooth,calls,...
    gyroscope,light,location,magnetic,screen_state,wireless] = record_data(recording);



    
    disp(recording)
end














%% Extract features




%% Normalize data




%% Split to train and Test




%% Feature selection




%% Create model Train/Test




%% Show results




%% Create final model from all of the data



