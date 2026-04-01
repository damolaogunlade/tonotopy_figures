%% This script plots the stimulus image for pRF mapping 

% Load stimulus image and paradigm files 
cd("/Volumes/gomez/data/tonotopy_game/code/figures_code/fig2b")
load("tones.mat")
load("stimImg.mat")
load("paradigm.mat")

% Update stim image with tones
for j = 1:size(stimImg,2)
    time_arr = stimImg(:,j);
    i = find(time_arr==1);
    % stimImg(i,j) = paradigm(j);
    stimImg(i,j) = i;
end

% Custom color map
% colors = [
% 0.75      0.75     0.75     % add white for zeros
% 0.1020 0.0627 0.2588
% 0.2667 0.1137 0.3098
% 0.4078 0.1804 0.3490
% 0.5373 0.2627 0.3804
% 0.6510 0.3647 0.4118
% 0.7490 0.4784 0.4471
% 0.8314 0.6000 0.4941
% 0.8980 0.7294 0.5608
% 0.9529 0.8627 0.6471
% 0.9961 0.9961 0.7647
% ];

colors = [
0.75   0.75   0.75  % gray for plotting silence
0.1020 0.0627 0.2588
0.2367 0.1044 0.3005
0.3630 0.1594 0.3362
0.4784 0.2253 0.3668
0.5890 0.3091 0.3950
0.6866 0.4061 0.4246
0.7677 0.5060 0.4600
0.8350 0.6082 0.5017
0.8895 0.7118 0.5547
0.9349 0.8177 0.6198
0.9714 0.9130 0.6845
0.9961 0.9961 0.7647
];

% Pad stimImg with zeros for plotting 
stimImg_new = [stimImg,zeros(size(stimImg,1),10)]; 

% Plot
figure;
imagesc(flipud(stimImg_new))
colormap(colors)
colorbar
clim([0,length(tones)])
set(gca, 'ColorScale', 'log');
ylabel("Frequency (Hz)")
xlabel("Time (s)")
yticks(1:length(tones))
yticklabels(fliplr(tones))
title("Stimulus Image")
xticks([1 200 400 600 800])
xticklabels([0 100 200 300 400])
% xticklabels([1:2:length(paradigm)/2]*30)

% Visualization
box off
ax = gca;
ax.FontSize=14;
set(gca,'TickDir','out');
f = gcf;
f.Position(3:4)= [800  400];
ax.LineWidth = 1; 
set(gca,'ColorScale','linear')
