
%% This script plots mu vs sigma in the primary core of adults and children 

% Load plotting colors 
cd("/Volumes/gomez/data/tonotopy_game/code/figures_code/fig4c")
load("plotting_colors.mat")
colors = [adult_colors(2,:);adult_colors(5,:)]; 

% Load surface area data for kids and adults
load("adults_muVsSigma.mat");
adults_mu_vs_sigma = group_sigma;
load("kids_muVsSigma.mat");
kids_mu_vs_sigma = group_sigma; 

% Plot
shadedErrorBar(new_freqs, adults_mu_vs_sigma, {@mean,@std}, ...
    'lineProps', {'-', 'Color', colors(1,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
hold on;
shadedErrorBar(new_freqs, kids_mu_vs_sigma, {@mean,@std}, ...
    'lineProps', {'-', 'Color', colors(2,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
freqs_plot = [88	125	177	250	354	500	707	1000	1414	2000	2828	4000	5657	8000];
xlim([0,freqs_plot(end)])
ylim([0,300])
xticks(freqs_plot)
xticklabels(freqs_plot)
yticks([0 100 200 300])
yticklabels([0 1 2 3])
ylim([0 300])
set(gca, 'XScale', 'log')
box off
ax = gca;
ax.FontSize = 14;
ax.XAxis.FontSize = 10;
set(gca,'TickDir','out','LineWidth',1);
set(gca,'XMinorTick','off')
legend off

% Change figure size
f = gcf;
f.Position(3:4) = [400 250];