function [tll_event] = count_len(ttl_chan)
count = 0
% for i = 1:7
ttl_event = [];
i = (ttl_chan+1);
for j = 1:(length(digital_word)-1)
    if ttl_signal(j,i) == ttl_signal(j+1,i);
        count = count +1;
    else
        len = size(ttl_event,1);
        ttl_event((len+1),2) = count;
        ttl_event((len+1),1) = ttl_event(len,1)+count;
        count = 0;
    end
end
end
