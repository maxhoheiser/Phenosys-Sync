function [output_data, output_data_ttl] = correctMisAlignment(excel_trials,ttl_event_1_trials_2)

%% create output data array
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

%% correct misalignment

%search for offset between excel trial start & ttl trial start
if(exist ('output_data_ttl') == false)
    output_data_ttl = [];
end

for i = 1:(size(output_data,1)-1)
    if abs(output_data(i,39)) >=50 || abs(output_data(i,36)) > 50
        if abs(output_data(i,37) - output_data(i+1,38)) < 50
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
        if abs(output_data(i+1,37) - output_data(i,38)) < 50
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
        end
    end
end

% 
% for i = 1:size(output_data_ttl,1)
%     if sum(output_data_ttl(i,:

end