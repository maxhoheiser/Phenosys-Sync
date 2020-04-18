% Ch is the channel
clc
clear
fileinfo = dir('electrophysiology/digitalin.dat');
num_samples = fileinfo.bytes/2; % uint16 = 2 bytes -> .bytes reads the number of bytes from a filehehe

fid = fopen('electrophysiology/digitalin.dat', 'r');
digital_word = fread(fid, num_samples, 'uint16');
fclose(fid);

ttl_signal = zeros(length(digital_word),7);
count = zeros(1,7);

%write every ttl signal channel in a column of ttl_signal
for i = [1:7]
    ttl_signal(:,i) = (bitand(digital_word, 2^(i-1)) > 0);
    
     %evaluate the number of changes per ttl input channel
      for j = 1:(length(digital_word)-1)
          if ttl_signal(j,i) ~= ttl_signal(j+1,i) 
              count(i) = count(i) + 1;
          end
      end
      if mod(count(i),2) ~= 0
          count(i) = count(i) + 1;
      end
end
count = count./2;
clear('j','i','num_samples','fid')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%ttl_event_0 = calc(ttl_signal, 0);
ttl_event_1 = calc(ttl_signal, 1);
%ttl_event_2 = calc(ttl_signal, 2);
%ttl_event_3 = calc(ttl_signal, 3);
%ttl_event_4 = calc(ttl_signal, 4);
%ttl_event_5 = calc(ttl_signal, 5);
%ttl_event_6 = calc(ttl_signal, 6);

%convert ttl to ms
for i = 1:length(ttl_event_1)
    ttl_event_1(i,4) = (ttl_event_1(i,1))/20;
end

%ttl_event_1 = responses for behaviour


clear('i', 'len', 'ans');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% convert ttl ms to behaviour response
%write the trial start = 1
% click range 18<= x <= 22
for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3)==1
        if check(ttl_event_1(i,2), 11, 29)
            ttl_event_1(i,5) = 1;
        end
    end
end

%write trial end = 11
for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3)==1
        if check(ttl_event_1(i,2), 215, 245)
            ttl_event_1(i,5) = 11;
        end
    end
end

%write trial open loop = 2ms 
for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3)==1
        if check(ttl_event_1(i,2), 31, 49)
            ttl_event_1(i,5) = 2;
        end
    end
end

%write trial tone start = 3ms 
for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3)==1
        if check(ttl_event_1(i,2), 51, 69)
            ttl_event_1(i,5) = 3;
        end
    end
end

%write response time window start = 4ms 
for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3)==1
        if check(ttl_event_1(i,2), 71, 89)
            ttl_event_1(i,5) = 4;
        end
    end
end

%write no reward = 6ms 
for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3)==1
        if check(ttl_event_1(i,2), 111, 129)
            ttl_event_1(i,5) = 6;
        end
    end
end

%write small reward (180ms valve open) = 7ms 
for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3)==1
        if check(ttl_event_1(i,2), 131, 149)
            ttl_event_1(i,5) = 7;
        end
    end
end

%write right big reward (960ms = valve open) 
for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3)==1
        if check(ttl_event_1(i,2), 91, 110)
            ttl_event_1(i,5) = 5;
        end
    end
end


%write left no reward
for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3)==1
        if check(ttl_event_1(i,2), 151, 169)
            ttl_event_1(i,5) = 8;
        end
    end
end

%write end of reward 10ms
for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3)==1
        if check(ttl_event_1(i,2), 191, 213)
            ttl_event_1(i,5) = 10;
        end
    end
end

count_sepcific_ttl_events = tabulate((ttl_event_1(:,5)));

input = tabulate((ttl_event_1(:,2)));
ttl_event_1_1 = [];

for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3) == 1;
        len = size(ttl_event_1_1,1);
        ttl_event_1_1(len+1,:) = ttl_event_1(i,:);
    end
