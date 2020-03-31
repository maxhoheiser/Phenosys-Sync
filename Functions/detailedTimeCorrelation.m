function [ground_truth, ground_truth_trial] = detailedTimeCorrelation(excel,ttl_event_1)

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
ttl_corrected(:,6) = ttl_event_1(:,1);
% 5 = time start relative to first complete colum
%%%% --> X must me set manually %%%%%
for i = 2:length(ttl_corrected)
    ttl_corrected(i,5) = (ttl_corrected(i,1) - ttl_corrected(2,1));
    clear('i','x');
end


ground_truth(2,4) = ttl_corrected(2,5);
ground_truth(2,5) = ttl_corrected(2,4);
ground_truth(2,6) = ttl_corrected(2,3);
ground_truth(2,7) = ttl_corrected(2,2);
ground_truth(2,8) = ttl_corrected(2,1);
ground_truth(2,12) = ttl_corrected(2,6);

ground_truth(:,4) = 0;
ground_truth_vec = zeros(size(ttl_corrected,1),1);
for j = 1:6
    for k = 1:40
        check_vec=0;
        for i = 1:length(ttl_corrected)
            if test_fit(ttl_corrected(i,5),ground_truth(j,3),k) && ttl_corrected(i,2)==1 && ground_truth(j,4) == 0 && sum(ttl_corrected(i,5)==check_vec)==0
                ground_truth(j,4) = ttl_corrected(i,5);
                ground_truth(j,5) = ttl_corrected(i,4);
                ground_truth(j,6) = ttl_corrected(i,3);
                ground_truth(j,7) = ttl_corrected(i,2);
                ground_truth(j,8) = ttl_corrected(i,1);
                ground_truth(j,12) = ttl_corrected(i,6);                
                ground_truth_vec(i,1)=1;
            end
        end
    end
end

for j = 7:length(ground_truth)-6
    for k = 1:40
        check_vec=ground_truth((j-6):1:(j+6),4);
        for i = 1:length(ttl_corrected)
            if test_fit(ttl_corrected(i,5),ground_truth(j,3),k) && ttl_corrected(i,2)==1 && ground_truth(j,4) == 0 && sum(ttl_corrected(i,5)==check_vec)==0
                ground_truth(j,4) = ttl_corrected(i,5);
                ground_truth(j,5) = ttl_corrected(i,4);
                ground_truth(j,6) = ttl_corrected(i,3);
                ground_truth(j,7) = ttl_corrected(i,2);
                ground_truth(j,8) = ttl_corrected(i,1);
                ground_truth(j,12) = ttl_corrected(i,6); 
                ground_truth_vec(i,1)=1;
            end
        end
    end
end

for j = length(ground_truth)-5:length(ground_truth)
    for k = 1:40
        check_vec=ground_truth((j-6):1:(j),4);
        for i = 1:length(ttl_corrected)
            if test_fit(ttl_corrected(i,5),ground_truth(j,3),k) && ttl_corrected(i,2)==1 && ground_truth(j,4) == 0 && sum(ttl_corrected(i,5)==check_vec)==0
                ground_truth(j,4) = ttl_corrected(i,5);
                ground_truth(j,5) = ttl_corrected(i,4);
                ground_truth(j,6) = ttl_corrected(i,3);
                ground_truth(j,7) = ttl_corrected(i,2);
                ground_truth(j,8) = ttl_corrected(i,1);
                ground_truth(j,12) = ttl_corrected(i,6);
                ground_truth_vec(i,1)=1;
            end
        end
    end
end



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





end