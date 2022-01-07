function [mean_battery] = our_battery_features(battery,dates)

mean_battery = nan*zeros(1,length(dates));

for i = 1:length(dates)
    
    cur_date = dates{i};
    cur_battery = battery(cellfun(@(x) strcmp(x, cur_date), battery(:,1)),:);
    
    mean_battery(i) = nanmean(cellfun(@(x) nanmean(x), cur_battery(:,3)));

end

end