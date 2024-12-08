% ASTE Arctic Ocean
% Harry Boutemy, May 2024

clear all
warning off

load('AO_2008-2012.mat');

var='THETA';  %<---- choose field to look at
field=AO.(var); 
tmp=field.data; 

% symetric log diffusivity values
% tmp(tmp>0)=log10(tmp(tmp>0));
% tmp(tmp<0)=-log10(abs(tmp(tmp<0)));
% field.units=['log_1_0(' field.units ')'];

%plot using m_map
addpath('/home/hboutemy/Documents/MATLAB/toolbox/m_map/');
% Setup m_map for Arctic region
m_proj('stereographic','lat',84,'lon',180,'rot',180,'rad',28);

% Plot the data
figure('Position', [100, 100, 1400, 800]);
sgtitle(field.name);

for depthlvl=2:17
    
    subplot(4,4,depthlvl-1);m_pcolor(AO.lon',AO.lat',tmp(:,:,depthlvl)');shading flat;
        m_coast('patch',[0.7 0.7 0.7]);  % Grey coastline
        m_grid('xtick',6,'ytick',6,'color','k');colorbar;title(['z=' num2str(z_coord(depthlvl)) 'm']);
        caxis([min(tmp(:)), max(tmp(:))]);ylabel(colorbar,field.units,'fontsize',12);
    
end


figure('Position', [100, 100, 1400, 800]);
sgtitle(field.name);

for depthlvl=18:33
    
    subplot(4,4,depthlvl-17);m_pcolor(AO.lon',AO.lat',tmp(:,:,depthlvl)');shading flat;
        m_coast('patch',[0.7 0.7 0.7]);  % Grey coastline
        m_grid('xtick',6,'ytick',6,'color','k');colorbar;title(['z=' num2str(z_coord(depthlvl)) 'm']);
        caxis([min(tmp(:)), max(tmp(:))]);ylabel(colorbar,field.units,'fontsize',12);
    
end

figure('Position', [100, 100, 1400, 800]);
sgtitle(field.name);

for depthlvl=34:48
    
    subplot(4,4,depthlvl-33);m_pcolor(AO.lon',AO.lat',tmp(:,:,depthlvl)');shading flat;
        m_coast('patch',[0.7 0.7 0.7]);  % Grey coastline
        m_grid('xtick',6,'ytick',6,'color','k');colorbar;title(['z=' num2str(z_coord(depthlvl)) 'm']);
        caxis([min(tmp(:)), max(tmp(:))]);ylabel(colorbar,field.units,'fontsize',12);
    
end