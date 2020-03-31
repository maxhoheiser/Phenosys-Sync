function ttl_event_1_trials_2 = convertToTrials(ttl_event_1_1)
% copy consequtive whole trials with timestamps

%%
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

%%

ttl_event_1_trials_2 = [];
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
end

ttl_event_1_trials_2(:,1) = 1:size(ttl_event_1_trials_2,1);

for i = 1:length(ttl_event_1_trials_2)
   ttl_event_1_trials_2(i,16) = (ttl_event_1_trials_2(i,8) - ttl_event_1_trials_2(i,2));
end

ttl_event_1_trials_2(:,17) = round(ttl_event_1_trials_2(:,16),0);
ttl_event_1_trials_2 = ttl_event_1_trials_2(~all(ttl_event_1_trials_2 == 0, 2),:);

end