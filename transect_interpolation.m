% ASTE Arctic Ocean
% Harry Boutemy, May 2024

clear 

addpath('../m_map/');

load('AO_struct_2008-2012.mat');

var='DFrE_TH';  %<---- choose a field to look at
field=AO.(var);
tmp=field.data;

% symetric log diffusivity values
tmp=sign(tmp).*log10(1+abs(tmp));
% tmp(tmp>0)=log10(tmp(tmp>0));

% CANBAR transect coordinates
start_lon=-141;
start_lat=  69;
end_lon  =  25;
end_lat  =  70;
n_points = 300;
trans_xlab='Distance across CANBAR (m)';

% Fram transect coordinates
% start_lon=-22;
% start_lat= 78;
% end_lon  = 17;
% end_lat  = 79;
% n_points = 70;
% trans_xlab='Distance across Fram Strait (m)';

% Beaufort Gyre transect coordinates
% start_lon=-140;
% start_lat=  70;
% end_lon  =-140;
% end_lat  =  79;
% n_points = 70;
% trans_xlab='Distance across Beaufort Gyre (m)';

% Laptev sea transect
% start_lon=130;
% start_lat= 80;
% end_lon  =130;
% end_lat  = 76;
% n_points = 50;
% trns_xlab='Distance across Laptev Sea (m)';

% Now let's interpolate the field along the transect
% Initialize m_map
m_proj('stereographic','lat',90,'lon',180,'rot',180,'rad',34);

% trans=slow_transect_interp(start_lon,start_lat,end_lon,end_lat,AO.lon,AO.lat,n_points,tmp);
trans=fast_transect_interp(start_lon,start_lat,end_lon,end_lat,AO.lon,AO.lat,n_points,tmp);

% plot transect on fixed depth 2d map
depthlvl=2;  % flux data starts at 15m depth i.e. depth level 2
data2d=tmp(:,:,depthlvl);

figure('Position',[100 100 1200 400]);
cbarlim=[-4 4];

subplot(1,3,1); %m_proj('stereographic','lat',90,'lon',180,'rot',180,'rad',24); 
m_pcolor(AO.lon',AO.lat',data2d');shading flat;m_coast('patch',[0.7 0.7 0.7]);  % Grey coastline
m_grid('xtick',6,'ytick',6,'color','k');cb=colorbar;colormap(customMap); 
h=title(['z=' num2str(z_coord(depthlvl)) 'm']);set(h, 'Position', get(h, 'Position') + [0, 0.1, 0]); % Move title up
m_line([start_lon, end_lon], [start_lat, end_lat], 'color', 'k', 'linewidth', 2);
ylabel(cb,field.units);caxis(cbarlim);
m_text(end_lon, end_lat, 'CANBAR', 'color', 'k', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

% Set colorbar ticks and labels
[ticks, tickLabels] = customTicks(cbarlim);
set(cb, 'Ticks', ticks, 'TickLabels', tickLabels);

% plot vertical profile along transect
trans_dist_deg=haversine(start_lat,start_lon,end_lat,end_lon); % or distance(start_lat,start_lon,end_lat,end_lon,"greatcircle")
trans_dist_km=deg2rad(trans_dist_deg)*6371;
trans_dist=linspace(0,trans_dist_km,n_points);

subplot(1,3,2:3);pcolor(trans_dist, z_coord(depthlvl:50), trans(:,depthlvl:50)'); 
shading flat;cb=colorbar;grid;set(gca,'yscale','log','Color',[0.7 0.7 0.7]);
xlabel(trans_xlab);title(field.name);ylabel('depth (m)');ylabel(cb, field.units);
caxis(cbarlim);

% Set colorbar ticks and labels
[ticks, tickLabels] = customTicks(cbarlim);
set(cb, 'Ticks', ticks, 'TickLabels', tickLabels);

% saveas(gcf,['kappa_and_fluxes_plots/' var '.png']);
