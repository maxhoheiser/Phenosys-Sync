function ttl_substract()
%remove a line from excel wrong detected

wrong = 276
x = wrong - 1;
for i = (length(output_data)+1):-1:x;
    output_data(i,17:32) = output_data((i-1),17:32);
    output_data(i,36) = output_data((i-1),36);
end
correction_vec(end+1,1)=wrong;
correction_vec(end,2)=3
end