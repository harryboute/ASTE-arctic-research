% ASTE Arctic Ocean
% Harry Boutemy, May 2024

clear all

load('../../AO_2008-2012.mat');

regions={'NAt','NPa','ARC','EB','CB','shelf','slope'};

col1={  'b',  'r',  'g',  'y'};
col2={'-.b','-.r','-.g','-.y'};

d=1;
for i=1:8

figure('Position', [100, 100, 800, 800])
iplot=1;

for idepth=d:d+5

subplot(6,2,iplot); hold on
allplots=[];

% ASTE
for ireg=4:7

clear data mean std
data = AO.diffkr.data(:,:,idepth);
reg=AO.regions.(regions{ireg});
data = data(~isnan(data) & reg);
h=histogram(log10(data), 'FaceAlpha',0.3','FaceColor',col1{ireg-3},'DisplayName',regions{ireg});
allplots=[allplots; h];

ylimits=ylim;
plot([log10(mean(data(:))) log10(mean(data(:)))],[ylimits(1) ylimits(2)],col2{ireg-3},'LineWidth', 1)

end

title(['z=' num2str(z_coord(idepth)) 'm'])
xlabel('log10(m^2/s)')
iplot=iplot+1;
subplot(6,2,iplot); hold on

% mitGCM
for ireg=4:7

clear data mean std
data = AO.kappa_OBS.data(:,:,idepth);
reg=AO.regions.(regions{ireg});
data = data(~isnan(data) & reg);
histogram(log10(data), 'FaceAlpha',0.3','FaceColor',col1{ireg-3},'DisplayName',regions{ireg});

ylimits=ylim;
plot([log10(mean(data(:))) log10(mean(data(:)))],[ylimits(1) ylimits(2)],col2{ireg-3},'LineWidth', 1)

end

title(['z=' num2str(z_coord(idepth)) 'm'])
xlabel('log10(m^2/s)')
iplot=iplot+1;
d=d+1;

end

sgtitle('  diffkr (ASTE)                                          Kappa_-OBS')
ax = axes('Position', [0.5 0.5 0.1 0.1], 'Visible', 'off');
legend(ax, allplots, 'Position', [0.42 0.85 0.1 0.1]);

% saveas(gcf,['figs/diffkr_vs_kppobs_d' num2str(i) '.png']);

end