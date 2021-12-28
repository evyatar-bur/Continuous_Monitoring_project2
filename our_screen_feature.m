function [mean_screen_usage] = our_screen_feature(screen_state,dates)

mean_screen_usage = nan*zeros(1,length(dates));

for i = 1:length(dates)
    
    cur_date = dates{i};
    cur_screen = screen_state(cellfun(@(x) strcmp(x, cur_date), screen_state(:,1)),:);
    
    screen_count = sum(cellfun(@(x) strcmp(x,'on'), cur_screen(:,3)));

    mean_screen_usage(i) = screen_count/size(cur_screen,1);
end

end