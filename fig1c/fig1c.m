%% This script plots a spectrogram of an example 150 Hz notched condition trial

% Load stimulus matrix 
cd("/Volumes/gomez/data/tonotopy_game/code/figures_code/fig1c")
load("ex_stim.mat")

% 3 AFC stimuli in first trial of 150 Hz Notched condition 
% y1 = tone embedded in white noise
% y2 = white noise
% y3 = white noise

% Sampling rate
fs = 44100; 

% Plot spectrogram
f = figure;
spectrogram(y1,length(y1)/5,[],[],fs,'yaxis')
ylim([0,.3])
% ylabel('Frequency (kHz)')
% xlabel('Time (s)')
% title("150 Hz Notched Stimulus")
colormap nebula; 
a = colorbar; 
clim([-75 -30])
box off
ax = gca;
ax.FontSize = 14;
set(gca,'TickDir','out','LineWidth',1);
f.Position(3:4)= [ 300*0.8   225*0.8];
