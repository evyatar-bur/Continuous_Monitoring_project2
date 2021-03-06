function [label_features] = label_data(recording,dates)
%This function gets all the data and the dates and extracts features from
%the label files
    label_features = nan*zeros(size(dates,1),11);
    
    % Read label data to cell
    [~,~,data] = xlsread(recording);
    
    % Remove unnecessary nan rows 
    data = data(cellfun('isclass', data(:,1), 'char'),:);

    for i = 1:length(dates)

        cur_date = dates{i};
        cur_data = data(cellfun(@(x) contains(x, cur_date), data(:,1)),:);

        if size(cur_data,1) == 0
            continue
        end
         
        % Sleep time
        label_features(i,1) = cur_data{1,2};

        % Wake up time
        label_features(i,2) = cur_data{1,3};

        % Total sleep time 
        label_features(i,3) = label_features(i,2) + (1-label_features(i,1));

        % Feeling
        label_features(i,4) = cur_data{1,4};

        % Study
        label_features(i,5) = cellfun(@(x) contains(x, 'לימודים'), cur_data(1,5));

        % Sport
        label_features(i,6) = cellfun(@(x) contains(x, 'ספורט'), cur_data(1,5));

        % Family
        label_features(i,7) = cellfun(@(x) contains(x, 'משפחה'), cur_data(1,5));

        % Work
        label_features(i,8) = cellfun(@(x) contains(x, 'עבודה'), cur_data(1,5));

        % Stayed at home
        label_features(i,9) = cellfun(@(x) contains(x, 'נשארתי'), cur_data(1,5));

        % Hangout
        label_features(i,10) = cellfun(@(x) contains(x, 'בילוי')&~contains(x,'מאוחר'), cur_data(1,5));
        
        % Late hangout
        label_features(i,11) = cellfun(@(x) contains(x, 'בילוי מאוחר'), cur_data(1,5));

        

    end
end