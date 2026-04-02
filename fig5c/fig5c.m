%% This script plots the proportion of participants with overlap between the novel map and the PDP PHG

% Calculate hit rates 
lh_adults_hitRate = mean(lh_adults_hits)*100; 
sprintf("adults lh hit rate = %0.2f%%",lh_adults_hitRate)
rh_adults_hitRate = mean(rh_adults_hits)*100;
sprintf("adults rh hit rate = %0.2f%%",rh_adults_hitRate)
lh_kids_hitRate = mean(lh_kids_hits)*100; 
sprintf("kids lh hit rate = %0.2f%%",lh_kids_hitRate)
rh_kids_hitRate = mean(rh_kids_hits)*100; 
sprintf("kids rh hit rate = %0.2f%%",rh_kids_hitRate )

% Plot  
f = figure;
load("plotting_colors.mat")
% colors = [0.1176 0.3059 0.4745; 0.9608 0.3451 0.3059];
b = bar(["LH","RH"],[lh_adults_hitRate, lh_kids_hitRate; rh_adults_hitRate, rh_kids_hitRate]/100');
b(1).FaceColor = adult_colors(1,:);
b(1).FaceAlpha = 1;
b(2).FaceColor = kid_colors(1,:);
b(2).FaceAlpha = 1;
% title(sprintf("PdP_pttg and Novel Tonotopic Map Overlap (n=%i %s n=%i %s)",num_subs(1),ages(1),num_subs(2),ages(2)),"Interpreter","none")
% ylabel("Proportion of Participants With Overlap")
ylim([0,1])
legend(["Adults","Children"])
box off
ax = gca;
ax.FontSize = 14;
set(gca,'TickDir','out','LineWidth',1);

% Change figure size
f.Position(3:4) = [200,350];
