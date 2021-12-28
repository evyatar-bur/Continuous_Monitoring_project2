function [call_count, call_duration] = our_call_features(calls,dates)

call_count=zeros(1,length(dates));
call_duration=call_count;

% incoming = calls(cellfun(@(x) strcmp(x, '1'), calls(:,11)),:);
% outgoing = calls(cellfun(@(x) strcmp(x, '2'), calls(:,11)),:);

for i = 1:length(dates)
    cur_date = dates{i};
    cur_calls=calls(cellfun(@(x) strcmp(x, cur_date), calls(:,1)),:);
    call_count(1,i) = size(cur_calls,1);
    call_duration(1,i) = sum(cellfun(@(x) str2double(x), cur_calls(:,4)));
end

% figure; 
% yyaxis left; plot(datetime(dates),count); xlabel('Date','FontSize',14); ylabel('Total # of calls','FontSize',14) 
% yyaxis right; plot(datetime(dates),duration); ylabel('Total calls time','FontSize',14)
% title(['User : ' filename])
% ax=gca;
% ax.FontSize = 14;

end