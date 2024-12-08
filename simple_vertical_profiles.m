% ASTE Arctic Ocean
% Harry Boutemy, May 2024

clear

load('AO_struct_2008-2012.mat')

var='kappa_full';
field=AO.(var);
tmp=field.data;

mean_vertical_profile=nanmean(nanmean(tmp,1),2); % average over 3rd dim (i.e. at each depth level)

figure('Position',[100 100 800 400]);
subplot(1,2,1);plot(squeeze(mean_vertical_profile)',z_coord,'linewidth',2);
set(gca,'yscale','log');xlabel(field.units);ylabel('depth (m)');
sgtitle(field.name);ylim([-6000,-15]);%xlim([-50 2000]);
grid on;

regions={'NAt','NPa','ARC','EB','CB','shelf','slope'};
subplot(1,2,2);
for r=3:length(regions)
    
    region_mask=AO.regions.(regions{r});
    region_mask(region_mask==0)=nan; % instead of leaving zeros which would affect the mean
    reg_tmp=tmp.*region_mask;
    
    mean_reg_profile=nanmean(nanmean(reg_tmp,1),2); % average over 3rd dim (i.e. at each depth level)
    
    hold on;
    if strcmp(regions{r},'ARC')
        plot(squeeze(mean_reg_profile)',z_coord','k','linewidth',2);
    else
        plot(squeeze(mean_reg_profile)',z_coord','linewidth',2);
    end
    
end

set(gca,'yscale','log');legend(regions{3:end},'location','southeast');
xlabel(field.units);ylabel('depth (m)');ylim([-6000,-15]);%xlim([-50 1200]);
grid on;hold off;

% saveas(gcf,['kappa_and_fluxes_plots/' var '_vertprofile.png']);