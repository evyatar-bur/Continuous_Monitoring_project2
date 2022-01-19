function [mean_screen_usage,last_time,mean_screen_night] = our_screen_feature(screen_state,dates)
%This function calculates relevant features from the screen sensor

mean_screen_usage = nan*zeros(1,length(dates));
mean_screen_night = nan*zeros(1,length(dates));
last_time = nan*zeros(1,length(dates));

for i = 1:length(dates)
    
    cur_date = dates{i};
    cur_screen = screen_state(cellfun(@(x) strcmp(x, cur_date), screen_state(:,1)),:);
    
    cur_screen_night = cur_screen(cellfun(@(x) x>0.833, cur_screen(:,2)),3);
    
    screen_count = sum(cellfun(@(x) strcmp(x,'on'), cur_screen(:,3)));
    mean_screen_usage(i) = screen_count/size(cur_screen,1);

    screen_count_night = sum(cellfun(@(x) strcmp(x,'on'), cur_screen_night));
    mean_screen_night(i) = screen_count_night/size(cur_screen_night,1);

    if isnan(mean_screen_night(i))
        mean_screen_night(i) = mean_screen_usage(i);
    end

    screen_on = cur_screen(cellfun(@(x) strcmp(x,'on'), cur_screen(:,3)),2);
    
    if ~isempty(screen_on)
        last_time(i) = screen_on{end};
    end
end

end