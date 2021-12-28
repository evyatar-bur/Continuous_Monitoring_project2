function [still,on_foot,tilting,vehicle] = our_activity_features(activity,dates)

still = nan*zeros(1,length(dates));
on_foot = nan*zeros(1,length(dates));
tilting = nan*zeros(1,length(dates));
vehicle = nan*zeros(1,length(dates));

for i = 1:length(dates)
    
    cur_date = dates{i};
    cur_activity = activity(cellfun(@(x) strcmp(x, cur_date), activity(:,1)),:);
    
    still_count = sum(cellfun(@(x) strcmp(x,'STILL'), cur_activity(:,4)));
    on_foot_count = sum(cellfun(@(x) strcmp(x,'ON_FOOT'), cur_activity(:,4)));
    tilting_count = sum(cellfun(@(x) strcmp(x,'TILTING'), cur_activity(:,4)));
    vehicle_count = sum(cellfun(@(x) strcmp(x,'IN_VEHICLE'), cur_activity(:,4)));

    still(i) = still_count/size(cur_activity,1);
    on_foot(i) = on_foot_count/size(cur_activity,1);
    tilting(i) = tilting_count/size(cur_activity,1);
    vehicle(i) = vehicle_count/size(cur_activity,1);
end

end