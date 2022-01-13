function [score] = F1_score(prediction,Y_val)
% Compute weighted F1 score

% Compute f1 score for 0 class
tp_0 = sum((prediction == 0) & (Y_val == 0));
fp_0 = sum((prediction == 0) & (Y_val ~= 0));
fn_0 = sum((prediction ~= 0) & (Y_val == 0));

precision_0 = tp_0 / (tp_0 + fp_0);
recall_0 = tp_0 / (tp_0 + fn_0);
score_0 = (2 * precision_0 * recall_0) / (precision_0 + recall_0);

% Compute f1 score for 1 class
tp_1 = sum((prediction == 1) & (Y_val == 1));
fp_1 = sum((prediction == 1) & (Y_val ~= 1));
fn_1 = sum((prediction ~= 1) & (Y_val == 1));

precision_1 = tp_1 / (tp_1 + fp_1);
recall_1 = tp_1 / (tp_1 + fn_1);
score_1 = (2 * precision_1 * recall_1) / (precision_1 + recall_1);


% Compute weighted score
score = 0.3*score_0 + 0.7*score_1;
end