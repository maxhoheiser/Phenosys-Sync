function ttl_add(wrong)
%add a line from ttl if not detected

x = wrong;
output_data_ttl((end+1),1:17) = output_data(x,18:34);

for i = (size(output_data,1)+1):-1:x
    output_data(i,18:34) = output_data((i-1),18:34);
    output_data(i,38) = output_data((i-1),38);
end
output_data(x,18:34) = 0;
output_data(x,38) = 0;

%recalculate relative values
for i = 1:length(output_data)
    output_data(i,35) = (output_data(i,34) - output_data(i,17));
end
output_data(:,36) = round(output_data(:,35),0);

for i = 1:length(output_data)
    output_data(i,39) = (output_data(i,38) - output_data(i,37));
end
end