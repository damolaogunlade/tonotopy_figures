%% Plot cochleotopic coverage (averaged across hemispheres)

% Load data
cd("/Volumes/gomez/data/tonotopy_game/code/figures_code/fig4d")
label = "pac"; 
load(sprintf("%s_cochleotopy_avg_across_hemis.mat",label),"cochleotopy_adults","cochleotopy_kids")

% Load plotting colors
load("plotting_colors.mat")

% Plot the average cochleotopic coverage plot in adults vs kids (both
% hemispheres)
f=figure;
freqs = [88	125	150 177	250	354	500	707	1000	1414	2000	2828	4000	5657	8000];
shadedErrorBar(freqs, cochleotopy_adults, {@mean,@std}, ...
    'lineProps', {'-', 'Color', adult_colors(5,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
hold on;
shadedErrorBar(freqs, cochleotopy_kids, {@mean,@std}, ...
    'lineProps', {'-', 'Color', adult_colors(7,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
% ylabel('Average Probability density','FontSize',16)
% xlabel('Frequency (Hz)','FontSize',16)
% title(sprintf('%s Cochleotopic Coverage Group Average',label),'Interpreter','none','FontSize',16)
% legend(sprintf("Adults (n = %i)",num_subs(1)),sprintf("Children (n = %i)", num_subs(2)))
legend off
freqs_plot = [88	125	177	250	354	500	707	1000	1414	2000	2828	4000	5657	8000];
xlim([0,freqs_plot(end)])
ylim([0,0.65])
yticks([0.2 0.4 0.6])
xticks(freqs_plot)
set(gca, 'XScale', 'log')
box off
ax = gca;
ax.FontSize = 14;
set(gca,'TickDir','out','LineWidth',1);
set(gca,'XMinorTick','off')
ax.XAxis.FontSize = 10;

% Adjust figure size
% f.Position(3:4) = [600,400]; %PAC
f.Position(3:4) = [800,400];
