%% This script determines the difference in cochleotopic coverage between the core...
% and our novel tonotopic map in adults and children respectively 

% Load plotting colors
load("plotting_colors.mat")

roi_1 = "core";
roi_2 = "tono_1";

% Load data from roi_1
load(sprintf("%s_cochleotopy_avg_across_hemis.mat",roi_1))
roi_1_cochleotopy_adults = cochleotopy_adults;
roi_1_cochleotopy_kids = cochleotopy_kids; 
roi_1_cochleotopy_kids = rmmissing(roi_1_cochleotopy_kids);

% Load data from roi_2
load(sprintf("%s_cochleotopy_avg_across_hemis.mat",roi_2))
roi_2_cochleotopy_adults = cochleotopy_adults;
roi_2_cochleotopy_kids = cochleotopy_kids; 
roi_2_cochleotopy_kids = rmmissing(roi_2_cochleotopy_kids);


% Determine difference in cochleotopic coverage 
% plot_cochlea_spiral expects descending values so flip data 
roi_1_cochleotopy_adults_flip = fliplr(roi_1_cochleotopy_adults);
roi_2_cochleotopy_adults_flip = fliplr(roi_2_cochleotopy_adults);
roi_1_cochleotopy_kids_flip = fliplr(roi_1_cochleotopy_kids);
roi_2_cochleotopy_kids_flip = fliplr(roi_2_cochleotopy_kids);

% Define custom colormap
load("plotting_colors.mat", "adult_colors")
custom_colormap = interpolateColorMap(adult_colors(3:8,:)); 
custom_colormap_diff = interpolateColorMap(adult_colors(1:6,:)); 
custom_colormap_diff = "diff";

% Adults
plothand_roi_1_roi_2_diff = plot_cochlea_spiral2(mean(roi_1_cochleotopy_adults_flip)-mean(roi_2_cochleotopy_adults_flip), custom_colormap_diff);cd("/Volumes/gomez/data/tonotopy_game/code/figures")
exportgraphics(plothand_roi_1_roi_2_diff, sprintf('figure_adult-%s_minus-%s_coverage.jpeg',roi_1,roi_2), 'Resolution', 300, Units="pixels", Padding=50);

% Kids
plothand_roi_1_roi_2_diff = plot_cochlea_spiral2(mean(roi_1_cochleotopy_kids_flip)-mean(roi_2_cochleotopy_kids_flip), custom_colormap_diff);
exportgraphics(plothand_roi_1_roi_2_diff, sprintf('figure_kid-%s_minus-%s_coverage.jpeg',roi_1,roi_2), 'Resolution', 300, Units="pixels", Padding=50);

% Plot adult roi_1 - novel map cochleotopic coverage 
f=figure;
freqs = [88	125	150 177	250	354	500	707	1000	1414	2000	2828	4000	5657	8000];
shadedErrorBar(freqs, roi_1_cochleotopy_adults, {@mean,@std}, ...
    'lineProps', {'-', 'Color', adult_colors(5,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
hold on;
shadedErrorBar(freqs, roi_2_cochleotopy_adults, {@mean,@std}, ...
    'lineProps', {'-', 'Color', adult_colors(7,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
xlabel("Frequency (Hz)")
ylabel("pRF Coverage")
title("Adults Cochleotopic Coverage")
legend([roi_1,roi_2],"Interpreter","none"); 
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
shadedErrorBar(freqs, roi_1_cochleotopy_kids, {@mean,@std}, ...
    'lineProps', {'-', 'Color', adult_colors(5,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
hold on;
shadedErrorBar(freqs, roi_2_cochleotopy_kids, {@mean,@std}, ...
    'lineProps', {'-', 'Color', adult_colors(7,:), 'LineWidth', 2}, ...
    'patchSaturation', 0.5);
xlabel("Frequency (Hz)")
ylabel("pRF Coverage")
title("Children Cochleotopic Coverage")
legend([roi_1,roi_2],"Interpreter","none"); 
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

% Save figure
exportgraphics(f, sprintf("kids_%s_minus_%s_cochleotopy.jpg",roi_1,roi_2),'Resolution',300);

