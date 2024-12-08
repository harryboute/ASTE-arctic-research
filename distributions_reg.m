% ASTE Arctic Ocean
% Harry Boutemy, May 2024

clear

load('../../AO_2008-2012.mat')

regions={'NAt','NPa','ARC','EB','CB','shelf','slope'};

figure('Position',[100 100 1400 400]);

numbins=20;
col1={  'b',  'r',  'g',  'y'};
col2={'-.b','-.r','-.g','-.y'};

subplot(1,2,1);
allplots=[];

for r=4:length(regions)
    
    region_mask=AO.regions.(regions{r});
    region_mask(region_mask==0)=nan;
    reg_diffkr=AO.diffkr.data.*region_mask;
    reg_diffkr=reg_diffkr(~isnan(reg_diffkr));
    
    hold on;
    h=histogram(log10(reg_diffkr),numbins,'FaceAlpha',0.3','FaceColor',col1{r-3},'DisplayName',regions{r});
    allplots=[h,allplots];

    plot([log10(mean(reg_diffkr(:))) log10(mean(reg_diffkr(:)))],[0 8*10^4],col2{r-3},'LineWidth',2);
    
end

legend(allplots);title('diffkr (ASTE)');xlabel('log10(m^2/s)');ylabel('Number of cells');
hold off;
allplots=[];
subplot(1,2,2);

for r=4:length(regions)
    
    region_mask=AO.regions.(regions{r});
    region_mask(region_mask==0)=nan;
    reg_OBS=AO.kappa_OBS.data.*region_mask;
    reg_OBS=reg_OBS(~isnan(reg_OBS));

    hold on;
    h=histogram(log10(reg_OBS),numbins,'FaceAlpha',0.3','FaceColor',col1{r-3},'DisplayName',regions{r});
    allplots=[h,allplots];

    plot([log10(mean(reg_OBS(:))) log10(mean(reg_OBS(:)))],[0 11*10^4],col2{r-3},'LineWidth',2);
end

legend(allplots);title('kappa_-OBS');xlabel('log10(m^2/s)');ylabel('Number of cells');
