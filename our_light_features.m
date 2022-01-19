function [mean_light,mean_light_night] = our_light_features(light,dates)
%This function calculates relevant features from the light sensor

mean_light = nan*zeros(1,length(dates));
mean_light_night = nan*zeros(1,length(dates));

for i = 1:length(dates)

    cur_date = dates{i};
    cur_light = light(cellfun(@(x) strcmp(x, cur_date), light(:,1)),:);
    cur_vec = cellfun(@(x) str2double(x), cur_light(:,3));
    
    cur_vec = fillmissing(cur_vec,'linear','EndValues','nearest');

    cur_light_night = cur_vec(cellfun(@(x) x>0.833, cur_light(:,2)));
    
    mean_light(i) = mean(cur_vec);
    mean_light_night(i) = mean(cur_light_night);

    if isempty(cur_light_night)
        mean_light_night(i) = 0;
    end

end

end