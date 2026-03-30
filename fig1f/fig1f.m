%% This script plots flat spectrum - notched spectrum thresholds in adults vs kids

% Load adult data  
cd('/Volumes/gomez/data/tonotopy_game/code/figures_code/fig1e')
load("adults_avg_thresh.mat","avg_thresh");
adults_avg_thresh = avg_thresh;

% Load kid data  
load("kids_avg_thresh.mat","avg_thresh");
kids_avg_thresh = avg_thresh;

% Calculate flat - notched spectrum thresholds
adults_thresh_diff = [adults_avg_thresh(:,1) - adults_avg_thresh(:,2), adults_avg_thresh(:,3) - adults_avg_thresh(:,4),adults_avg_thresh(:,5) - adults_avg_thresh(:,6)];
kids_thresh_diff = [kids_avg_thresh(:,1) - kids_avg_thresh(:,2), kids_avg_thresh(:,3) - kids_avg_thresh(:,4),kids_avg_thresh(:,5) - kids_avg_thresh(:,6)];

% Calculate mean and sem 
adults_sem_thresh = std(adults_thresh_diff,"omitmissing")/sqrt(size(adults_thresh_diff,1)); 
adults_mean_thresh = mean(adults_thresh_diff,1,"omitnan"); 
kids_sem_thresh =  std(kids_thresh_diff,"omitmissing")/sqrt(size(kids_thresh_diff,1)); 
kids_mean_thresh = mean(kids_thresh_diff,1,"omitnan"); 

% Plot 
fig = figure;
frequencies = ["150 Hz", "2000 Hz","4000 Hz"];
shadedErrorBar(1:length(frequencies),adults_mean_thresh,adults_sem_thresh,'lineProps',{'Color',adult_colors(4,:),'Marker','o','markerfacecolor',adult_colors(4,:)},'patchSaturation', 0.75);
hold on;
shadedErrorBar(1:length(frequencies),kids_mean_thresh,kids_sem_thresh,'lineProps',{'Color',kid_colors(4,:),'Marker','o','markerfacecolor',kid_colors(4,:)},'patchSaturation', 0.5);
hold on; 
xticks(1:length(frequencies))
xticklabels(frequencies)
ylabel("Flat - Notched Thresholds (dB)")
legend("Adults","Kids")
legend off
title("Notch Benefit")
box off
ax = gca;
ax.FontSize = 14;
set(gca,'TickDir','out','LineWidth',1)
legend(["Adults","Children"])

% Change figure size
width = 350;
ht = 275;

% Set the width and height properties (first two elements are position, which you can leave as is)
fig.Position(3:4) = [width, ht];

