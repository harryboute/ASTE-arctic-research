% ASTE Arctic Ocean
% Harry Boutemy, May 2024

clear all

load('AO_2008-2012.mat');
addpath('gsw_functions');

theta=AO.THETA;
salt =AO.SALT ;

% get volume with grid cell (area * depth thichness)
z_thic_expanded = reshape(z_thic, 1, 1, []); % reshape to 1x1x50
vol=AO.area.*z_thic_expanded;
% weights=vol(~isnan(theta.data));
% weights=(weights./sum(weights)).*100;

region_mask=AO.regions.('ARC');
exp_region_mask=repmat(region_mask, [1, 1, 50]);
    
weights=vol(~isnan(theta.data) & exp_region_mask==1);
weights=(weights./sum(weights)).*100;

tmp1=salt.data;
tmp1=tmp1(~isnan(tmp1) & exp_region_mask==1);
tmp2=theta.data;
tmp2=tmp2(~isnan(tmp2) & exp_region_mask==1);

% scatter(tmp1,tmp2);
% xlabel([salt.name ' (' salt.units ')']);
% ylabel([theta.name ' (' theta.units ')']);

% Number of bins for the histogram
numBins = [150, 150];

% Create 2D histogram with weights
edges1 = linspace(min(tmp1), max(tmp1), numBins(1)+1);
edges2 = linspace(min(tmp2), max(tmp2), numBins(2)+1);

[X, Y] = meshgrid(edges1, edges2);
density = gsw_rho(X, Y, 0); % reference density (at surface)

[N, ~, ~] = histcounts2(tmp1, tmp2, edges1, edges2, 'Normalization', 'count');
N_weighted = accumarray([discretize(tmp1, edges1), discretize(tmp2, edges2)], weights, numBins);

% Plot the 2D histogram
figure;
imagesc(edges1, edges2, log10(N_weighted'));
set(gca, 'YDir', 'normal');
colorbar;
caxis([log10(min(N_weighted(:))) log10(max(N_weighted(:)))]); % Adjust color axis for logarithmic scale
hold on;

% Plot contours of constant density
[C,h]=contour(X, Y, density, 'LineColor', 'k'); % Adjust 'LineColor' and other properties as needed
clabel(C, h, 'LabelSpacing', 210); % Adjust LabelSpacing as needed

% Add labels
xlabel([salt.name ' (' salt.units ')']);
ylabel([theta.name ' (' theta.units ')']);
ylabel(colorbar, 'Log10(%volume)');
title('T-S diagram of the ARC region');

% Display the plot
axis xy;
grid on;
hold off;

figure('Position',[100 100 1000 1000]);
sgtitle('T-S diagram');
regions={'NAt','NPa','EB','CB','shelf','slope'};

for r=1:length(regions)
    
    region_mask=AO.regions.(regions{r});
    exp_region_mask=repmat(region_mask, [1, 1, 50]);
    
    weights=vol(~isnan(theta.data) & exp_region_mask==1);
    weights=(weights./sum(weights)).*100;
    
    clear tmp1 tmp2
    tmp1=salt.data(~isnan(salt.data) & exp_region_mask==1);
    tmp2=theta.data(~isnan(theta.data) & exp_region_mask==1);
    
    % Number of bins for the histogram
    numBins = [80, 80];
    
    % Create 2D histogram with weights
    edges1 = linspace(min(tmp1), max(tmp1), numBins(1)+1);
    edges2 = linspace(min(tmp2), max(tmp2), numBins(2)+1);
    
    [X, Y] = meshgrid(edges1, edges2);
    density = gsw_rho(X, Y, 0);
    
    [N, ~, ~] = histcounts2(tmp1, tmp2, edges1, edges2, 'Normalization', 'count');
    N_weighted = accumarray([discretize(tmp1, edges1), discretize(tmp2, edges2)], weights, numBins);
    
    % Plot the 2D histogram
    subplot(3,2,r);
    imagesc(edges1, edges2, log10(N_weighted'));
    set(gca, 'YDir', 'normal');
    colorbar;                 
    caxis([log10(min(N_weighted(:))) log10(max(N_weighted(:)))]); % Adjust color axis for logarithmic scale
    hold on;
    
    % Plot contours of constant density
    [C,h]=contour(X, Y, density, 'LineColor', 'k'); % Adjust 'LineColor' and other properties as needed
    clabel(C, h, 'LabelSpacing', 200, 'FontSize',8); % Adjust LabelSpacing as needed
    
    % Add labels
    xlabel([salt.name ' (' salt.units ')']);
    ylabel([theta.name ' (' theta.units ')']);
    ylabel(colorbar, 'Log10(%volume)');
    title(regions{r},'FontSize',13);
    
    % Display the plot
    axis xy;
    grid on;
    hold off;
    
end