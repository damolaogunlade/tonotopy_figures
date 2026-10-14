%% This script plots example staircasing in adult and child

% Load plotting colors
load("plotting_colors.mat")

% --- Adult ---
f = openfig("adult_150_Hz_Notched","invisible");

% Extract data 
l_adult = findobj(f,'Type','Line');
x_adult = l_adult.XData;
y_adult = l_adult.YData;

% --- Kid ---
f2 = openfig("kid_150_Hz_Notched","invisible");

% Extract data 
l_kid = findobj(f2,'Type','Line');
x_kid = l_kid.XData;
y_kid = l_kid.YData;

% Plot
figure;
plot(x_adult,y_adult,'Color',adult_colors(1,:),'LineWidth',2)
hold on; 
plot(x_kid,y_kid,'Color',kid_colors(2,:),'LineWidth',2)
xlim([1,20])
xlabel("Trial")
ylabel("dB")
legend({'Adult','Child'},'FontSize',10)

% Visualization
box off
ax = gca;
ax.FontSize = 14;
set(gca,'TickDir','out');
f = gcf;
f.Position(3:4)= [200 200];
ax.LineWidth = 1; 
