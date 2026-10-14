%% This script plots average masked thresholds in adults and children 

% Define frequency and white noise conditions
frequencies = ["150 Hz", "2000 Hz","4000 Hz"];
conditions = ["150 Hz Flat", "150 Hz Notched", "2000 Hz Flat", "2000 Hz Notched", "4000 Hz Flat", "4000 Hz Notched"];

% Load plotting colors
load("plotting_colors.mat")

% Load adult thresholds
% cd('/Volumes/gomez/data/tonotopy_game/code/figures_code/fig1e')
cd('/Users/oo9037/Documents/figures_code_updated_102026/fig1e')
load("adults_data.mat","avg_thresh_table")
adults_data = avg_thresh_table;
adults_avg_thresh = table2array(adults_data(:,3:end));

% Plot adult thresholds
fig = openfig("adults_group_avg_masked_thresh.fig");
ax = gca;                         

% Change color of plot
patches = findall(ax, 'Type', 'Patch', 'Tag', 'shadedErrorBar_patch');
lines   = findobj(ax, 'Type', 'Line');  
edges = findall(ax,'Type','Line','Tag','shadedErrorBar_edge');

% Notched spectrum
set(lines(1), 'Color', adult_colors(5,:));
set(lines(1), 'MarkerEdgeColor', adult_colors(5,:));
set(lines(1), 'MarkerFaceColor', adult_colors(5,:));
set(edges(1), 'Color', adult_colors(5,:));
set(edges(2), 'Color', adult_colors(5,:));
set(patches(1), 'FaceColor', adult_colors(5,:), 'FaceAlpha', 0.75);

% Flat spectrum
set(lines(2), 'Color', adult_colors(3,:));
set(lines(2), 'MarkerEdgeColor', adult_colors(3,:));
set(lines(2), 'MarkerFaceColor', adult_colors(3,:));
set(edges(3), 'Color', adult_colors(3,:));
set(edges(4), 'Color', adult_colors(3,:));
set(patches(2), 'FaceColor', adult_colors(3,:), 'FaceAlpha', 0.75);

% Visualization
xticks([150,2000,4000])
xticklabels(frequencies)
ylabel("Signal Detection Threshold (dB)",'FontSize',14,'FontName','Arial')
box off
ax = gca;
ax.FontSize = 14;
ax.FontName  = "Arial";
set(gca,'TickDir','out','LineWidth',1)
title("Average Masked Thresholds")
title('')
hold on;

% Change figure size
width = 350;
ht = 275;
fig.Position(3:4) = [width, ht];

% Load kid data
cd('/Users/oo9037/Documents/figures_code_updated_102026/fig1e')
load("kids_data.mat","avg_thresh_table")
kids_data = avg_thresh_table;
kids_avg_thresh = table2array(kids_data(:,3:end));

% Calculate mean and standard error of mean
sem_thresh = std(kids_avg_thresh,"omitmissing")/sqrt(size(kids_avg_thresh,1));
mean_thresh = mean(kids_avg_thresh,1,"omitnan");

% Initialize matrix to hold different frequencies for plotting purposes
freq_mat = repelem([150;2000;4000],1,height(kids_avg_thresh));
freq_mat = freq_mat';

% Plot flat condition thresholds (kids)
shadedErrorBar(freq_mat(1,:),mean_thresh([1,3,5]),sem_thresh([1,3,5]),'lineProps',{'Color',kid_colors(3,:),'Marker','o','markerfacecolor',kid_colors(3,:)},'patchSaturation', 0.5);
hold on;

% Plot notched condition thresholds (kids)
shadedErrorBar(freq_mat(1,:),mean_thresh([2,4,6]),sem_thresh([2,4,6]),'lineProps',{'Color',kid_colors(5,:),'Marker','o','markerfacecolor',kid_colors(5,:)},'patchSaturation', 0.5);
hold on;

% Add legend
legend(sprintf("Adults (n = %i) Flat Spectrum", height(adults_data)),...
    sprintf("Adults (n = %i) Notched Spectrum" ,height(adults_data)),...
    sprintf("Kids (n = %i) Flat Spectrum" ,height(kids_data)),...
    sprintf("Kids (n = %i) Notched Spectrum" ,height(kids_data)),...
    "FontSize",5)


















