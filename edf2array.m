function [raw_data,t] = edf2array(edf,time_start_in_sec,time_end_in_sec,sfreq,channels)
arguments
    edf
    time_start_in_sec
    time_end_in_sec
    sfreq = 512

    channels = []
end
if isempty(channels)
    channels = 1:size(edf,2);
end

duration_in_sec = time_end_in_sec - time_start_in_sec;
num_channels = length(channels);

t = (0:(time_end_in_sec+1)*sfreq-1)/sfreq;


raw_data = zeros(num_channels,duration_in_sec*sfreq,'single');

for i = 1:num_channels
    for j = time_start_in_sec:time_end_in_sec        
        raw_data(i,j*sfreq+1:(j+1)*sfreq) = edf{j+1,i}{1};
    end
end





end