%% This script determines the difference in cochleotopic coverage between PAC ...
% and our novel tonotopic map in adults and children respectively 

% Load plotting colors
load("plotting_colors.mat")

% Load data from PAC
load("pac_cochleotopy_avg_across_hemis.mat")
pac_cochleotopy_adults = cochleotopy_adults;
pac_cochleotopy_kids = cochleotopy_kids; 

% Load data from novel map 
load("tono_1_cochleotopy_avg_across_hemis.mat")
tono_1_cochleotopy_adults = cochleotopy_adults;
tono_1_cochleotopy_kids = cochleotopy_kids; 

% Determine difference in cochleotopic coverage 
% plot_cochlea_spiral expects descending values so flip data 
pac_cochleotopy_adults_flip = fliplr(pac_cochleotopy_adults);
tono_1_cochleotopy_adults_flip = fliplr(tono_1_cochleotopy_adults);
pac_cochleotopy_kids_flip = fliplr(pac_cochleotopy_kids);
tono_1_cochleotopy_kids_flip = fliplr(tono_1_cochleotopy_kids);

% Define custom colormap
load("plotting_colors.mat", "adult_colors")
custom_colormap = interpolateColorMap(adult_colors(3:8,:)); 
custom_colormap_diff = interpolateColorMap(adult_colors(1:6,:)); 


% Adults
plothand_pac_tono_1_diff = plot_cochlea_spiral2(mean(pac_cochleotopy_adults_flip)-mean(tono_1_cochleotopy_adults_flip), custom_colormap_diff);
exportgraphics(plothand_pac_tono_1_diff, 'figure_adult-pac_minus-tono_1_coverage.jpeg', 'Resolution', 300, Units="pixels", Padding=50);

% Kids
plothand_pac_tono_1_diff = plot_cochlea_spiral2(mean(pac_cochleotopy_kids_flip)-mean(tono_1_cochleotopy_kids_flip), custom_colormap_diff);
exportgraphics(plothand_pac_tono_1_diff, 'figure_kid-pac_minus-tono_1_coverage.jpeg', 'Resolution', 300, Units="pixels", Padding=50);

% Plot adult pac - novel map cochleotopic coverage 
f=figure;
freqs = [88	125	150 177	250	354	500	707	1000	1414	2000	2828	4000	5657	8000];
shadedErrorBar(freqs, pac_cochleotopy_adults, {@mean,@std}, ...
    'lineProps', {'-', 'Color', adult_colors(5,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
hold on;
shadedErrorBar(freqs, tono_1_cochleotopy_adults, {@mean,@std}, ...
    'lineProps', {'-', 'Color', adult_colors(7,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
xlabel("Frequency (Hz)")
ylabel("pRF Coverage")
title("Adults Cochleotopic Coverage")
legend(["PAC","Novel Map"]); 
freqs_plot = [88	125	177	250	354	500	707	1000	1414	2000	2828	4000	5657	8000];
xlim([0,freqs_plot(end)])
ylim([0,0.75])
xticks(freqs_plot)
set(gca, 'XScale', 'log')
box off
ax = gca;
ax.FontSize = 14;
set(gca,'TickDir','out');

% Adjust figure size
f.Position(3:4) = [600,400];

% Plot kid pac - novel map cochleotopic coverage 

f=figure;
shadedErrorBar(freqs, pac_cochleotopy_kids, {@mean,@std}, ...
    'lineProps', {'-', 'Color', adult_colors(5,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
hold on;
shadedErrorBar(freqs, tono_1_cochleotopy_kids, {@mean,@std}, ...
    'lineProps', {'-', 'Color', adult_colors(7,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
xlabel("Frequency (Hz)")
ylabel("pRF Coverage")
title("Children Cochleotopic Coverage")
legend(["PAC","Novel Map"]); 
freqs_plot = [88	125	177	250	354	500	707	1000	1414	2000	2828	4000	5657	8000];
xlim([0,freqs_plot(end)])
ylim([0,0.])
xticks(freqs_plot)
set(gca, 'XScale', 'log')
box off
ax = gca;
ax.FontSize = 14;
set(gca,'TickDir','out');

% Adjust figure size
f.Position(3:4) = [600,400];

% Save figure
cd("/Volumes/gomez/data/tonotopy_game/code/figures")
exportgraphics(f, "kids_pac_minus_tono_1_cochleotopy.jpg",'Resolution',300);

