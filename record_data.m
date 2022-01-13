function [features,dates] = record_data(recording)

[~ , ~ , raw] = xlsread(recording);

% Remove unnecessary nan rows
if strcmp(recording,'337.xlsx')
    raw = raw(1:31582,:);
end

% Replace missing values with nan
b = cellfun(@num2str,raw,'un',0);
raw(ismember(b,'0')) = {nan};
raw(ismember(b,'{}')) = {nan};

dates = unique(raw(2:end,5));

% Sort dates
[~, idx] = sort(datenum(dates, 'dd/mm/yyyy'), 1, 'ascend');
dates = dates(idx,:);

% Finding indexes of sensors
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


% Saving the relevant data for each sensor
raw = raw(2:end,:);
activity_recognition = raw(idx_activity_recognition,[5,6,10:11]);
calls = raw(idx_calls,[5,6,8,9,11]);
light = raw(idx_light,[5,6,9]);
battery = raw(idx_battery,[5,6,9,10]);
screen_state = raw(idx_screen_state,[5,6,9]);

% Not used yet
accelerometer = raw(idx_accelerometer,[5,6,12:14]);
bluetooth = raw(idx_bluetooth,:);
gyroscope = raw(idx_gyroscope,[5,6,12:14]);
location = raw(idx_location,[5,6,10,12:14]);
magnetic = raw(idx_magnetic,[5,6,12:14]);
wireless = raw(idx_wireless,[5,6,9]);


%% Extracting features from the data
% Creating features matrix
features = zeros(length(dates),12);

% Extracting calls features
[call_count, call_duration] = our_call_features(calls,dates); 
features(:,1) = call_count;
features(:,2) = call_duration;

% Extracting light features
[mean_light,mean_light_night] = our_light_features(light,dates);
features(:,3) = mean_light;
features(:,4) = mean_light_night;

% Extracting screen state features
[mean_screen_usage,last_time,mean_screen_night] = our_screen_feature(screen_state,dates);
features(:,5) = mean_screen_usage;
features(:,6) = last_time;
features(:,7) = mean_screen_night;

% Extracting activities features
[still,on_foot,tilting,vehicle]=our_activity_features(activity_recognition,dates);
features(:,8)=still;
features(:,9)=on_foot;
features(:,10)=tilting;
features(:,11)=vehicle;

% Extracting battery feature
features(:,12) = our_battery_features(battery,dates);

end