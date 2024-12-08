% ASTE Arctic Ocean
% Harry Boutemy, May 2024

clear all

load('AO_2008-2012.mat');

theta=AO.THETA;
salt =AO.SALT ;
% sz=size(theta.data);
% 
% dz=diff(-z_coord); % replace z_coord with -cumsum(dz) for plotting
% dT=diff(theta.data,1,3);
% dS=diff(salt.data,1,3);
% 
% dz_exp=reshape(dz,[1,1,49]);
% 
% dTdz=dT./dz_exp;
% dSdz=dS./dz_exp;

% Compute the gradient in the depth dimension
[~,~,dtheta_dz]=gradient(theta.data,1,1,z_coord);
[~,~,dsalt_dz] =gradient(salt.data,1,1,z_coord);

% THETA
mean_vertical_profile=nanmean(nanmean(dtheta_dz,1),2);

figure;
subplot(1,2,1);plot(squeeze(mean_vertical_profile)',z_coord,'linewidth',2);
set(gca,'yscale','log');xlabel('°C/m');ylabel('depth (m)');
sgtitle('dT/dz');ylim([-6000,-4]);grid on;

regions={'ARC','NAt','NPa','EB','CB','shelf','slope'};
subplot(1,2,2);
for r=1:length(regions)
    
    region_mask=AO.regions.(regions{r});
    region_mask(region_mask==0)=nan; % instead of leaving zeros which would affect the mean
    reg_TH=dtheta_dz.*region_mask;
    
    mean_reg_profile=nanmean(nanmean(reg_TH,1),2);
    
    hold on;
    if strcmp(regions{r},'ARC')
        plot(squeeze(mean_reg_profile)',z_coord','k','linewidth',2);
    else
        plot(squeeze(mean_reg_profile)',z_coord','linewidth',2);
    end
    
end

set(gca,'yscale','log');legend(regions,'location','southeast');
xlabel('°C/m');ylabel('depth (m)');ylim([-6000,-4]);grid on;
hold off;

% SALT
mean_vertical_profile=nanmean(nanmean(dsalt_dz,1),2);

figure;
subplot(1,2,1);plot(squeeze(mean_vertical_profile)',z_coord,'linewidth',2);
set(gca,'yscale','log');xlabel('psu/m');ylabel('depth (m)');
sgtitle('dS/dz');grid on;
ylim([-6000,-4]);

subplot(1,2,2);
for r=1:length(regions)
    
    region_mask=AO.regions.(regions{r});
    region_mask(region_mask==0)=nan; % instead of leaving zeros which would affect the mean
    reg_SLT=dsalt_dz.*region_mask;
    
    mean_reg_profile=nanmean(nanmean(reg_SLT,1),2);
    
    hold on;
    if strcmp(regions{r},'ARC')
        plot(squeeze(mean_reg_profile)',z_coord,'k','linewidth',2);
    else
        plot(squeeze(mean_reg_profile)',z_coord,'linewidth',2);
    end
    
end

set(gca,'yscale','log');legend(regions,'location','southwest');
xlabel('psu/m');ylabel('depth (m)');ylim([-6000,-4]);grid on;
hold off;

