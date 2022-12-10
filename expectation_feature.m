%% compute expected value of features for soz/resect and not soz/resect
% features is a 64xn matrix, where n is number of features


mu_soz = mean(features(isresect,:),'omitnan')';
mu_normal = mean(features(~isresect,:),'omitnan')';
sigma_soz = std(features(isresect,:),'omitnan')';
sigma_normal = std(features(~isresect,:),'omitnan')';

sigma = std(features,'omitnan')';

num_features = size(mu_soz,1);



[mu_soz,mu_normal,mu_soz-mu_normal,sigma]

labels = {'delta','gamma','alpha','beta','gamma','theta/beta','shanon','dispersion'};



make_box_plot = 1;
if make_box_plot
clf;hold on
boxplot(features(isresect,:),'positions',1:4:num_features*4,'labels',labels)
boxplot(features(~isresect,:),'positions',(1:4:num_features*4)+2.5,'labels',labels)
ylim([0,2])
title('extracted features for resected electrode vs non-resected')

save_boxplot = 1;
if save_boxplot
saveas(gcf,'features_boxplot.png')
end
end