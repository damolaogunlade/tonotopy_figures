function plotTuningCurve(collated, voxID)
%Plot a given voxel's predicted tuning curve 
% Inputs:
%   collated        A structure containing all fitted pRF information as
%                   as given by [collated] = estpRF(scan, seeds, hrf, opt)
%   voxID         Voxel ID to plot
%% Average BOLD response across runs 

% Add paths
% addpath(genpath('/Volumes/gomez/data/tonotopy/code/jesse_version'))


% List of all stimulus frequencies
stim = collated.scan.funcOf.x;

% List of frequencies presented during the task 
stim_presented = collated.scan.paradigm.x;
stim_presented = horzcat(zeros(1,8),stim_presented); 

% Initialize list that will contain the BOLD response during the presentation
% of a given frequency
freq_bold = [];

% Initialize list that will contain the BOLD response for each stim
% frequency
avg_bold = zeros(1,length(stim));

% Initialize list that will contain the std_err of BOLD response to each
% freq
std_err = zeros(1,length(stim));

% Determine the mu and sigma of the voxel
all_mus = vertcat(collated.pRF.mu);
mu = all_mus(find(vertcat(collated.pRF.id)==voxID));
all_sigmas = vertcat(collated.pRF.sigma);
sigma = all_sigmas(find(vertcat(collated.pRF.id)==voxID));

predicted = predictpRF(collated, collated.scan);
actual = cat(1, predicted.tc);

% Find the TR when the stim was presented and then 8 TRs later take 3 TRs
% worth of data and average 

% For each frequency, iterate through the list of all frequencies presented
% and average the BOLD response for each frequency
lag = 0;  % TRs 
for i = 1:length(stim)
    for j = 1:length(stim_presented) 
        idxs = find(stim(i) == stim_presented(j));
        
        if stim(i) == stim_presented(j)
            % To account for the HRF, consider the response 8 - 12 seconds (4
            % TRs) after stimulus presentation
            freq_bold(end+1:end+lag+1) = actual(j:j+lag,find(vertcat(collated.pRF.id)==voxID));
        end
      avg_bold(i) = mean(freq_bold);
      std_err(i) = std(freq_bold/sqrt(length(freq_bold)));
    end 
    freq_bold = [];
end

% Calculate the baseline bold response 
% We had 2 TRs of baseline after the presentation of every 15 tones 
% We also had 4 TRs of rest before and after the stim presentation 
nBlocks = 10; 
nStimsPerBlock = 15; 
nBaselineBlocks = 2; 
baseline_bold = zeros(nBaselineBlocks,nBlocks); 
paradigm = collated.scan.paradigm.x; 

run=0;
for i=[nStimsPerBlock:nStimsPerBlock+(nBaselineBlocks):length(paradigm)]
    run = run+1 ;
    baseline_bold(:,run) = actual(i+1:i+nBaselineBlocks); 
end
baseline_bold = mean(baseline_bold,"all");

% Calculate the percent change from baseline 
per_change_bold = zeros(1,length(avg_bold));
for i=1:length(per_change_bold)
    per_change_bold(i)= (avg_bold(i)-baseline_bold)/baseline_bold; 
end


% % Z score the avg bold response per freq and set negative z scores = to 0
% avg_bold = zscore(avg_bold);
% % avg_bold(avg_bold < 0) = 0; 

% Simulate the pRF of the voxel (predicted response) using 1D gaussian equation:
% f(x) = exp(-((x-mu).^2)/(2*sigma^2))
all_mus = extractfield(collated.pRF,'mu'); 
all_sigmas = extractfield(collated.pRF,'sigma'); 
ids = extractfield(collated.pRF,'id');
mu = all_mus(find(ids == voxID)); 
sigma = all_sigmas(find(ids == voxID)); 

pred_bold = zeros(1,length(stim));
for i=1:length(pred_bold)
    pred_bold(i) = exp(-((stim(i)-mu).^2)/(2*sigma^2)); 
end

% Normalize by the min and the max
pred_bold_norm = zeros(1,length(pred_bold));
for j=1:length(pred_bold)
    pred_bold_norm(j) = (pred_bold(j) - min(pred_bold)) / (max(pred_bold) - min(pred_bold)); 
end
%% Plot average bold fit to a gaussian 

% Plot average BOLD response 
figure
% hAx=axes; 
% hAx.XScale='log';
% hold all
% yyaxis left
bar(zscore(per_change_bold))
hold on; 
% errorbar(stim, zscore(avg_bold), std_err)

% Fit a sigmoid to the actual data
x = (1:length(stim))';
y = (per_change_bold)';
f = fit(x,y,'gauss1');
plot(f,x,y)
xlabel('Frequency (Hz)')
xticklabels(stim)
ylabel('Percent Signal Change')
title(sprintf('voxID = %d, preferred mu = %0.1f Hz, preferred sigma = %0.1f Hz', voxID, mu, sigma))

%% Plot average bold with predicted response

% Plot average BOLD response 
figure
% yyaxis left
bar(zscore(per_change_bold))
hold on;
ylabel('Percent Bold Change')

% Plot predicted response 
% yyaxis right
plot(zscore(pred_bold_norm),'-r')
legend('actual','pred')
xlabel('Frequency (Hz)')
xticklabels(stim)
title(sprintf('voxID = %d, preferred mu = %0.1f Hz, preferred sigma = %0.1f Hz', voxID, mu, sigma))
legend('BOLD response','predicted pRF')
