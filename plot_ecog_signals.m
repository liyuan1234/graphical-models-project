%% load data

clear;
clc;

subject = 'HUP065';
ictal_or_interictal = 'interictal';
run = '01';


fileroot = sprintf('sub-%s_ses-presurgery_task-%s_acq-ecog_run-%s',subject,ictal_or_interictal,run);
filename = [fileroot '_ieeg.edf'];
% root = '/Users/liyuan/Desktop/matlab/epilepsy data/hup/sub-HUP064/ses-presurgery/ieeg/';

filepath = sprintf('./data/hup/sub-%s/ses-presurgery/ieeg/%s',subject,filename);
raw_edf_data = edfread(filepath);
info = edfinfo(filepath);

channels_filename = [fileroot '_channels.tsv'];
channels_filepath = sprintf('./data/hup/sub-%s/ses-presurgery/ieeg/%s',subject,channels_filename);
channel_table = readtable(channels_filepath,'filetype','delimitedtext');

mode = 'all';

if strcmp(mode,'seizure')
temp = strrep(fileroot,'-02','-01');
event_filename = [temp '_events.tsv'];
event_filepath = sprintf('./data/hup/sub-%s/ses-presurgery/ieeg/%s',subject,event_filename);
event_table = readtable(event_filepath,'filetype','delimitedtext');

seizure_onset = round(event_table{1,1});
seizure_off = round(event_table{2,1});
else
    seizure_onset = [];
    seizure_off = [];
end


%% get indices

isEcog = contains(info.SignalLabels,'EEG LG');
isEcog_removeEKG = isEcog(3:end);

isresect = contains(channel_table{:,11},'resect') | contains(channel_table{:,11},'soz');
isresect(~isEcog_removeEKG) = [];
issoz = contains(channel_table{:,11},'soz');
issoz(~isEcog_removeEKG) = [];
isgood = contains(channel_table{:,10},'good');
isgood(~isEcog_removeEKG) = [];



if strcmp(mode,'seizure')
edf_data = raw_edf_data(seizure_onset:seizure_off,isEcog);

elseif strcmp(mode,'all')
    
edf_data = raw_edf_data(:,isEcog);

end


%% convert edf data format to array
tic



if strcmp(mode,'seizure')
time_start_in_sec = seizure_onset;
time_end_in_sec = seizure_off;
elseif strcmp(mode,'all')
    time_start_in_sec = 0;

    time_end_in_sec = info.NumDataRecords-1; 

end



% [raw_data,t] = edf2array(edf_data,time_start_in_sec,time_end_in_sec);
[raw_data,t] = edf2array_edfonly(edf_data);
toc

%% extract features from eeg


features = extract_features_from_eeg(raw_data');



%% save ecog only signals
save_ecog_signals_as_array = 0;
if save_ecog_signals_as_array
raw_ecog = raw_data(9:72,:);
save(['./data/my_data/' subject],'raw_ecog')

end


%% remove 'eeg' header from labels
% every electrode name starts with EEG. remove it.
labels = cellfun(@(x) strrep(x,'EEG ',''),info.SignalLabels,'UniformOutput',false);
labels(~isEcog) = [];


%% plot signals


time_start_in_sec_plot = 0;
time_end_in_sec_plot = 277;
channel_to_plot = [1:16];

% t = (time_start_in_sec_plot*512:(time_end_in_sec_plot+1)*512)/512;

tiledlayout(length(channel_to_plot),1,'tilespacing','compact','padding','compact')
for i = channel_to_plot
    nexttile
    plot(t,raw_data(i,:),'linewidth',3)
    xlim([time_start_in_sec_plot,time_end_in_sec_plot])
    ylabel(labels(i),'rotation',0,'horizontalalignment','right')
    
    
    % only keep x axis ticks for bottom plot
    if i ~= channel_to_plot(end)
        set(gca,'xtick',[])
    end
    set(gca,'ytick',[])
    box off
end
set(gca, 'XTickLabel',get(gca,'XTick'))  % remove exponent from x axis
xlabel('time/s')


do_save = 0;
if do_save
quicksave(titlestring)
end
