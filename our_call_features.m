function [call_count, call_duration] = our_call_features(calls,dates)
%This function calculates relevant features from the call sensor

call_count = zeros(length(dates),1);
call_duration = call_count;

for i = 1:length(dates)

    cur_date = dates{i};
    cur_calls=calls(cellfun(@(x) strcmp(x, cur_date), calls(:,1)),:);
     
    call_count(i,1) = size(cur_calls,1);
    call_duration(i,1) = nansum(cellfun(@(x) str2double(x), cur_calls(:,4)));

    if isnan(call_duration(i,1))
        call_duration(i,1) = 0;
    end
end


end