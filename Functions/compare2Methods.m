function compare_2_methods = compare2Methods(output_data,ground_truth)

%% compare 2 methods times

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
    compare_2_methods(i,11) = (compare_2_methods(i,8)-compare_2_methods(i,3));
end

for i = 1:size(compare_2_methods,1)
    compare_2_methods(i,12) = (compare_2_methods(i,9)-compare_2_methods(i,4));
end

compare_2_methods(:,13)=1:size(compare_2_methods,1);
compare_2_methods(:,14)=(compare_2_methods(:,3)-compare_2_methods(:,8));






end