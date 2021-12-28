function [features] = record_data(recording)

[~ , ~ , raw] = xlsread(recording);

if strcmp(recording,'337.xlsx')
    raw = raw(1:31582,:);
end

% Replace missing values with nan
b = cellfun(@num2str,raw,'un',0);
raw(ismember(b,'0')) = {nan};
raw(ismember(b,'{}')) = {nan};

dates = unique(raw(2:end,5));

idx_accelerometer = cellfun(@(x) strcmp(x, 'acelerometer'), raw(2:end,7));
idx_activity_recognition = cellfun(@(x) strcmp(x, 'activity_recognition'), raw(2:end,7));
idx_battery = cellfun(@(x) strcmp(x, 'battery'), raw(2:end,7));
idx_bluetooth = cellfun(@(x) strcmp(x, 'bluetooth'), raw(2:end,7));
idx_calls = cellfun(@(x) strcmp(x, 'calls'), raw(2:end,7));
idx_gyroscope = cellfun(@(x) strcmp(x, 'gyroscope'), raw(2:end,7));
idx_light = cellfun(@(x) strcmp(x, 'light'), raw(2:end,7));
idx_location = cellfun(@(x) strcmp(x, 'location'), raw(2:end,7));
idx_magnetic = cellfun(@(x) strcmp(x, 'magnetic'), raw(2:end,7));
idx_screen_state = cellfun(@(x) strcmp(x, 'screenstate'), raw(2:end,7));
idx_wireless = cellfun(@(x) strcmp(x, 'wireless'), raw(2:end,7));


% saving the relevant data for each sensor

raw = raw(2:end,:);
accelerometer = raw(idx_accelerometer,[5,6,12:14]);
activity_recognition = raw(idx_activity_recognition,[5,6,10:11]);
battery = raw(idx_battery,[5,6,10]);
bluetooth = raw(idx_bluetooth,:);
calls = raw(idx_calls,[5,6,8,9,11]);
gyroscope = raw(idx_gyroscope,[5,6,12:14]);
light = raw(idx_light,[5,6,9]);
location = raw(idx_location,[5,6,10,12:14]);
magnetic = raw(idx_magnetic,[5,6,12:14]);
screen_state = raw(idx_screen_state,[5,6,9]);
wireless = raw(idx_wireless,[5,6,9]);

%% extracting features from the data
%creating features matrix
features=zeros(length(dates),45);

%extracting calls features
[call_count, call_duration]= our_call_features(calls,dates); 
features(:,1)=call_count;
features(:,2)=call_duration;

%extracting light features
[mean_light]= our_light_features(light,dates);
features(:,3)=mean_light;

%extracting screen state features
[mean_screen_usage]= our_light_features(light,dates);
features(:,4)=mean_screen_usage;

%extracting activities features
[still,on_foot,tilting,vehicle]=our_activity_features(activity_recognition,dates);
features(:,5)=still;
features(:,6)=on_foot;
features(:,7)=tilting;
features(:,8)=vehicle;


%% accelerometer features
% last_date=accelerometer(1,1);
% day = 1;
% axis_mat=[];
% 
% for i= 1: length(accelerometer)
%     date = accelerometer(i,1);
%     axis_vec = [accelerometer(i,3:end)];
% 
%     if strcmp(date,last_date)
%         axis_mat = [axis_mat,axis_vec];
%     
%     else
%         
%         axis_acc_mean = mean(axis_mat(:));
%         features(day,1)=axis_acc_mean;
% 
%         axis_mat = axis_vec;
% 
%         day = day + 1;
% 
%     end
% 
%     last_date = date;
% 
% end