% Ch is the channel

fileinfo = dir('digitalin.dat');
num_samples = fileinfo.bytes/2; % uint16 = 2 bytes -> .bytes reads the number of bytes from a filehehe

fid = fopen('digitalin.dat', 'r');
digital_word = fread(fid, num_samples, 'uint16');
fclose(fid);

ttl_signal = zeros(length(digital_word),6);
%write every ttl signal channel in a column of ttl_signal
for i = [1:6]
    ttl_signal(:i) = (bitand(digital_word, 2^(i-1)) > 0);
end



% digital_input_0 = (bitand(digital_word, 2^0) > 0);
% digital_input_1 = (bitand(digital_word, 2^1) > 0);
% digital_input_2 = (bitand(digital_word, 2^2) > 0);
% digital_input_3 = (bitand(digital_word, 2^3) > 0);
% digital_input_4 = (bitand(digital_word, 2^4) > 0);
% digital_input_5 = (bitand(digital_word, 2^5) > 0);


% for i = 1:(size(digital_input_0)-1)
%     if digital_input_0(i) ~= digital_input_0(i+1) 
%         count_0 = count_0 + 1;
%     end
% end