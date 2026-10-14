%% This script plots sigma in the primary core in adults and children

% Load plotting colors
load("plotting_colors.mat")

% Load sigma data
load("core_sigma.mat")

adults_sigma_left = data_sigma.adults_sigma_left; 
adults_sigma_left = adults_sigma_left(~isnan(adults_sigma_left)); 

adults_sigma_right = data_sigma.adults_sigma_right; 
adults_sigma_right = adults_sigma_right(~isnan(adults_sigma_right)); 

kids_sigma_left = data_sigma.kids_sigma_left; 
kids_sigma_left = kids_sigma_left(~isnan(kids_sigma_left));

kids_sigma_right = data_sigma.kids_sigma_right; 
kids_sigma_right = kids_sigma_right(~isnan(kids_sigma_right));

% Average values across hemispheres
adults_sigma = (adults_sigma_left + adults_sigma_right) / 2;
kids_sigma = (kids_sigma_left + kids_sigma_right) / 2;
values = [adults_sigma,kids_sigma];

% Create a group/categorical vector
cats = [repmat("Adults", numel(adults_sigma),1);
    repmat("Children", numel(kids_sigma),1)];

% Plot
color_idx = 4;
colors = {[adult_colors(2,:); [63 186 178]/255]}; % kids color is now more like a teal
f = figure;
violinplot(values, cats,"ViolinColor",colors,"ShowData",true,"ViolinAlpha",{0.5 0.5});
% title(sprintf('%s Average Bandwidth Tuning',roi),'Interpreter','none')
% ylabel("Sigma (Hz)")
ylim([100 700])
yticks([100 300 500 700])
yticklabels([0.1 0.3 0.5 0.7])
% yticks([0 300 450 600])
% yticklabels([0 0.3 0.45 0.6])
box off
ax = gca;

% Formatting
set(ax,"FontSize",14,"FontName","Arial",'Tickdir','out','LineWidth',1)
box off

% Change figure size
f.Position(3:4) = [340 250]; 