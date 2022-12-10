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



%% take segment of edf data


acc_history = [];

for r = 1:30
edf_data = raw_edf_data(r*10+(1:10),isEcog);
[raw_data,t] = edf2array_edfonly(edf_data);
features = extract_features_from_eeg(raw_data'); % extract features from eeg

% classify electrode

decision = nan(64,1);

index = [7,8];
for i = 1:64
    p1 = sum(log10(normpdf(features(i,index)',mu_soz(index),sigma(index))));
    p2 = sum(log10(normpdf(features(i,index)',mu_normal(index),sigma(index))));
    
    decision(i) = p1<p2;
    
    
    
    
end

tabulate(decision)

acc_history(r) = mean(decision == isresect);
end

mean(acc_history)


