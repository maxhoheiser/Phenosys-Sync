function test_2 = calc(test, i)
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