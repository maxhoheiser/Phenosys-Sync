function  writeFiles(directory,filename,vargin)
% DIRECTORY = 'C:\....\'
% FILENAME = 'name.xlsx'
% vargin can be eather one of the elements of the string or multiple ones
% vargin = [output_data, output_data_ttl, ttl_event_1_1, excel,
% ground_truth, ground_truth_trial, compare_2_methods, find_not_in_excel]




dir_chr = convertStringsToChars(strcat(directory,filename));

%% output names
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



%% write to excel

if sum(output_data==vargin)~=0
    output_file = [output_name; output_data];
    writematrix(output_file,dir_chr,'Sheet', 'Daten');
    
end

if  sum(output_data_ttl==vargin)~=0
    output_name_error(1,1:17) = output_file(2,18:34);
    if exist('output_data_ttl')==1
        disp('yes');
        output_file_ttl = [output_name_error; output_data_ttl];
        writematrix(output_file_ttl,dir_chr,'Sheet', 'TTL not in Excel');
    end
end

if  sum(ttl_event_1_1==vargin)~=0
    writematrix(ttl_event_1_1,dir_chr,'Sheet','TTL Signals');
end

if sum(excel==vargin)~=0
    writematrix(excel,dir_chr,'Sheet','Excel Signals');
end

%% write ground truth

if sum(ground_truth==vargin)~=0
    output_name_5 = ["excel-time", "excel-behavior", "excel-tim-rel", "ttl-time-rel", "ttl-behavior", "ttl-dur", "ttl-0/1","ttl-time-true", "time-diff", "behavior-dif", "num"];
    output_file_ground_truth = [output_name_5; ground_truth];
    writematrix(output_file_ground_truth,dir_chr,'Sheet', 'Details');
end

%% write ground truth trials

if sum(ground_truth_trial==vargin)~=0
    ground_truth_trial(:,15)=ground_truth_trial(:,13)-ground_truth_trial(:,14);
    
    output_name_6 = ["excel-time", "excel-behavior", "excel-tim-rel", "ttl-time-rel", "ttl-behavior", "ttl-dur", "ttl-0/1","ttl-time-true", "time-diff", "behavior-dif", "num", "trial num", "trial length excel", "trial length ttl", "length difference"];
    output_file_ground_truth = [output_name_6; ground_truth_trial];
    writematrix(output_file_ground_truth,dir_chr,'Sheet', 'Details_Trials');
end

%% compare 2 methods

if sum(compare_2_methods==vargin)~=0
    output_name_3(1,1)=["excel"];
    output_name_3(1,6)=["ttl"];
    output_name_3(2,1:14)=["trial-num","time","time-corr","behavior","time_in_ground_truth","trial-num","time","time-corr","behavior","time_in_ground_truth","diff time excel - ttl", "behavior diff excel - ttl", "event number", "event time differene excel - ttl"];
    output_file_compare_2_methods = [output_name_3; compare_2_methods];
    writematrix(output_file_compare_2_methods,dir_chr,'Sheet', 'compare_2_methods');
end

%% compare 2 methods find not in excel

if sum(find_not_in_excel==vargin)~=0
    output_name_4(1,1)=["ttl"];
    output_name_4(2,1:5)=["trial-num","time","time-corr","behavior","time_in_ground_truth"];
    output_file_find_not_in_excel = [output_name_4; find_not_in_excel];
    writematrix(output_file_find_not_in_excel,dir_chr,'Sheet', 'find_not_in_excel');
end

end