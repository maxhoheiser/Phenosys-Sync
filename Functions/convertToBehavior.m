function [ttl_event_1, ttl_event_1_1] = convertToBehavior(ttl_event_1)

% convert ttl ms to behaviour response
% write the trial start = 1

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


ttl_event_1_1 = [];

for i = 1:length(ttl_event_1)
    if ttl_event_1(i,3) == 1;
        len = size(ttl_event_1_1,1);
        ttl_event_1_1(len+1,:) = ttl_event_1(i,:);
    end
end

count_sepcific_ttl_events = tabulate((ttl_event_1(:,5)));
input = tabulate((ttl_event_1(:,2)));


end