end
clear ('i', 'input');
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% copy consequtive whole trials with timestamps
ttl_event_1_1 = []
for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3) == 1;
        len = size(ttl_event_1_1,1);
        ttl_event_1_1(len+1,:) = ttl_event_1(i,:);
    end
end

%ttl_event_1_trials structure
%
% start [ms] 1 | start [ms] 2 | start [ms] 3 | start [ms] 4 | start [ms]
% reward | start [ms] reward end | start [ms] trial end |

% ttl_event_1_trials = []
% for i = 1:length(ttl_event_1_1)
%     if ttl_event_1_1(i,5) == 11 & ttl_event_1_1((i-6),5) == 1 & ttl_event_1_1((i-5),5) <= 3 & ttl_event_1_1((i-5),5) >= 2 & ttl_event_1_1((i-4),5) == 3;
%         len = size(ttl_event_1_trials,1);
%         %copy time stamp from beginning = i-6,1 to position   len+1,1
%         ttl_event_1_trials(len+1,1) = ttl_event_1_1((i-6),4);
%         ttl_event_1_trials(len+1,2) = ttl_event_1_1((i-5),4);
%         ttl_event_1_trials(len+1,3) = ttl_event_1_1((i-4),4);
%         ttl_event_1_trials(len+1,4) = ttl_event_1_1((i-3),4);
%         ttl_event_1_trials(len+1,5) = ttl_event_1_1((i-2),4);
%         ttl_event_1_trials(len+1,6) = ttl_event_1_1((i-1),4);
%         ttl_event_1_trials(len+1,7) = ttl_event_1_1(i,4);
%         %copy event from hole event to len+1,8->14
%         ttl_event_1_trials(len+1,8) = ttl_event_1_1((i-6),5);
%         ttl_event_1_trials(len+1,9) = ttl_event_1_1((i-5),5);
%         ttl_event_1_trials(len+1,10) = ttl_event_1_1((i-4),5);
%         ttl_event_1_trials(len+1,11) = ttl_event_1_1((i-3),5);
%         ttl_event_1_trials(len+1,12) = ttl_event_1_1((i-2),5);
%         ttl_event_1_trials(len+1,13) = ttl_event_1_1((i-1),5);
%         ttl_event_1_trials(len+1,14) = ttl_event_1_1(i,5);
%     end
%     clear ('i','len');
% end


ttl_event_1_trials_2 = []
for i = 7:length(ttl_event_1_1)
    if ttl_event_1_1(i,5) == 11;
        len = size(ttl_event_1_trials_2,1);
        %copy time stamp from beginning = i-6,1 to position   len+1,1
        ttl_event_1_trials_2(len+1,2) = ttl_event_1_1((i-6),4);
        ttl_event_1_trials_2(len+1,3) = ttl_event_1_1((i-5),4);
        ttl_event_1_trials_2(len+1,4) = ttl_event_1_1((i-4),4);
        ttl_event_1_trials_2(len+1,5) = ttl_event_1_1((i-3),4);
        ttl_event_1_trials_2(len+1,6) = ttl_event_1_1((i-2),4);
        ttl_event_1_trials_2(len+1,7) = ttl_event_1_1((i-1),4);
        ttl_event_1_trials_2(len+1,8) = ttl_event_1_1(i,4);
        %copy event from hole event to len+1,8->14
        ttl_event_1_trials_2(len+1,9) = ttl_event_1_1((i-6),5);
        ttl_event_1_trials_2(len+1,10) = ttl_event_1_1((i-5),5);
        ttl_event_1_trials_2(len+1,11) = ttl_event_1_1((i-4),5);
        ttl_event_1_trials_2(len+1,12) = ttl_event_1_1((i-3),5);
        ttl_event_1_trials_2(len+1,13) = ttl_event_1_1((i-2),5);
        ttl_event_1_trials_2(len+1,14) = ttl_event_1_1((i-1),5);
        ttl_event_1_trials_2(len+1,15) = ttl_event_1_1(i,5);
    end
    clear ('i','len');
