function [raw,dates,accelerometer,activity_recognition,battery,bluetooth,calls,...
    gyroscope,light,location,magnetic,screen_state,wireless] = record_data(recording)

[~ , ~ , raw]=xlsread(recording);
dates = unique(raw(2:end,5));
raw(2:end,6) = erase(raw(2:end,6),'0 days ');

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

raw = raw(2:end,:);
accelerometer = raw(idx_accelerometer,:);
activity_recognition = raw(idx_activity_recognition,:);
battery = raw(idx_battery,:);
bluetooth = raw(idx_bluetooth,:);
calls = raw(idx_calls,:);
gyroscope = raw(idx_gyroscope,:);
light = raw(idx_light,:);
location = raw(idx_location,:);
magnetic = raw(idx_magnetic,:);
screen_state = raw(idx_screen_state,:);
wireless = raw(idx_wireless,:);
end