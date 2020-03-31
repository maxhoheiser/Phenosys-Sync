function [excel, excel_trials] = readExcel(directory)

% read excel

%convert time into ms matlab readable

file = convertStringsToChars(strcat(directory,"\behavior\TTLout.xlsx"));

format long g
excel = xlsread(file,'output');

excel_time = datetime(excel(:,1),'convertfrom', 'excel', 'Format', 'HH:mm:ss.SSS');
excel_time_ms = milliseconds(excel_time - excel_time(1));

%convert to miliseconds divverence

excel(:,3) = excel_time_ms(:,1);

%excel(:,4) = excel_time(:,1);


%for i = 1:length(excel)
%     excel(i,3) = round((milliseconds((excel_time(i,1)) - (excel_time((i-1),1)))),0);
% end


excel_trials = [];
for i = 1:length(excel)
    if excel(i,2) == 11 & excel((i-6),2) == 1 & excel((i-5),2) == 2 & excel((i-4),2) == 3;
        len = size(excel_trials,1);
        %copy time stamp from beginning = i-6,1 to position   len+1,1
        excel_trials(len+1,2) = excel((i-6),3);
        excel_trials(len+1,3) = excel((i-5),3);
        excel_trials(len+1,4) = excel((i-4),3);
        excel_trials(len+1,5) = excel((i-3),3);
        excel_trials(len+1,6) = excel((i-2),3);
        excel_trials(len+1,7) = excel((i-1),3);
        excel_trials(len+1,8) = excel(i,3);
        % copy event from excel
        excel_trials(len+1,9) = excel((i-6),2);
        excel_trials(len+1,10) = excel((i-5),2);
        excel_trials(len+1,11) = excel((i-4),2);
        excel_trials(len+1,12) = excel((i-3),2);
        excel_trials(len+1,13) = excel((i-2),2);
        excel_trials(len+1,14) = excel((i-1),2);
        excel_trials(len+1,15) = excel(i,2);
    end
end

excel_trials(:,1) = 1:size(excel_trials,1);


for i = 1:length(excel_trials)
   excel_trials(i,16) = (excel_trials(i,8) - excel_trials(i,2));
end



excel_trials(:,17) = round(excel_trials(:,16),0);
excel_trials = excel_trials(~all(excel_trials == 0, 2),:);



% %%test overlapping length of whle trials
% test(:,1)=excel_trials(:,15);
% 
% test(:,2)=ttl_event_1_trials_2(:,15);
% test = round(test,0);

% 
% for i = 1:length(test)
%     test(i,3) = (test(i,2) - test(i,1));
% end

end