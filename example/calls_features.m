function [dates, count, duration] = calls_features(filename)

[num, txt, raw]=xlsread(filename);
dates = unique(raw(2:end,5));
raw(2:end,6) = erase(raw(2:end,6),'0 days ');

idx_calls = cellfun(@(x) strcmp(x, 'calls'), raw(2:end,7));
raw = raw(2:end,:);
calls = raw(idx_calls,:);

count=zeros(1,length(dates));
duration=count;
% incoming = calls(cellfun(@(x) strcmp(x, '1'), calls(:,11)),:);
% outgoing = calls(cellfun(@(x) strcmp(x, '2'), calls(:,11)),:);

for i = 1:length(dates)
    cur_date = dates{i};
    cur_calls=calls(cellfun(@(x) strcmp(x, cur_date), calls(:,5)),:);
    count(1,i) = size(cur_calls,1);
    duration(1,i) = sum(cellfun(@(x) str2double(x), cur_calls(:,9)));
end

figure; 
yyaxis left; plot(datetime(dates),count); xlabel('Date','FontSize',14); ylabel('Total # of calls','FontSize',14) 
yyaxis right; plot(datetime(dates),duration); ylabel('Total calls time','FontSize',14)
title(['User : ' filename])
ax=gca;
ax.FontSize = 14;

end

