function [mean_light] = our_light_features(light,dates)


mean_light = nan*zeros(1,length(dates));

for i = 1:length(dates)
    
    cur_date = dates{i};
    cur_light = light(cellfun(@(x) strcmp(x, cur_date), light(:,1)),:);
    
    mean_light(i) = nanmean(cellfun(@(x) nanmean(x), cur_light(:,3)));
end

end