%% Main
close all
clear
clc

addpath('C:\dev\Continuous_Monitoring_project2\Data BHQ\')

% Read recordings
d=dir('*.label.xlsx');

X_event=zeros(50000,10)-99;    % Allocate memory for matrix X, with default value -99
Y_event=zeros(50000,1)-99;     % Allocate memory for label vector Y

%% Read data

for r=1:length(d)

    % Read data from recordings
    recording = strrep(d(r).name,'.label','');
    
    % Read data from BHQ recording
     = record_data(recording);

     





    B=readtable(gyro_file);
    label_file=strrep(d(r).name,'Acc','Label');
    C=readtable(label_file);
    acc_x=A.x_axis_g_;
    acc_y=A.y_axis_g_;
    acc_z=A.z_axis_g_;
    gyro_x=B.x_axis_deg_s_;
    gyro_y=B.y_axis_deg_s_;
    gyro_z=B.z_axis_deg_s_;







%% Extract features




%% Normalize data




%% Split to train and Test




%% Feature selection




%% Create model Train/Test




%% Show results




%% Create final model from all of the data



