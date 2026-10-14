%% This script plots mu in the HG in adults and children

% Load mu data 
load("hg_mu.mat")

adults_mu_left = data_mu.adults_mu_left; 
adults_mu_left = adults_mu_left(~isnan(adults_mu_left)); 
adults_mu_right = data_mu.adults_mu_right; 
adults_mu_right = adults_mu_right(~isnan(adults_mu_right)); 
kids_mu_left = data_mu.kids_mu_left; 
kids_mu_left = kids_mu_left(~isnan(kids_mu_left));
kids_mu_right = data_mu.kids_mu_right;
kids_mu_right = kids_mu_right(~isnan(kids_mu_right));


% Plot mu 

% Average values across hemispheres
adults_mu = (adults_mu_left + adults_mu_right) / 2;
kids_mu = (kids_mu_left + kids_mu_right) / 2;
values = [adults_mu,kids_mu];

% Create a group/categorical vector
cats = [repmat("Adults", numel(adults_mu),1);
    repmat("Children", numel(kids_mu),1)];

% Plot
color_idx = 4;
colors = {[adult_colors(2,:); [63 186 178]/255]}; % kids color is now teal
f = figure;
violinplot(values, cats,"ViolinColor",colors,"ShowData",true,"ViolinAlpha",{0.5 0.5});
% title(sprintf('%s Average Preferred Frequency',roi),'Interpreter','none')
% ylabel("Mu (Hz)")
yticks([0 1000 2000 3000])
yticklabels([0 1 2 3])
% yticks([0 500 1500 2500])
% yticklabels([0 0.5 1.5 2.5])
xticks([1 2])


box off
ax = gca;

% Formatting
set(ax,"FontSize",14,"FontName","Arial",'Tickdir','out','LineWidth',1)
box off

% Change figure size
f.Position(3:4) = [340 250]; % pac