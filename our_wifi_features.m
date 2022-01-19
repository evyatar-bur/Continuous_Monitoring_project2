function [mean_wifi] = our_wifi_features(wifi,dates)
%This function calculates relevant features from the wifi sensor

mean_wifi = zeros(1,length(dates));

for i = 1:length(dates)
    
    cur_date = dates{i};
    cur_wifi = wifi(cellfun(@(x) strcmp(x, cur_date), wifi(:,1)),:);
    
    mean_wifi(i) = nanmean(cellfun(@(x) nanmean(x), cur_wifi(:,3)));

end

end