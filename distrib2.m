% ASTE Arctic Ocean
% Harry Boutemy, May 2024

clear all

load('../AO_2008-2012.mat');

var='diffkr';  %<---- choose a field to look at
field=AO.(var);  
regions={'NAt','NPa','ARC','EB','CB','shelf','slope'};

tmp=field.data;

% Define a symlog transformation function (use for diffusivity fields only)
symlog10 = @(x) sign(x) .* log10(1 + abs(x));


col1={  'b',  'r',  'g',  'y'};
col2={'-.b','-.r','-.g','-.y'};

d=2;
for i=1:3

figure('Position', [100, 100, 1200, 800])
iplot=2;

for idepth=d:d+14

subplot(4,4,iplot); hold on
allplots=[];

for ireg=4:7

clear data mean std
data = tmp(:,:,idepth);
reg=AO.regions.(regions{ireg});
data = data(~isnan(data) & reg);
h=histogram(symlog10(data), 'FaceAlpha',0.3','FaceColor',col1{ireg-3},'DisplayName',regions{ireg});
allplots=[allplots; h];

ylimits=ylim;
plot([symlog10(mean(data(:))) symlog10(mean(data(:)))],[ylimits(1) ylimits(2)],col2{ireg-3},'LineWidth', 1)

end

iplot=iplot+1;
d=d+1;
title(['z=' num2str(z_coord(idepth)) 'm'])
xlabel(field.units)

end

sgtitle(field.name)
ax = axes('Position', [0.5 0.5 0.1 0.1], 'Visible', 'off');
legend(ax, allplots, 'Position', [0.2 0.8 0.1 0.1]);

%savefig(['distributions_Dec2017/' var '_distributions.fig']);
%saveas(gcf,['distributions_Dec2017/' var '_d' num2str(i) '.png']);

end