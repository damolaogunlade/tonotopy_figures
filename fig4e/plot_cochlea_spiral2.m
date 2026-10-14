function plothandle = plot_cochlea_spiral2(segmentVals, colormapname)

% First segment value corresponds to base of cochlea (high frequency) last
% corresponds to apex of cochlea (low frequency)

% Let's resample data to 40 values
temp = segmentVals;
old_samplepoints = linspace(0,1,length(temp));
new_samplepoints = linspace(0,1,40);
segmentValues = interp1(old_samplepoints, temp, new_samplepoints, 'linear');  

if ~exist('colormapname','var')
    colormapname='parula';
end


%% Parameters
%nSegments = 14;
nSegments = length(segmentValues);
turns = 2.75; % number of times human cochlea rotates
thetaMax = turns * 2*pi;
ptsPerSegment = 80;
tubeResolution = 20;

a = 10;
b = -0.15;
heightScale = 0.7; % higher values make spiral taller
tubeRadius_init = 1.7;
tubeTaper = 0.5; % how much tube thins as it ascends

plothandle=figure('color','w','position',[1 1 917 760]); 
hold on; axis equal off;

% If user wants a divergent colormap we will call lbmap function
% Later code assumes the colormap has divergent values centered at zero
if strcmp(colormapname,'diff')
    % LB=flipud(lbmap(256,'RedBlue')); % flip it so blue is for negative(ocean)    
    LB=colormap(slanCM('coolwarm'))  ;  
    colormap(LB)
else
    colormap(colormapname);
end

if strcmp(colormapname,'diff')
    % And we will want to ensure that the zero value is the center of the
    % colormap
    M=abs(max(segmentValues));
    m=abs(min(segmentValues));
    if M-m>=0      
        clim([-m m]);
    else
        clim([-M M]);
    end
    % clim([0,0.1])
    
else
    % clim([min(segmentValues) max(segmentValues)]);
    clim([0,0.4])

end

c=colorbar; 
c.Label.String='pRF Coverage Density';
set(gca, 'fontsize', 16)
lighting gouraud
camlight headlight

thetaEdges = linspace(0, thetaMax, nSegments+1);

for s = 1:nSegments
    
    theta = linspace(thetaEdges(s), thetaEdges(s+1), ptsPerSegment);
    r = a * exp(b * theta);
    
    x = r .* cos(theta);
    y = r .* sin(theta);
    z = heightScale * theta;
    
    tubeRadius = tubeRadius_init * (1 - tubeTaper * theta/thetaMax);
    
    [X,Y,Z] = tubeplot(x,y,z,tubeRadius,tubeResolution);
    
    % Create color data value for this segment
    C = ones(size(X)) * segmentValues(s);
    
    surf(X,Y,Z,C,...
        'EdgeColor','none',...
        'FaceColor','flat');
end

view(3)
camlight headlight
title('Cochleotopic Coverage')
campos([-12.5484 -146.1753   89.2941])
end