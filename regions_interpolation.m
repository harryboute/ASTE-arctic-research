% ASTE Arctic Ocean
% Harry Boutemy, May 2024

clear all

% Path to MIT regions and grid
load('../mitGCM/regional_logicals.mat'); 
load('../mitGCM/mgrid.mat');

% Path to AO structure
AO_struct_path='../AO_2008-2012.mat'; 
load(AO_struct_path);
sz=size(AO.lon);

mitgcm_coord=[mgrid.lat(:), mgrid.lon(:)];
AO_coord=[AO.lat(:), AO.lon(:)];

% Use a k-d tree for efficient nearest-neighbor searching
MdlKDT = KDTreeSearcher(mitgcm_coord);

% Find the nearest neighbor in the original grid for each point in the new grid
idx=knnsearch(MdlKDT,AO_coord);

reg = {ii_NAt, ii_ARC, ii_CB, ii_EB, ii_shelf, ii_slope};
reg_title = {' NAt','ARC', 'CB', 'EB', 'shelf', 'slope'};

for i=1:length(reg)
    tmp=reg{i}(:,:,1);tmp=tmp(:);
    eval([reg_title{i} '=reshape(double(tmp(idx)), sz(1), sz(2));']);
    eval([reg_title{i} '=imclose(' reg_title{i} ',strel(''disk'', 1));']); % to smoothen region boundaries
end

% add North Pacific Ocean
NPa=zeros(sz);
NPa(ARC==0 & (AO.lon<-120 | AO.lon>120))=1;

% remove NPa from NAt
NAt(NPa==1)=0;

% Save regions
% AO.regions.NAt = NAt;
% AO.regions.NPa = NPa;
% AO.regions.ARC = ARC;
% AO.regions.CB = CB;
% AO.regions.EB = EB;
% AO.regions.shelf = shelf;
% AO.regions.slope = slope;
% save(AO_struct_path,'AO','z_coord','z_thic');

% Plot regions MITgcm vs interpolated on ASTE
REG=zeros(sz);
REG(NPa==1)  =1;
REG(NAt==1)  =2;
REG(CB==1)   =3;
REG(EB==1)   =4;
REG(shelf==1)=5;
REG(slope==1)=6;
REG(REG==0 | isnan(AO.THETA.data(:,:,1)))  =nan;

figure('Position',[100 100 1400 600]); 

addpath('/home/hboutemy/Documents/MATLAB/toolbox/m_map/');
subplot(1,2,2);m_proj('stereographic','lat',90,'lon',180,'rot',180,'rad',34); 
m_pcolor(AO.lon',AO.lat',REG');shading flat;m_coast('patch',[0.7 0.7 0.7]);  % Grey coastline
m_grid('xtick',6,'ytick',6,'color','k');t=title('ASTE regions interpolated from mitGCM');
set(t, 'Position', get(t, 'Position') + [0, 0.05, 0]); % Move title up
colorbar('Ticks', 1:6, 'TickLabels', {'NPa', 'NAt', 'CB', 'EB', 'shelf', 'slope'});

ii_reg=zeros(size(ii_ARC(:,:,1)));
ii_reg(ii_NAt(:,:,1)==1)  =2;
ii_reg(ii_CB(:,:,1)==1)   =3;
ii_reg(ii_EB(:,:,1)==1)   =4;
ii_reg(ii_shelf(:,:,1)==1)=5;
ii_reg(ii_slope(:,:,1)==1)=6;
ii_reg(ii_reg==0)         =1;

subplot(1,2,1);m_pcolor(mgrid.lon',mgrid.lat',ii_reg');shading flat;m_coast('patch',[0.7 0.7 0.7]);  % Grey coastline
m_grid('xtick',6,'ytick',6,'color','k');t=title('mitGCM regions');set(t, 'Position', get(t, 'Position') + [0, 0.05, 0]); % Move title up
colorbar('Ticks', 1:6, 'TickLabels', {'', 'NAt', 'CB', 'EB', 'shelf', 'slope'});