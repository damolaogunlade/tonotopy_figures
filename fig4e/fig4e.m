%% This script plots cochleotopic coverage of PAC on the cochlea 

% First row is adults
load('pac_cochleotopy_matrix.mat')

% plot_cochlea_spiral2 will resample the input to 40 values for a smoother
% visualization, but you feed it a vector in whic the first value
% corresponds to pRF coverage of HIGH frequencies. 
% First left-right flip coverage values
data = fliplr(pac_cochleotopy_matrix);

% Define custom colormap
load("plotting_colors.mat", "adult_colors")
custom_colormap = interpolateColorMap(adult_colors(3:8,:)); 
custom_colormap_diff = interpolateColorMap(adult_colors(1:6,:)); 

% First adults
plothandle_a = plot_cochlea_spiral2(data(1,:), custom_colormap);

% Now kids
plothandle_k = plot_cochlea_spiral2(data(2,:), custom_colormap);

% Let's also plot a difference of the two groups
% This uses a special function so if you enter 'diff' for the colormap name
% it will use a perceptually linear divergent colormap from colorbrewer
% that is produced from the lbmap.mm function
plothand_d = plot_cochlea_spiral2(data(1,:)-data(2,:), custom_colormap_diff);