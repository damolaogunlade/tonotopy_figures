%% This script plots variance explained in auditory ROI in adults and children

% Load plotting colors
load("plotting_colors.mat")

% Load variance explained data 
load("adults_varexp.mat")
load("kids_varexp.mat")

% Plot variance explained

% Average values across hemispheres
adults_varexp = (adults_varexp_left + adults_varexp_right) / 2;
kids_varexp = (kids_varexp_left + kids_varexp_right) / 2;
values = [adults_varexp,kids_varexp];

% Create a group/categorical vector
cats = [repmat("Adults", numel(adults_varexp),1);
    repmat("Children", numel(kids_varexp),1)];

% Violin plot 
color_idx = 2;
colors = {[adult_colors(color_idx,:); kid_colors(color_idx,:)]};
f = figure;
violinplot(values, cats,"ViolinColor",colors,"ShowData",true,"ViolinAlpha",{0.5 0.5});
% title(sprintf('%s Average Variance Explained',roi),'Interpreter','none')
% ylabel("Variance Explained")
ylim([0 0.3])
box off
ax = gca;

% Formatting
set(ax,"FontSize",14,"FontName","Arial",'Tickdir','out','LineWidth',2)
box off

% Change figure size
f.Position(3:4) = [550 250];
