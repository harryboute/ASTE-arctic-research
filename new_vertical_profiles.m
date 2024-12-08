% ASTE Arctic Ocean
% Harry Boutemy, May 2024

clear all

load('../AO_2008-2012.mat');

var='dT_dz';  %<---- choose a field to look at
field=AO.(var); 

regions={'NAt','NPa','ARC','CB','EB','shelf','slope'};

% Compute regional volume averages:
% get volume with grid cell (area * depth thichness)

z_thic_expanded = reshape(z_thic, 1, 1, []); % reshape to 1x1x50
vol=AO.area.*z_thic_expanded;

surface_averages=nan(length(regions),50);
volume_averages =nan(length(regions),1);

for r=1:length(regions)
    
    region_mask=AO.regions.(regions{r});
    tmp=[];
    weight=[];
    
    for d=1:50 % remove top layer as no data there
        
        vol2d=vol(:,:,d);
        data2d=squeeze(field.data(:,:,d));
        tmp2d=data2d(~isnan(data2d) & region_mask==1);
        
        if ~isempty(tmp2d) % make sure there is some data at this depth for this region 
            
            weight2d=vol2d(~isnan(data2d) & region_mask==1);
            surface_averages(r,d)=sum(tmp2d.*weight2d)/sum(weight2d);
            tmp=[tmp;tmp2d];
            weight=[weight;weight2d];
            % weight=[weight;sum(weight2d)];
            
        end
    end
    
    volume_averages(r)=sum(tmp.*weight)/sum(weight);
    
    % surf_avg=surface_averages(r,:);
    % volume_averages(r)=sum(surf_avg(~isnan(surf_avg)).*weight')/sum(weight);
    
end

figure('Position',[100 100 600 600]);
%subplot('Position',[0.3 0.1 0.4 0.8])
surfCol={'-ko','-ro','-bo','-mo','-go'};
volCol={'-.k','-.r','-.b','-.m','-.g'};
markCol={'k','r','b','m','g'};

hold on
legends = cell(length(regions) - 2, 1);  % Initialize legends cell array
for r=3:length(regions)
    plot(surface_averages(r,:),z_coord,surfCol{r-2},'MarkerFaceColor',markCol{r-2},'DisplayName',regions{r});
    legends{r - 2} = [regions{r}, ' (mean=', num2str(volume_averages(r)*10^4, '%.2f'), ')'];  % Update legend with region name and weighted mean
end

% legends = cell(3, 1);  % Initialize legends cell array
% for r=1:3
%     plot(surface_averages(r,:),z_coord,surfCol{4-r},'MarkerFaceColor',markCol{4-r},'DisplayName',regions{r});
%     legends{r} = [regions{r}, ' (mean=', num2str(volume_averages(r), '%.2f'), ')'];  % Update legend with region name and weighted mean
% end
    
box off;grid off;
h=legend(legends,'AutoUpdate','off');set(h,'Location','North');
ylabel('depth (m)');ylim([-6000 -4]);xlabel(field.units);title(field.name);
set(gca,'yscale','log');

hold on
vector=ones(1,49);
for r=3:length(regions)
    plot(volume_averages(r)*vector,z_coord(1:49),volCol{r-2},'LineWidth',2);
end

% for r=1:3
%     plot(volume_averages(r)*vector,z_coord(1:49),volCol{4-r},'LineWidth',2);
% end

grid on;
% xlim([-500 500]);
% symlog(gca,'x',0);  %<---- modify or comment out as needed


% savefig(['vertical_profiles_Dec2017/' var '_regions.fig']);
% saveas(gcf,['vertical_profiles_Dec2017/' var '_regions.png']);
