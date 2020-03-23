test_2 = [];
count = 0;
i = 1;
for j = 1:(length(test)-1)
    if test(j,i) == test(j+1,i)
        count = count +1;
    elseif test(j,i) ~= test(j+1,i)
        count = count +1
        len = size(test_2,1);
        test_2((len+1),3) = test(j,i);
        test_2((len+1),2) = count;
        test_2((len+1),1) = j - count + 1;
        count = 0
    end
end

if test(length(test),i) == test(length(test)-1,i)
    count = count +1
    len = size(test_2,1);
    test_2((len+1),3) = test(length(test),i);
    test_2((len+1),2) = count;
    test_2((len+1),1) = length(test) - count + 1;
    count = 0    
end

if test(length(test),i) ~= test(length(test)-1,i)
    count = 1
    len = size(test_2,1);
    test_2((len+1),3) = test(length(test),i);
    test_2((len+1),2) = count;
    test_2((len+1),1) = length(test) - count + 1;
    count = 0
end

