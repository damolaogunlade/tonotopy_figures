function [predicted] = plotAvgBold(subject,collated)
%% Plot the BOLD response of a given voxel for each frequency and its predi
stim = collated.scan.funcOf.x;
mus = vertcat(collated.pRF.mu);
ls = [];
avg_bold = zeros(1,length(stim));
std_err = zeros(1,length(stim));

for i = 1:length(stim)
    for j = 1:length(mus)
        %find voxels with preferred frequency equal to the stims
        if abs(mus(j)- stim(i)) < 5
            ls(end+1) = j;
            avg_bold(i) = mean(max(actual(:,ls)));
            std_err(i) = std(max(actual(:,ls)))/length(max(actual(:,ls)));
        end      
    end
    ls = [];
end

figure();
errorbar(stim,zscore(avg_bold),zscore(std_err))
title("Average BOLD per Preferred Frequency");
xlabel("Frequency (Hz)");
ylabel("BOLD (Z-scored)");