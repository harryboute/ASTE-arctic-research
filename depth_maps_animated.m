% ASTE Arctic Ocean
% Harry Boutemy, May 2024

clear
warning off

load('AO_2008-2012.mat');

var='dS_dz';  %<---- choose field to look at
field=AO.(var); 
tmp=field.data; %+AO.DFrI_SLT.data; 

% symetric log diffusivity values
% tmp=sign(tmp).*log10(1+abs(tmp));

%plot using m_map
addpath('../m_map/');
% Setup m_map for Arctic region
m_proj('stereographic','lat',90,'lon',180,'rot',180,'rad',34);

% Initialize video writer
v = VideoWriter('ArcticOceanAnimation.mp4','MPEG-4');
v.FrameRate = 3; % Adjust frame rate as needed
open(v);

cbarlim=[-.05 0];

% Loop through each depth level
for d = 1:length(z_coord)-20
    % Clear previous plot
    clf
    
    % Plot the data
    m_pcolor(AO.lon',AO.lat',tmp(:,:,d)');shading flat;
    cb=colorbar;caxis(cbarlim);
    colormap(flipud(parula));
    % [ticks, tickLabels] = customTicks(cbarlim);set(cb, 'Ticks', ticks, 'TickLabels', tickLabels);
   
    % Add coastlines and grid
    m_coast('patch',[0.7 0.7 0.7]);  % Grey coastline
    m_grid('xtick',6,'ytick',6,'color','k');

    % Title with current depth
    h=title(['z=' num2str(z_coord(d)) 'm']);set(h, 'Position', get(h, 'Position') + [0, 0.05, 0]); % Move title up
    ylabel(cb,field.units);

    % Capture the frame
    frame = getframe(gcf);
    writeVideo(v, frame);
end

% Close the video writer
close(v);