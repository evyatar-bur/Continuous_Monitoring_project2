function [label] = label_classifier(dates)
% label_classifier recieves a cell of dates and returns a label vector
% 
% label is a bolian vector,
% determning for each date if it is a weekday or weekend

label = zeros(size(dates));

for i = 1:length(dates)

    DayNumber = weekday(dates(i));

    if DayNumber >= 6
        label(i) = 1;
    end
end

end