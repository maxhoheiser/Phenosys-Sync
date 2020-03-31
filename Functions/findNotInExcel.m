function find_not_in_excel = findNotInExcel(output_data, output_data_ttl, ground_truth)

%% find not in excel
find_not_in_excel=[];
for i = 1:size(output_data_ttl,1)
    col = size(find_not_in_excel,1);
    find_not_in_excel((col+1):(col+7),1)=(output_data_ttl(i,1));
    find_not_in_excel((col+1):(col+7),2)=(output_data_ttl(i,2:8))';
    find_not_in_excel((col+1):(col+7),4)=(output_data_ttl(i,9:15))';
end

find_not_in_excel = find_not_in_excel(~all(find_not_in_excel == 0, 2),:);

for i = 1:size(find_not_in_excel,1)
    find_not_in_excel(i,3)=(find_not_in_excel(i,2)-output_data(1,19));
end

for i = 1:size(find_not_in_excel,1)
    if sum(find_not_in_excel(i,3)==ground_truth(:,4))~=0
        find_not_in_excel(i,5)=1;
    end
end


end