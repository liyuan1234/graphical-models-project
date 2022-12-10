function [raw_data,t] = edf2array_edfonly(edf,sfreq,channels)
arguments
    edf
    sfreq = 512

    channels = []
end
if isempty(channels)
    channels = 1:size(edf,2);
end

num_channels = length(channels);

time_start_in_sec = 0;
time_end_in_sec = size(edf,1)-1;
duration_in_sec = time_end_in_sec - time_start_in_sec;
t = (0:(time_end_in_sec+1)*sfreq-1)/sfreq;


raw_data = zeros(num_channels,duration_in_sec*sfreq,'single');

for i = 1:num_channels
    for j = 0:time_end_in_sec    
        raw_data(i,j*sfreq+1:(j+1)*sfreq) = edf{j+1,i}{1};
    end
end





end