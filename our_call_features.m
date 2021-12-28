function [call_count, call_duration] = our_call_features(calls,dates)

call_count = zeros(1,length(dates));
call_duration = call_count;

for i = 1:length(dates)

    cur_date = dates{i};
    cur_calls=calls(cellfun(@(x) strcmp(x, cur_date), calls(:,1)),:);
     
    call_count(1,i) = size(cur_calls,1);
    call_duration(1,i) = nansum(cellfun(@(x) str2double(x), cur_calls(:,4)));
end


end