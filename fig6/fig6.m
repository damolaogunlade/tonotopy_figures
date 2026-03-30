% This script plots the correlation between pRF bandwidth and the auditory
% filter estimated by the frequency discrimination task in adults and kids

% List of ages
ages = ["adults","kids"];

% List of frequencies
freqs = [88	125	150 177	250	354	500	707	1000	1414	2000	2828	4000	5657	8000];
freq_conds = [150 2000 4000];

% Create frequency specific color maps
map_150Hz = [179, 224, 255;
    128, 204, 255;
    77, 184, 255;
    26, 163, 255;
    0, 138, 230;
    0, 114, 189]/255;

map_2000Hz = [252, 238, 232;
    247, 205, 187;
    242, 171, 141;
    236, 138, 95;
    231, 104, 50;
    217, 83, 25]/255;

map_4000Hz = [253, 247, 231;
    249, 230, 184;
    245, 213, 137;
    242, 196, 90;
    238, 179, 43;
    237, 177, 32]/255;

maps = {map_150Hz; map_2000Hz;map_4000Hz};

for i = 1:length(ages)

    age = ages(i);

    % Load data
    cd("/Volumes/gomez/data/tonotopy_game/code/figures_code/fig6")
    load(sprintf("%s_data.mat",age))

    % Plotting variables
    smoothing_factor = 1.5;
    contour_thresh = 1;

    % Create subplot
    sp = subplot(1,2,i);
    
    % 150 Hz

    % Plot contour for each frequency
    hold on;
    % ax1 = axes;
    % hold(ax1,'on')

    x = groupData_clean(1,:,1)';
    y = groupData_clean(1,:,2)';

    % Define grid
    xgrid=linspace(0,1);
    ygrid=linspace(0,100);
    [x1,y1] = meshgrid(xgrid, ygrid);

    % Perform kernel density estimation
    xi = [x1(:) y1(:)];
    [f,ep]=ksdensity([x y],xi,"Bandwidth",[0.0445782630251027,3.86741530813904]*smoothing_factor);

    % format data in matrix for contourf and plot
    X = reshape(ep(:,1),length(xgrid),length(ygrid));
    Y = reshape(ep(:,2),length(xgrid),length(ygrid));
    Z = reshape(f,length(xgrid),length(ygrid));

    % Set a threshold
    muZ = mean(Z(:));
    sigmaZ = std(Z(:));
    threshold = muZ + contour_thresh*sigmaZ;
    Z(Z < threshold) = NaN;

    % Plot
    ax1 = gca;
    [c,h] = contourf(ax1,X,Y,Z,10,'LineStyle','none','HandleVisibility','off');
    h.FaceAlpha = 0.75;
    xtickformat('%.1f')
    xlabel("Normalized pRF Coverage","FontSize",14)
    ylabel("Notched Noise Threshold (dB)","FontSize",14)
    set(ax1,'TickDir','out');
    set(ax1,'LineWidth', 1)
    colormap(ax1,map_150Hz)
    freezeColors

    % 2000 Hz
    ax2 = axes('Position',ax1.Position,...
        'Color','none');
    % Hide duplicate ticks
    axis off
    hold(ax2,'on')
    x = groupData_clean(2,:,1)';
    y = groupData_clean(2,:,2)';

    % Define grid
    xgrid=linspace(0,1);
    ygrid=linspace(0,100);
    [x1,y1] = meshgrid(xgrid, ygrid);

    % Perform kernel density estimation
    xi = [x1(:) y1(:)];
    [f,ep]=ksdensity([x y],xi,"Bandwidth",[0.0445782630251027,3.86741530813904]*smoothing_factor);

    % format data in matrix for contourf and plot
    X = reshape(ep(:,1),length(xgrid),length(ygrid));
    Y = reshape(ep(:,2),length(xgrid),length(ygrid));
    Z = reshape(f,length(xgrid),length(ygrid));

    % Set a threshold
    muZ = mean(Z(:));
    sigmaZ = std(Z(:));
    threshold = muZ + contour_thresh*sigmaZ;
    Z(Z < threshold) = NaN;

    % Plot
    [c,h] = contourf(ax2,X,Y,Z,10,'LineStyle','none');
    h.FaceAlpha=0.5;
    xtickformat('%.1f')
    xlabel("Normalized pRF Coverage","FontSize",14)
    ylabel("Notched Noise Threshold (dB)","FontSize",14)
    colormap(ax2,map_2000Hz)
    freezeColors

    % 4000 Hz
    ax3 = axes('Position',ax1.Position,...
        'Color','none');
    % Hide duplicate ticks
    axis off

    hold(ax3,'on')
    x = groupData_clean(3,:,1)';
    y = groupData_clean(3,:,2)';

    % Define grid
    xgrid=linspace(0,1);
    ygrid=linspace(0,100);
    [x1,y1] = meshgrid(xgrid, ygrid);

    % Perform kernel density estimation
    xi = [x1(:) y1(:)];
    [f,ep]=ksdensity([x y],xi,"Bandwidth",[0.0445782630251027,3.86741530813904]*smoothing_factor);

    % format data in matrix for contourf and plot
    X = reshape(ep(:,1),length(xgrid),length(ygrid));
    Y = reshape(ep(:,2),length(xgrid),length(ygrid));
    Z = reshape(f,length(xgrid),length(ygrid));

    % Set a threshold
    muZ = mean(Z(:));
    sigmaZ = std(Z(:));
    threshold = muZ + contour_thresh*sigmaZ;
    Z(Z < threshold) = NaN;

    % Plot
    [c,h] = contourf(ax3,X,Y,Z,10,'LineStyle','none');
    h.FaceAlpha = 0.5;
    xtickformat('%.1f')
    xlabel("Normalized pRF Coverage","FontSize",14)
    ylabel("Notched Noise Threshold (dB)","FontSize",14)
    colormap(ax3,map_4000Hz)
    freezeColors
    linkaxes([ax1 ax2 ax3])

    % Scatter plot
    for c = 1:length(cochleo_coverage)
        % Plot
        s = scatter(groupData_clean(c,:,1), groupData_clean(c,:,2),50,RGB(c,:),'filled');
        hold on

    end


    %% Visualization

    % Set axes limits
    xlim([0,0.8])
    ylim([25,85])

    % Set axes labels
    xlabel("Normalized pRF Coverage","FontSize",14)
    ylabel("Notched Noise Threshold (dB)","FontSize",14)
    age_char = char(age);
    if strcmp(age,"kids")
        age_char = 'children';
    end
    % title(sprintf("%s (n=%i) %s Auditory Core ",strcat(upper(age_char(1)),lower(age_char(2:end))),length(completeSub_idx),hemi_formatted),"Interpreter","none")
    title(sprintf("%s Primary Core ",strcat(upper(age_char(1)),lower(age_char(2:end)))),"Interpreter","none")

    % Add text
    text(0.6,82,"150 Hz","Color",RGB(1,:),"FontSize",14)
    text(0.6,76,"2000 Hz","Color",RGB(2,:),"FontSize",14)
    text(0.6,70,"4000 Hz","Color",RGB(3,:),"FontSize",14)
    text(0.05,30,sprintf("r=%0.2f",r(1,2)),"FontSize",14)

    % Other formatting
    ax = gca;
    set(ax,"FontSize",14)
    ax.LineWidth = 4;
    set(ax,'TickDir','out');

end