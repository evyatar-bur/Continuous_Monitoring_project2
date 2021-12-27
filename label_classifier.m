function [label] = label_classifier(dates)


label = zeros(size(dates));

for i = 1:length(dates)

    DayNumber = weekday(dates(i));

    if DayNumber >= 6
        label(i) = 1;
    end
end

end