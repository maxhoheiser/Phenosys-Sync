% Ch is the channel

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

ttl_event_1_1 = [];

for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3) == 1;
        len = size(ttl_event_1_1,1);
        ttl_event_1_1(len+1,:) = ttl_event_1(i,:);
    end
end
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
        ttl_event_1_trials_2(len+1,1) = ttl_event_1_1((i-6),4);
        ttl_event_1_trials_2(len+1,2) = ttl_event_1_1((i-5),4);
        ttl_event_1_trials_2(len+1,3) = ttl_event_1_1((i-4),4);
        ttl_event_1_trials_2(len+1,4) = ttl_event_1_1((i-3),4);
        ttl_event_1_trials_2(len+1,5) = ttl_event_1_1((i-2),4);
        ttl_event_1_trials_2(len+1,6) = ttl_event_1_1((i-1),4);
        ttl_event_1_trials_2(len+1,7) = ttl_event_1_1(i,4);
        %copy event from hole event to len+1,8->14
        ttl_event_1_trials_2(len+1,8) = ttl_event_1_1((i-6),5);
        ttl_event_1_trials_2(len+1,9) = ttl_event_1_1((i-5),5);
        ttl_event_1_trials_2(len+1,10) = ttl_event_1_1((i-4),5);
        ttl_event_1_trials_2(len+1,11) = ttl_event_1_1((i-3),5);
        ttl_event_1_trials_2(len+1,12) = ttl_event_1_1((i-2),5);
        ttl_event_1_trials_2(len+1,13) = ttl_event_1_1((i-1),5);
        ttl_event_1_trials_2(len+1,14) = ttl_event_1_1(i,5);
    end
    clear ('i','len');
end

for i = 1:length(ttl_event_1_trials_2)
   ttl_event_1_trials_2(i,15) = (ttl_event_1_trials_2(i,7) - ttl_event_1_trials_2(i,1));
   clear('i');
end

ttl_event_1_trials_2(:,16) = round(ttl_event_1_trials_2(:,15),0);


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
        excel_trials(len+1,1) = excel((i-6),3);
        excel_trials(len+1,2) = excel((i-5),3);
        excel_trials(len+1,3) = excel((i-4),3);
        excel_trials(len+1,4) = excel((i-3),3);
        excel_trials(len+1,5) = excel((i-2),3);
        excel_trials(len+1,6) = excel((i-1),3);
        excel_trials(len+1,7) = excel(i,3);
        % copy event from excel
        excel_trials(len+1,8) = excel((i-6),2);
        excel_trials(len+1,9) = excel((i-5),2);
        excel_trials(len+1,10) = excel((i-4),2);
        excel_trials(len+1,11) = excel((i-3),2);
        excel_trials(len+1,12) = excel((i-2),2);
        excel_trials(len+1,13) = excel((i-1),2);
        excel_trials(len+1,14) = excel(i,2);
    end
end

for i = 1:length(excel_trials)
   excel_trials(i,15) = (excel_trials(i,7) - excel_trials(i,1));
end



excel_trials(:,16) = round(excel_trials(:,15),0);

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
output_name_vec_time = ["time 1" "time 2" "time 3" "time 4" "time reward" "time inter trial in." "time inter trial end"];
output_name_vec_event = ["TIstarts" "IND-CUE_pres_start" "SOUND_start" "resp-time-window_start" "reward" "ITIstarts" "ITIends" "time dif trial" "time dif trial round"];

output_name(1,1) = "Excel"; 
output_name(2,1:7) = output_name_vec_time; 
output_name(2,8:16) = output_name_vec_event; 

output_name(1,17) = "TTL"; 
output_name(2,17:23) = output_name_vec_time; 
output_name(2,24:32) = output_name_vec_event; 

output_name(2,33:34) = ["dif ttl - excel" "diff round"];
output_name(2,35:37) = ["excel start rel" "ttl start rel" "start rel dif"];

output_data = [];
output_data(:,1:16)=excel_trials(:,:);
output_data(360:362,:) = 0;

for i = 1:length(ttl_event_1_trials_2)
    output_data(i,17:32)=ttl_event_1_trials_2(i,:);
end

output_data(:,33)=(output_data(:,31) - output_data(:,15));

output_data(:,34) = round(output_data(:,33),0);

%add time for start of trial for excel & ttl
for i = 1:length(output_data)
    output_data(i,35) = round((output_data(i,1)-output_data(1,1)),0);
end

for i = 1:length(output_data)
    output_data(i,36) = round((output_data(i,17)-output_data(1,17)),0);
end

for i = 1:length(output_data)
    output_data(i,37) = round((output_data(i,36)-output_data(i,35)),0);
end


