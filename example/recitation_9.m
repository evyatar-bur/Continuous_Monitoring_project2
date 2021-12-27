[num, txt, raw]=xlsread('330');
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

%% calls analysis

user = {'334','330','332','331'};
date = cell(1,size(user,2)); count = date; duration = date;
[date{1,1}, count{1,1}, duration{1,1}] = calls_features(user{1});
[date{1,2}, count{1,2}, duration{1,2}] = calls_features(user{2});
[date{1,3}, count{1,3}, duration{1,3}] = calls_features(user{3});
[date{1,4}, count{1,4}, duration{1,4}] = calls_features(user{4});

for i = 1:size(date,2)
    
    norm_count = normalize_feature(count{1,i});
    norm_duration = normalize_feature(duration{1,i});
    
    figure; 
    yyaxis left; plot(datetime(date{1,i}),norm_count); xlabel('Date','FontSize',14); ylabel('Total # of calls - normalized','FontSize',14) 
    yyaxis right; plot(datetime(date{1,i}),norm_duration); ylabel('Total calls time - normalized','FontSize',14)
    title(['User : ' user{i}])
    ax=gca;
    ax.FontSize = 14;
    
end

%% light analysis

user = {'332','351'};
date = cell(1,size(user,2)); level = date;
t_init = '20:00:00';

[date{1,1}, max_level_from_t{1,1}] = light_features(user{1},t_init);
[date{1,2}, max_level_from_t{1,2}] = light_features(user{2},t_init);
 
for i = 1:size(date,2)

    norm_max_level = normalize_feature(max_level_from_t{1,i});
    figure; 
    plot(datetime(date{1,i}),norm_max_level); xlabel('Date','FontSize',14); ylabel(['Max light level from ' t_init '- normalized'],'FontSize',14) 
    title(['User : ' user{i}])
    ax=gca;
    ax.FontSize = 14;
    
end