%% This script plots sigma in the novel map in adults and children

% Load plotting colors
cd("/Volumes/gomez/data/tonotopy_game/code/figures_code/fig5f")
load("plotting_colors.mat")

% Load variance explained data 
load("adults_sigma.mat")
load("kids_sigma.mat")

% Average values across hemispheres
adults_sigma = (adults_sigma_left + adults_sigma_right) / 2;
kids_sigma = (kids_sigma_left + kids_sigma_right) / 2;
values = [adults_sigma,kids_sigma];

% Create a group/categorical vector
cats = [repmat("Adults", numel(adults_sigma),1);
    repmat("Children", numel(kids_sigma),1)];

% Plot
color_idx = 5;
colors = {[adult_colors(color_idx,:); kid_colors(color_idx,:)]};
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