%% excel
% output_data_excel = [];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%if wrong in excel
% %%%
% wrong = XXX;
% x = wrong - 2;
% output_data_excel((length(output_data_excel)+1),1) = x;
% output_data_excel((length(output_data_excel)+1),2:17) = output_data(x,1:16);
% 
% for i = x:(length(output_data)-1);
%     output_data(i,1:16) = output_data((i+1),1:16);
%     output_data(i,35) = output_data((i+1),35);
% end
% output_data(length(ouptut_data),1:16) = 0;
% output_data(length(output_data),35) = 0;
% 
% clear 'wrong' 'x';
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%% ttl add
% %output_data_ttl = [];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%if wrong in ttl
% %%% 82 85 88
for w = [211]
    wrong = w;
    x = wrong - 2;
    l = (length(output_data_ttl) + 1);
    output_data_ttl(l,1) = (x+2);
    output_data_ttl(l,2:17) = output_data(x,1:16);

    for i = x:(length(output_data)-1);
        output_data(i,17:32) = output_data((i+1),17:32);
        output_data(i,36) = output_data((i+1),36);
    end
    output_data(length(output_data),17:32) = 0;
    output_data(length(output_data),36) = 0;
end
clear 'wrong' 'x' 'l';
%% ttl substract
% 
% %% missing ttl trials
% % 74, 96, 144, 207, 214, 262, y,y 
wrong = 276
x = wrong - 1;
for i = (length(output_data)+1):-1:x;
        output_data(i,17:32) = output_data((i-1),17:32);
        output_data(i,36) = output_data((i-1),36);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% write to excel
% function to take out line of excel or line of ttl & put into
% output_error_excel or output_error_ttl





%recalculate relative values
for i = 1:length(output_data)
    output_data(i,33) = (output_data(i,32) - output_data(i,16));
end
output_data(:,34) = round(output_data(:,33),0);

for i = 1:length(output_data)
    output_data(i,37) = (output_data(i,36) - output_data(i,35));
end




%writing everything to files
output_file = [output_name; num2cell(output_data)];

% function to take out line of excel or line of ttl & put into
% output_error_excel or output_error_ttl

output_name_error(1,1) = "ex position";
output_name_error(1,2:8) = output_name_vec_time;
output_name_error(1,9:17) = output_name_vec_event;
output_name_excel(1,1) = "excel wrong detected trials";
output_name_excel(2,1:17)= output_name_error;
output_name_ttl(1,1) = "ttl wrong detected trials";

%output_file_excel = [output_name_error; num2cell(output_data_excel)];
%output_file_ttl = [output_name_error; num2cell(output_data_ttl)];


%write to excel file
filename = 'output_file.xlsx';
writematrix(output_file,filename,'Sheet', 'Daten');
%writematrix(output_file_excel,filename,'Sheet', 'Error Excel');
%writematrix(output_file_ttl,filename,'Sheet', 'Error TTL');
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

% find where ttl time fits to excel time with ttl -> signal
% ground_truth
    % 4 = ttl time fit
    % 5 = ttl behavior
    % 6 = ttl ttl length
    % 7 = ttl 1 or 0
ground_truth(:,4) = 0;
for k = 1:20
    %k
    for j = 1:length(ground_truth)
        %j
        for i = 1:length(ttl_corrected)
            %i
            if test_fit(ttl_corrected(i,5),ground_truth(j,3),k) & ttl_corrected(i,2)==1 & ground_truth(j,4) == 0
                ground_truth(j,4) = ttl_corrected(i,5);
                ground_truth(j,5) = ttl_corrected(i,4);
                ground_truth(j,6) = ttl_corrected(i,3);
                ground_truth(j,7) = ttl_corrected(i,2);
            end
        end
    end
end

% find where ttl time fits to excel time with ttl -> no-signal (0)
for k = 1:20
    %k
    for j = 1:length(ground_truth)
        %j
        for i = 1:length(ttl_corrected)
            %i
            if test_fit(ttl_corrected(i,5),ground_truth(j,3),k) & ttl_corrected(i,2)==0 & ground_truth(j,4) == 0
                ground_truth(j,4) = ttl_corrected(i,5);
                ground_truth(j,5) = ttl_corrected(i,4);
                ground_truth(j,6) = ttl_corrected(i,3);
                ground_truth(j,7) = ttl_corrected(i,2);
            end
        end
    end
end

% 8 = time diff excel - ttl
for i = 1:length(ground_truth)
    if ground_truth(i,4) ~= 0
        ground_truth(i,8) = round((ground_truth(i,3)-ground_truth(i,4)),1);
    end
end
% 9 = behavior diff excel - ttl
ground_truth(:,9) = ground_truth(:,2)-ground_truth(:,5);

ground_truth(:,10) = 1:length(ground_truth);

output_name = ["excel-time", "excel-behavior", "excel-tim-rel", "ttl-time-rel", "ttl-behavior", "ttl-dur", "ttl-0/1", "time-diff", "behavior-dif", "num"];
output_file = [output_name; num2cell(ground_truth)];
filename = 'output_file.xlsx';
writematrix(output_file,filename,'Sheet', 'Details');
    


%% Functions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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



function [match_bul]=test_fit(comp, base,diff)
% find time overlap returns overlap
    hi = diff;
        
    if comp < base
        match_bul = ((base-comp)<=hi);
    elseif comp >= base
        match_bul = ((comp-base)<=hi);
    end
end


%convert ttl count into milli seconds
% 2*10^4 counts per second -> 1 count = 0.5 ms