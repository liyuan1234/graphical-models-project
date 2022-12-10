%%
% This code performs EEG signal processing and feature extraction.
% this code is reformat of code provided online (github, matlab file exchange) by Farhad Abedinzadeh torghabeh
% Farhad Abedinzadeh (2022). Automatic EEG Signal Preprocessing and Feature
% Extraction
% (https://github.com/farhadabedinzadeh/AutomaticEEGSignalPreprocessingAndLinearNonlinearFeatureExtraction/releases/tag/1.0.0),
% GitHub. Retrieved December 8, 2022.


function features = extract_features_from_eeg(signal)

%% PreProcessing
Fs = 512; 
[fs , preprocessed_signal ] =preprocessing_signal(signal,Fs);
%% Band Extraction and Normalize 
normalizedsig = mat2gray(preprocessed_signal);
out = band_extraction_kaiser(normalizedsig , fs); % is a structure include all Bands(Delta,Theta,Alpha,Beta and Gamma )
%% Feature Extraction

% Linear Univariate Features 
[abpDelta,abpTheta,abpAlpha,abpBeta,abpGamma,TBR] = Linear_featuree(out);

% Non-Linear UniVariate Feature
% m=2;r=0.2;tau=3; for example

[SampleEntropy,ShannonEn,Dispx,MSEnt]=NonLinearFeature(normalizedsig);




features = [[abpDelta;abpTheta;abpAlpha;abpBeta;abpGamma;TBR];[SampleEntropy;ShannonEn;Dispx;MSEnt]];
features = features';

end