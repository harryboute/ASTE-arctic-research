clear

load('AO_struct_2008-2012.mat')

AO.kappa_full.data = AO.KPdiffT1.data + AO.DIFFKrBG.data + AO.GM_Kwz.data; % total vertical  diffusion
AO.kappa_full.units='m^2/s';
AO.kappa_full.name='Total Vertical Diffusion';

AO.DFr_TH_full.data = AO.DFrE_TH.data + AO.DFrI_TH.data;
AO.DFr_TH_full.units='degC.m^3/s';
AO.DFr_TH_full.name='Total Vertical Diffusive Flux of Pot.Temperature';

AO.DFr_SLT_full.data = AO.DFrE_SLT.data + AO.DFrI_SLT.data;
AO.DFr_SLT_full.units='psu.m^3/s';
AO.DFr_SLT_full.name='Total Vertical Diffusive Flux of Salinity';

save('AO_struct_2008-2012.mat','AO','z_coord','z_thic');