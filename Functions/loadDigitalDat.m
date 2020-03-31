function ttl_event = loadDigitalDat(directory,channel)
% load digitalin.dat and extract ttl signals bitwise
% FILE = 'C:\...\digitalin.dat
% CHANNEL = which digital chanel you want to have
% 0, 1, 2, 3, 4, 5, 6

file = convertStringsToChars(strcat(directory,"\electrophysiology\digitalin.dat"));

fileinfo = dir(file);

num_samples = fileinfo.bytes/2; % uint16 = 2 bytes -> .bytes reads the number of bytes from a filehehe

fid = fopen(file, 'r');
digital_word = fread(fid, num_samples, 'uint16');
fclose(fid);

ttl_signal = zeros(length(digital_word),7);
count = zeros(1,7);

%write every ttl signal channel in a column of ttl_signal
for i = [1:7]
    ttl_signal(:,i) = (bitand(digital_word, 2^(i-1)) > 0);
    
     %evaluate the number of changes per ttl input channel
      for j = 1:(length(digital_word)-1)
          if ttl_signal(j,i) ~= ttl_signal(j+1,i) 
              count(i) = count(i) + 1;
          end
      end
      if mod(count(i),2) ~= 0
          count(i) = count(i) + 1;
      end
end
count = count./2;



%ttl_event_0 = calc(ttl_signal, 0);
ttl_event = calc(ttl_signal, channel);
%ttl_event_2 = calc(ttl_signal, 2);
%ttl_event_3 = calc(ttl_signal, 3);
%ttl_event_4 = calc(ttl_signal, 4);
%ttl_event_5 = calc(ttl_signal, 5);
%ttl_event_6 = calc(ttl_signal, 6);

%convert ttl to ms
for i = 1:length(ttl_event)
    ttl_event(i,4) = (ttl_event(i,1))/20;
end

end