function [raw,dates,accelerometer,activity_recognition,battery,bluetooth,calls,...
    gyroscope,light,location,magnetic,screen_state,wireless] = record_data(recording)

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



end