end

ttl_event_1_trials_2(:,1) = 1:size(ttl_event_1_trials_2,1);

for i = 1:length(ttl_event_1_trials_2)
   ttl_event_1_trials_2(i,16) = (ttl_event_1_trials_2(i,8) - ttl_event_1_trials_2(i,2));
   clear('i');
end

ttl_event_1_trials_2(:,17) = round(ttl_event_1_trials_2(:,16),0);
ttl_event_1_trials_2 = ttl_event_1_trials_2(~all(ttl_event_1_trials_2 == 0, 2),:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read excel

%convert time into ms matlab readable
format long g
excel = xlsread('behavior\TTLout.xlsx','output');

excel_time = datetime(excel(:,1),'convertfrom', 'excel', 'Format', 'HH:mm:ss.SSS');
excel_time_ms = milliseconds(excel_time - excel_time(1));

%convert to miliseconds divverence

excel(:,3) = excel_time_ms(:,1);
clear('ecel_time_ms');
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

clear('i','len');

% %%test overlapping length of whle trials
% test(:,1)=excel_trials(:,15);
% 
% test(:,2)=ttl_event_1_trials_2(:,15);
% test = round(test,0);

% 
% for i = 1:length(test)
%     test(i,3) = (test(i,2) - test(i,1));
% end
%% output file
output_name_vec_time = ["trial-num", "time 1" "time 2" "time 3" "time 4" "time reward" "time inter trial in." "time inter trial end"];
output_name_vec_event = ["TIstarts" "IND-CUE_pres_start" "SOUND_start" "resp-time-window_start" "reward" "ITIstarts" "ITIends" "time dif trial" "time dif trial round"];

output_name(1,1) = "Excel"; 
output_name(2,1:8) = output_name_vec_time; 
output_name(2,9:17) = output_name_vec_event; 

output_name(1,18) = "TTL"; 
output_name(2,18:25) = output_name_vec_time; 
output_name(2,26:34) = output_name_vec_event; 

output_name(2,35:36) = ["dif ttl - excel" "diff round"];
output_name(2,37:39) = ["excel start rel" "ttl start rel" "start rel dif"];

output_data = [];
output_data(:,1:17)=excel_trials(:,:);


for i = 1:length(ttl_event_1_trials_2)
    output_data(i,18:34)=ttl_event_1_trials_2(i,:);
end

output_data(:,35)=(output_data(:,33) - output_data(:,16));

output_data(:,36) = round(output_data(:,35),0);

%add time for start of trial for excel & ttl
for i = 1:length(output_data)
    output_data(i,37) = round((output_data(i,2)-output_data(1,2)),0);
end

for i = 1:length(output_data)
    output_data(i,38) = round((output_data(i,19)-output_data(1,19)),0);
end

for i = 1:length(output_data)
    output_data(i,39) = round((output_data(i,38)-output_data(i,37)),0);
end

clear('i');
%% ttl correct

%search for offset between excel trial start & ttl trial start
if(exist ('output_data_ttl') == false)
    output_data_ttl = [];
end

for i = 1:(size(output_data,1)-1)
    if abs(output_data(i,39)) >=30 || abs(output_data(i,36)) > 30
        if abs(output_data(i,37) - output_data(i+1,38)) < 30
            output_data_ttl(end+1,:)=output_data(i,18:34);
            for j = i:(length(output_data)-1)
                output_data(j,18:34) = output_data((j+1),18:34);
                output_data(j,38) = output_data((j+1),38);
            end
            %recalculate relative values
            for k = 1:size(output_data,1)
                output_data(k,35) = (output_data(k,34) - output_data(k,17));
            end
            output_data(:,36) = round(output_data(:,35),0);
            for l = 1:size(output_data,1)
                output_data(l,39) = (output_data(l,38) - output_data(l,37));
            end
        end
        if abs(output_data(i+1,37) - output_data(i,38)) < 30
            for j = (size(output_data,1)+1):-1:(i+1)
                output_data(j,18:34) = output_data((j-1),18:34);
                output_data(j,38) = output_data((j-1),38);
            end
            output_data(i,18:34) = 0;
            output_data(i,38) = 0;
            %recalculate relative values
            for k = 1:size(output_data,1)
                output_data(k,35) = (output_data(k,34) - output_data(k,17));
            end
            output_data(:,36) = round(output_data(:,35),0);
            for l = 1:size(output_data,1)
                output_data(l,39) = (output_data(l,38) - output_data(l,37));
            end
            clear('j', 'k', 'l');
            clear('i');
        end
    end
end
clear('i');

% 
% for i = 1:size(output_data_ttl,1)
%     if sum(output_data_ttl(i,:

%% write to excel
% function to take out line of excel or line of ttl & put into
% output_error_excel or output_error_ttl


%writing everything to files
output_file = [output_name; output_data];

% function to take out line of excel or line of ttl & put into
% output_error_excel or output_error_ttl

output_name_error(1,1:17) = output_file(2,18:34);
%output_name_excel(1,1) = "excel wrong detected trials";
%output_name_excel(2,1:18)= output_name_error;
%output_name_ttl(1,1) = "ttl wrong detected trials";

%output_file_excel = [output_name_error; num2cell(output_data_excel)];
%output_file_ttl = [output_name_error; num2cell(output_data_ttl)];


%write to excel file
filename = 'output_file.xlsx';
writematrix(output_file,filename,'Sheet', 'Daten');
if exist('output_data_ttl')==1
    disp('yes')
    output_file_ttl = [output_name_error; output_data_ttl];
    writematrix(output_file_ttl,filename,'Sheet', 'TTL not in Excel');
end
writematrix(ttl_event_1_1,filename,'Sheet','TTL Signals');
writematrix(excel,filename,'Sheet','Excel Signals');


%% detailed time correlation
ground_truth = [];
%1 = time ms for phenosys clock
ground_truth(:,1) = excel(:,3);
%2 = phenosys behaviour
ground_truth(:,2) = excel(:,2);
%3 = relative to beginning of first event
for i = 2:length(ground_truth)
    ground_truth(i,3) = (ground_truth(i,1) - ground_truth(2,1));
    clear('i');
end


ttl_corrected = [];
% 1 = time in ms
ttl_corrected(:,1) = ttl_event_1(:,4);
% 2 = length of ttl signal
ttl_corrected(:,2) = ttl_event_1(:,3);
% 3 = ttl signal yes / no
ttl_corrected(:,3) = ttl_event_1(:,2);
% 4 = behaviour state
ttl_corrected(:,4) = ttl_event_1(:,5);
% 5 = time start relative to first complete colum
%%%% --> X must me set manually %%%%%
for i = 2:length(ttl_corrected)
    x = ttl_corrected();
    ttl_corrected(i,5) = (ttl_corrected(i,1) - ttl_corrected(2,1));
    clear('i','x');
end
ground_truth(:,4) = 0;
ground_truth_vec = zeros(size(ttl_corrected,1),1);
for j = 1:6
    for k = 1:30
        check_vec=0;
        for i = 1:length(ttl_corrected)
            if test_fit(ttl_corrected(i,5),ground_truth(j,3),k) && ttl_corrected(i,2)==1 && ground_truth(j,4) == 0 && sum(ttl_corrected(i,5)==check_vec)==0
                ground_truth(j,4) = ttl_corrected(i,5);
                ground_truth(j,5) = ttl_corrected(i,4);
                ground_truth(j,6) = ttl_corrected(i,3);
                ground_truth(j,7) = ttl_corrected(i,2);
                ground_truth(j,8) = ttl_corrected(i,1);
                ground_truth_vec(i,1)=1;
            end
        end
    end
end

for j = 7:length(ground_truth)-6
    for k = 1:30
        check_vec=ground_truth((j-6):1:(j+6),4);
        for i = 1:length(ttl_corrected)
            if test_fit(ttl_corrected(i,5),ground_truth(j,3),k) && ttl_corrected(i,2)==1 && ground_truth(j,4) == 0 && sum(ttl_corrected(i,5)==check_vec)==0
                ground_truth(j,4) = ttl_corrected(i,5);
                ground_truth(j,5) = ttl_corrected(i,4);
                ground_truth(j,6) = ttl_corrected(i,3);
                ground_truth(j,7) = ttl_corrected(i,2);
                ground_truth(j,8) = ttl_corrected(i,1);
                ground_truth_vec(i,1)=1;
            end
        end
    end
end

for j = length(ground_truth)-5:length(ground_truth)
    for k = 1:30
        check_vec=ground_truth((j-6):1:(j),4);
        for i = 1:length(ttl_corrected)
            if test_fit(ttl_corrected(i,5),ground_truth(j,3),k) && ttl_corrected(i,2)==1 && ground_truth(j,4) == 0 && sum(ttl_corrected(i,5)==check_vec)==0
                ground_truth(j,4) = ttl_corrected(i,5);
                ground_truth(j,5) = ttl_corrected(i,4);
                ground_truth(j,6) = ttl_corrected(i,3);
                ground_truth(j,7) = ttl_corrected(i,2);
                ground_truth(j,8) = ttl_corrected(i,1);
                ground_truth_vec(i,1)=1;
            end
        end
    end
end
clear('check_vec')
clear('j', 'i', 'k');


% 8 = time diff excel - ttl
for i = 1:length(ground_truth)
    if ground_truth(i,4) ~= 0
        ground_truth(i,9) = round((ground_truth(i,3)-ground_truth(i,4)),1);
    end
end
clear('i');

% 9 = behavior diff excel - ttl
ground_truth(:,10) = ground_truth(:,2)-ground_truth(:,5);

ground_truth(:,11) = 1:length(ground_truth);

output_name_5 = ["excel-time", "excel-behavior", "excel-tim-rel", "ttl-time-rel", "ttl-behavior", "ttl-dur", "ttl-0/1","ttl-time-true", "time-diff", "behavior-dif", "num"];
output_file_ground_truth = [output_name_5; ground_truth];
filename = 'output_file.xlsx';
writematrix(output_file_ground_truth,filename,'Sheet', 'Details');
%% sync hole trials 
ground_truth_trial = [];

for i=7:size(ground_truth,1)
    if ground_truth(i,2)==11
        len = size(ground_truth_trial,1);
        ground_truth_trial(len+1:len+7,:)=ground_truth((i-6):i,:);
    end
end

c = 0;
for i = 1:size(ground_truth_trial)
    if ground_truth_trial(i,2)==11
        c=c+1;
        ground_truth_trial(i,13) = (ground_truth_trial(i,3)-ground_truth_trial(i-6,3));
        ground_truth_trial(i,14) = (ground_truth_trial(i,4)-ground_truth_trial(i-6,4));
        ground_truth_trial(i:-1:i-6,12) = c;
    end
end
clear('c','i');

ground_truth_trial(:,15)=ground_truth_trial(:,13)-ground_truth_trial(:,14);

output_name_6 = ["excel-time", "excel-behavior", "excel-tim-rel", "ttl-time-rel", "ttl-behavior", "ttl-dur", "ttl-0/1","ttl-time-true", "time-diff", "behavior-dif", "num", "trial num", "trial length excel", "trial length ttl", "length difference"];
output_file_ground_truth = [output_name_6; ground_truth_trial];
filename = 'output_file.xlsx';
writematrix(output_file_ground_truth,filename,'Sheet', 'Details_Trials');
%% compare 2 methods times
for i = 1:size(output_data_ttl,1)
    col = size(output_data_ttl,1);
    for j = 2:8
        if sum(output_data_ttl(i,j)==ground_truth(:,4))~=0
            output_data_ttl(col,j)=1;
        end
    end
    clear('col','i','j');
end
compare_2_methods=[];
for i = 1:size(output_data,1)
    col = size(compare_2_methods,1);
    compare_2_methods((col+1):(col+7),1)=(output_data(i,1));
    compare_2_methods((col+1):(col+7),2)=(output_data(i,2:8))';
    compare_2_methods((col+1):(col+7),4)=(output_data(i,9:15))';
    compare_2_methods((col+1):(col+7),6)=(output_data(i,18));
    compare_2_methods((col+1):(col+7),7)=(output_data(i,19:25))';
    compare_2_methods((col+1):(col+7),9)=(output_data(i,26:32))';
end

compare_2_methods = compare_2_methods(~all(compare_2_methods == 0, 2),:);

for i = 1:size(compare_2_methods,1)
    compare_2_methods(i,3)=(compare_2_methods(i,2)-compare_2_methods(1,2));
    compare_2_methods(i,8)=(compare_2_methods(i,7)-compare_2_methods(1,7));
end  

for i = 1:size(compare_2_methods,1)
    if sum(compare_2_methods(i,3)==ground_truth(:,3))~=0
        compare_2_methods(i,5)=1;
    end
    if sum(compare_2_methods(i,8)==ground_truth(:,4))~=0
        compare_2_methods(i,10)=1;
    end
end

for i = 1:size(compare_2_methods,1)
    compare_2_methods(i,12) = (compare_2_methods(i,8)-compare_2_methods(i,3));
end

for i = 1:size(compare_2_methods,1)
    compare_2_methods(i,13) = (compare_2_methods(i,9)-compare_2_methods(i,4));
end

output_name_3(1,1)=["excel"];
output_name_3(1,6)=["ttl"];
output_name_3(2,1:10)=["trial-num","time","time-corr","behavior","time_in_ground_truth","trial-num","time","time-corr","behavior","time_in_ground_truth","diff time excel - ttl", "behavior diff excel - ttl"];
output_file_3 = [output_name_3; compare_2_methods];
filename = 'output_file.xlsx';
writematrix(output_file_3,filename,'Sheet', 'compare_2_methods');




%% find not in excel
find_not_in_excel=[];
for i = 1:size(output_data_ttl,1)
    col = size(find_not_in_excel,1);
    find_not_in_excel((col+1):(col+7),1)=(output_data_ttl(i,1));
    find_not_in_excel((col+1):(col+7),2)=(output_data_ttl(i,2:8))';
    find_not_in_excel((col+1):(col+7),4)=(output_data_ttl(i,9:15))';
end

find_not_in_excel = find_not_in_excel(~all(find_not_in_excel == 0, 2),:);

for i = 1:size(find_not_in_excel,1)
    find_not_in_excel(i,3)=(find_not_in_excel(i,2)-find_not_in_excel(1,2));
end

for i = 1:size(find_not_in_excel,1)
    if sum(find_not_in_excel(i,3)==ground_truth(:,4))~=0
        find_not_in_excel(i,5)=1;
    end
end

output_name_4(1,1)=["ttl"];
output_name_4(2,1:5)=["trial-num","time","time-corr","behavior","time_in_ground_truth"];
output_file_4 = [output_name_4; find_not_in_excel];
filename = 'output_file.xlsx';
writematrix(output_file_4,filename,'Sheet', 'find_not_in_excel');

%% plotting
folder = 'figures/alignment/'

if ~exist('figures', 'dir')
    mkdir('figures')
end
if ~exist('figures/alignment', 'dir')
    mkdir('figures/alignment')
end

% histogram for diviation of behavior phenosys vs ttl for ground truth
for i = 1:11
    vec = ground_truth(ground_truth(:,2)==i,:); 
    h = histogram(vec(:,10));
    title('Time Difference Trial Start (Phenosis - TTL');
    xlabel('Event Number'); 
    ylabel('Difference in [ms]'); 
    x = h.BinEdges ;
    y = h.Values ;
    p = round((y.*100)/sum(y),2);
    yt=y';
    pt=p';
    str = strcat(num2str(yt),num2str(pt),{'%'});
    text(x(1:end-1),y,str,'vert','bottom'); 
    box off;
    drawnow;
    
    string = 'Ground Tuth - Diviation Behavior_';
    name = strcat(folder,string,num2str(i));
    saveas(gcf,name,'png');
    clear('fig','name','vec','string');
end

% scatterplot of time difference for event start phenosys vs ttl
scatter(ground_truth_trial(:,11),ground_truth_trial(:,9),'.')
title('Time Difference Trial Start (Phenosis - TTL')
xlabel('Event Number') 
ylabel('Difference in [ms]') 
string = 'Ground Tuth - Diviation Time of Event';
name = strcat(folder,string);
saveas(gcf,name,'png');


% histogram trial length diviation
vec = ground_truth_trial(ground_truth_trial(:,13)~=0,[12 15]);
vec2 = vec(abs(vec(:,2))<2,:);
h = histogram(vec2(:,2));
x = h.BinEdges ;
y = h.Values ;
p = round((y.*100)/sum(y),2);
p = p(1,p(1,:)~=0);
str = strcat(num2str(pt),{'%'});
text(x(1:end-1),y,str,'FontSize',8,'vert','bottom');
box off;
drawnow;
title('Trial Length Difference (Phenosis - TTL')
xlabel('Difference in [ms]') 
string = 'Ground Tuth - Diviation Length of Trial - Histogram';
name = strcat(folder,string);
saveas(gcf,name,'png');


% scatterplot trial and trial length diviation
vec = ground_truth_trial(ground_truth_trial(:,13)~=0,[12 15]);
vec2 = vec(abs(vec(:,2))<2,:);
scatter(vec2(:,1),vec2(:,2),'.');
yline(0)
title('Trial Length Difference (Phenosis - TTL')
xlabel('Trial Number') 
ylabel('Difference in [ms]') 
string = 'Ground Tuth - Diviation Length of Trial';
name = strcat(folder,string);
saveas(gcf,name,'png');

% scatterplot trial and trial length


%% Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function to analyze ttl signal channel
function [test_2] = calc(test, i)
%output = array 
%---ttl count start | ttl count durration | 0 or 1 | ms time durration--
% test = ttl_signal
% i = ttl channel

%table which length off tll is which state



test_2 = [];
count = 0;
i = i + 1;
for j = 1:(length(test)-1)
    if test(j,i) == test(j+1,i)
        count = count +1;
    elseif test(j,i) ~= test(j+1,i)
        count = count +1;
        len = size(test_2,1);
        test_2((len+1),3) = test(j,i);
        test_2((len+1),2) = count;
        test_2((len+1),1) = j - count;
        count = 0;
    end
end

if test(length(test),i) == test(length(test)-1,i)
    count = count +1;
    len = size(test_2,1);
    test_2((len+1),3) = test(length(test),i);
    test_2((len+1),2) = count;
    test_2((len+1),1) = length(test) - count;
    count = 0;    
end

if test(length(test),i) ~= test(length(test)-1,i)
    count = 1;
    len = size(test_2,1);
    test_2((len+1),3) = test(length(test),i);
    test_2((len+1),2) = count;
    test_2((len+1),1) = length(test) - count;
    count = 0;
end

for i = 1:length(test_2)
    test_2(i,4) = (test_2(i,1)/20);
end

clear ('j', 'i', 'len', 'count')


end

%function to compare if number is in ragen
function [match_bul] = check(x,lo,hi)
%returns bulean value if x is within range lo <= x <= hi
    match_bul = (x>=lo) & (x<=hi);
end

function [match_bul_2]=test_fit(comp, base,diff)
% find time overlap returns overlap
    hi = diff;
        
    if comp < base
        match_bul_2 = ((base-comp)<=hi);
    elseif comp >= base
        match_bul_2 = ((comp-base)<=hi);
    end
end

%substract a line from excel if too much
function excel_substract()
    output_data_excel = [];
    correction_vec = [];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%if wrong in excel
    %%%
    wrong = XXX;
    x = wrong - 2;
    output_data_excel((length(output_data_excel)+1),1) = x;
    output_data_excel((length(output_data_excel)+1),2:17) = output_data(x,1:16);

    for i = x:(length(output_data)-1);
        output_data(i,1:16) = output_data((i+1),1:16);
        output_data(i,35) = output_data((i+1),35);
    end
    output_data(length(ouptut_data),1:16) = 0;
    output_data(length(output_data),35) = 0;
    correction_vec(end+1,1)=wrong;
    correction_vec(end,2)=1
    clear 'wrong' 'x';
end

%add a line from ttl if not detected
function ttl_add(wrong)
    x = wrong;
    output_data_ttl((end+1),1:17) = output_data(x,18:34);

    for i = (size(output_data,1)+1):-1:x
        output_data(i,18:34) = output_data((i-1),18:34);
        output_data(i,38) = output_data((i-1),38);
    end
    output_data(x,18:34) = 0;
    output_data(x,38) = 0;
    
    %recalculate relative values
    for i = 1:length(output_data)
        output_data(i,35) = (output_data(i,34) - output_data(i,17));
    end
    output_data(:,36) = round(output_data(:,35),0);
    
    for i = 1:length(output_data)
        output_data(i,39) = (output_data(i,38) - output_data(i,37));
    end
end

%remove a line from excel wrong detected
function ttl_substract()
    % %% missing ttl trials
    % % 74, 96, 144, 207, 214, 262, y,y 
    wrong = 276
    x = wrong - 1;
    for i = (length(output_data)+1):-1:x;
            output_data(i,17:32) = output_data((i-1),17:32);
            output_data(i,36) = output_data((i-1),36);
    end
    correction_vec(end+1,1)=wrong;
    correction_vec(end,2)=3
end

%wheel movement function
function [Final_Position,Overall_Movement]=Read_Wheel_Movement(TTL1,TTL2)
%This function is using the ttls recorded from a rotary encoder and
%translating them to the actual degrees of movement. This particular script
%is done for the specific rotary encoder used in Jian's recording with the
%Phenosys virtual environment.
%%%%%%%%%%%%% Inputs
% TTL1 = From the pin A of the rotor encoder // digital_input_3 from the
%        digitalin.dat

% TTL2 = From the pin B of the rotor encoder // digital_input_3 from the
%        digitalin.dat

%%%%%%%%%%%%% Outputs
% Final_Position = The final angle (positive is Clock wise) on which the
%                  wheel stopped, relative to the initial accounted as 0

% Overall_Movement = All the registered positions after a movement. It is
%                    NOT the movement sample by sample, but just when the 
%                    animal moves

%% Variable initialisation
enconderCPR = 1024; % Encoder resolution
Position = 0; % Relative start position

%% Position decoding
%%%%%%%%%%% Detecting positive changes
A=diff(TTL1);
IndexA=find(A==1)+1;
%%%%%%%%%%%
count = 1;
for i = IndexA'
    if TTL2(i) == 0  % Checking the value of the pin B when there is movement in A
        Position = Position + 360/enconderCPR;
        
    else
        Position = Position - 360/enconderCPR;
        
    end
    Overall_Movement(count)=Position;
    count = count + 1;
end
Final_Position=Position;



end