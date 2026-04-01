% This script plots surface area of the primary core in adults and children

% Load plotting colors
load("plotting_colors.mat")

% Load surface area data for kids and adults
load("kids_sa.mat")
load("adults_sa.mat");

% Plot surface area 

% Combine into array
values = [kids_sa, adults_sa]';

% Age grouping
cats = [ ...
    repmat("Children",numel(kids_sa),1);
    repmat("Adults",numel(adults_sa),1)];

% Plot
color_idx = 3; 
colors = {[adult_colors(color_idx,:); kid_colors(color_idx,:)]};
violinplot(values, cats,"ViolinColor",colors,"ShowData",true,"ViolinAlpha",{0.5 0.5});
% ylabel("Surface Area (mm^2)")
% title(sprintf("%s Surface Area",roi))
box on
legend off

% Formatting
ax = gca; 
set(ax,"FontSize",14,"FontName","Arial",'Tickdir','out','LineWidth',1)
box off

% Adjust figure size
f = gcf; 
f.Position(3:4) = [340,325];

