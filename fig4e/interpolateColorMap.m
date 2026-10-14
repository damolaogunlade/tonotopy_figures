function CT = interpolateColorMap(colormap)

% This function creates a custom colormap 
cd("/Volumes/gomez/data/tonotopy_game/code")

% Load plotting colors
load("plotting_colors.mat")

% Define the number of colors in the final map
ncolors = 256; 

% Define "breakpoint" colors as RGB triplets (values should be in [0, 1])
% e.g., Green -> Purple -> Yellow
CT0 = colormap; 

% Define the positions (indices or values) for these colors in a normalized range [0, 1]
x0 = linspace(0, 1, size(CT0, 1)); 

% Define the range for the final interpolated map
xf = linspace(0, 1, ncolors); 

% Use interp1 to get the new, smoothly interpolated color table (CT)
CT = interp1(x0, CT0, xf, 'linear'); 
