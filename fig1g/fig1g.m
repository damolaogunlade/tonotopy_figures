%% This script plots the 4000 Hz - 150 Hz notch benefit difference in adults vs children 

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

% Values for violin plot
values = [adults_thresh_diff(:,1) - adults_thresh_diff(:,3);kids_thresh_diff(:,1) - kids_thresh_diff(:,3)];

% Create a group/categorical vector
cats = [repmat("Adults", 1, length(adults_thresh_diff(:,1))),repmat("Children", 1, length(kids_thresh_diff(:,1)))];

% Plot
colors = {[adult_colors(6,:); kid_colors(6,:)]};
fig = figure;
violinplot(values, cats,"ViolinColor",colors,"ShowData",true,"ViolinAlpha",{0.5 0.5},"EdgeColor",[0.25 0.25 0.25]);
title('Notch Benefit Difference (4000 Hz - 150 Hz)','Interpreter','none')
ylabel("Threshold (dB)")
yline(0,'k--','LineWidth',1)
box off
ax = gca;
ax.FontSize = 14;
set(gca,'TickDir','out','LineWidth',1)

% Change figure size
width = 325*1.05;
ht = 275;
fig.Position(3:4) = [width, ht];

