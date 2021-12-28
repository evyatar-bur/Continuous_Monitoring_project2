function [Time,Sleep, WakeUp,Feeling,Activities] = label_data(recording)
    
    % Read label data to cell
    [~,~,data] = xlsread(recording);
   
    if strcmp(recording,'340.label.xlsx')
    data = data(1:50,:);
    end
   
     
    Time=data(2:end,1);
    Sleep=data(2:end,2);
    WakeUp=data(2:end,3);
    Feeling=data(2:end,4);
    Activities=data(2:end,5);

end