% ASTE Arctic Ocean
% Harry Boutemy, Summer 2024

clear

addpath('../m_map/');  %<---- path to M_Map
load('AO_2008-2012.mat')

% Plot ASTE grid and arctic map
var='ADVr_TH';
field=AO.(var);
depthlvl=2;
tmp=field.data(:,:,depthlvl);
sz=size(tmp);

% symetric log data
tmp=sign(tmp).*log10(1+abs(tmp)); % for data with magnitude >1
% tmp=log10(data) % for data with magnitude <1 

% Plot ASTE grid
% land mask
nan_indices=isnan(tmp);
alpha_data=ones(sz);  % Initialize alpha mask
alpha_data(nan_indices)=0;  % Set alpha to 0 for NaN values

% plot using imagesc
figure('Position',[100 100 1500 400]);
subplot(1,2,1);h=imagesc(1:sz(1),1:sz(2),tmp');colorbar;grid;set(gca,'ydir','normal');
xlabel('grid points');ylabel('grid points');
title('ASTE grid','FontSize',14);ylabel(colorbar,'seafloor depth (m)');
set(h,'AlphaData',alpha_data');

% plot using m_map
m_proj('stereographic','lat',90,'lon',180,'rot',180,'rad',34);
subplot(1,2,2);m_pcolor(AO.lon',AO.lat',tmp');shading flat;m_coast('patch',[0.7 0.7 0.7]);  % Grey coastline
m_grid('xtick',6,'ytick',6,'color','k');colorbar;
title('M_-Map projection','FontSize',14);ylabel(colorbar,'seafloor depth (m)');