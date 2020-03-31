function excel_substract()
output_data_excel = [];
correction_vec = [];
%substract a line from excel if too much

wrong = XXX;
x = wrong - 2;
output_data_excel((length(output_data_excel)+1),1) = x;
output_data_excel((length(output_data_excel)+1),2:17) = output_data(x,1:16);

for i = x:(length(output_data)-1);
    output_data(i,1:16) = output_data((i+1),1:16);
    output_data(i,35) = output_data((i+1),35);
end
output_data(length(ouptut_data),1:16) = 0;
output_data(length(output_data),35) = 0;
correction_vec(end+1,1)=wrong;
correction_vec(end,2)=1
clear 'wrong' 'x';
end