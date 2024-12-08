% ASTE Arctic Ocean
% Harry Boutemy, May 2024

clear

load('AO_struct_2008-2012.mat')

regions={'NAt','NPa','ARC','EB','CB','shelf','slope'};

figure('Position',[100 100 1400 400]);

for r=3:length(regions)

    subplot(1,6,r-2);
    
    region_mask=AO.regions.(regions{r});
    region_mask(region_mask==0)=nan; % instead of leaving zeros which would affect the mean
    reg_kappa=AO.kappa_full.data.*region_mask;
    reg_OBS=AO.kappa_OBS.data.*region_mask;
    
    mean_reg_kappa=nanmean(nanmean(reg_kappa,1),2); % average over 3rd dim (i.e. at each depth level)
    mean_reg_OBS=nanmean(nanmean(reg_OBS,1),2);

    plot(squeeze(mean_reg_kappa)',z_coord','linewidth',2);
    hold on;plot(squeeze(mean_reg_OBS)',z_coord','linewidth',2);
    kappa_CTL=10^-6.*ones(1,48);
    ax=gca;defaultColors=ax.ColorOrder;
    hold on;plot(kappa_CTL,z_coord(1:48),'LineWidth',2,'Color',defaultColors(5,:))

    set(gca,'yscale','log');title(regions{r},'FontSize',13);
    xlabel('m^2/s');ylabel('depth (m)');ylim([-6000 -10]);xlim([0 max(mean_reg_OBS)+5*nanstd(mean_reg_OBS)]);
    grid on;

end

% Create common legend
lgd = legend({'kappa_-full (ASTE)','kappa_-OBS','kappa_-CTL (MITgcm)'}, 'FontSize', 13, 'Orientation', 'vertical', 'Location', 'eastoutside');

% Adjust the position of the legend
lgd.Position = [0.83, 0.5, 0.05, 0.1]; % [left, bottom, width, height]

hold off;

% saveas(gcf,'kappa_and_fluxes_plots/kappa_aste_vs_obs_vertprofile.png');