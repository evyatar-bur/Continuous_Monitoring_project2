function [best_feature_list,best_score] = Add_feature(X_training,Y_training,best_feature_list,best_score,metric,model_type)
% This function checks which feature needs to be added to get the best F1
% score and returns the features list and the best scores

rng('default')

border = round(0.7*size(X_training,1));

X_train = X_training(1:border,:);
X_val = X_training(border+1:end,:);

Y_train = Y_training(1:border);
Y_val = Y_training(border+1:end);

prev_best_score = best_score;
best_score = 0;

% Iterate through features to find best one to add 
for i = 1:size(X_train,2)

    if ismember(i,best_feature_list)
        continue
    end
    
    % Use best features, along with feature i
    train_data = X_train(:,[best_feature_list i]);
    val_data = X_val(:,[best_feature_list i]);
    
    % Train model
    t = templateTree('MaxNumSplits',10);

    model=fitcensemble(train_data,Y_train,'method',model_type,'NumLearningCycles',100,'Learners',t);
    
    % Predict scores
    [prediction,scores] = predict(model,val_data);
    
    if strcmp(metric,'ROC')
        % Compute AUC - ROC
        [~,~,~,score] = perfcurve(Y_val,scores(:,1),0);

    elseif strcmp(metric,'PRC')
        % Compute AUC - PRC
        [~,~,~,score] = perfcurve(Y_val,scores(:,1),0,'XCrit','tpr','YCrit','ppv');

    elseif strcmp(metric,'F1')

        score = F1_score(prediction,Y_val);

    else
        disp("Unknown metric - choose 'ROC','F1 or 'PRC' ")

    end

    % Save index of the feature that improves AUC the best
    if score > best_score
        
        best_score = score;
        best_feature_ind = i;

    end
end

best_feature_list(end+1) = best_feature_ind;
end