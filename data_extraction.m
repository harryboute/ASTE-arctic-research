% ASTE Arctic Ocean
% Harry Boutemy, May 2024

clear 
warning off

addpath('../ASTE_mlibrary/');			%<-- modify absolute path as needed
addpath('../ASTE_mlibrary/gcmfaces_mod/');	%<-- modify absolute path as needed 

%the most important structure needed is the tile, located at
dirdiags_nc='../../';				%<-- modify absolute path as needed
dirgrid_nc='../../nctiles_grid/';			%<-- modify absolute path as needed

%the most important structure needed is the tile, located inside ASTE_mlibrary and also inside nctiles_grid
global tiles
load('../ASTE_mlibrary/tiles_params.mat','tiles');	%tiles

%tiles = 
%  struct with fields:
%      tot: 45
%      wet: 29
%     list: [45×2 double]
%    tsize: [90 90]
%    fsize: [270 1350 1]
%      nfx: [270 0 270 180 450]
%      nfy: [450 0 270 270 270]
%     mask: {[270×450 double]  []  [270×270 double]  [180×270 double]  [450×270 double]}
%      lat: 13.7500
%    field: []
%    index: {1×29 cell}

%for the Nordic Seas, these are the tiles, which are HARDCODED in the function, leave as comment out here for info:
%itile=[5 6 7 8 11 14];	%tile 5-7 on face1 tile 8,11,14 on face3
%flag_aste=0;		%1 to put output into full ASTE domain compact size, 0 to leave as individual tiles (to save memory)

%Pick some zlevels and time slices as example:
iz=1:50;		% entire depth column
% itime=192;      % Dec 2017
itime=73:132;   % Jan 2008 to Dec 2012

AO=[];	%Arctic Ocean structure

%first, we test reading in grid, example as 'Depth','hFacC'. For grid (flag_field = -1), itime does not matter.
flag_field=-1;
AO.depth=merge_tiles_arctic_ocean({'Depth'},dirgrid_nc,1,itime,flag_field);%iz=1 only for 2D field
AO.lon=merge_tiles_arctic_ocean({'XC'},dirgrid_nc,1,itime,flag_field);%iz=1 only for 2D field
AO.lat=merge_tiles_arctic_ocean({'YC'},dirgrid_nc,1,itime,flag_field);%iz=1 only for 2D field
AO.area=merge_tiles_arctic_ocean({'RAC'},dirgrid_nc,1,itime,flag_field);%iz=1 only for 2D field
% AO.hFacC=merge_tiles_arctic_ocean({'hFacC'},dirgrid_nc,iz,itime,flag_field);%iz multiple for 3D field

% now read in time-dependent (flag_field = 0), use THETA as example
% flag_field=0;
% AO.theta=merge_tiles_arctic_ocean({'THETA'},[dirdiags_nc 'nctiles_monthly/'],iz,itime,flag_field);

%-------- without attributes --------------------------------%
% flag_field=0;
% AO.DFrE_SLT=merge_tiles_arctic_ocean({'DFrE_SLT'},[dirdiags_nc 'nctiles_monthly/'],iz,itime,flag_field);
% AO.DFrE_TH=merge_tiles_arctic_ocean({'DFrE_TH'},[dirdiags_nc 'nctiles_monthly/'],iz,itime,flag_field);
% AO.DFrI_SLT=merge_tiles_arctic_ocean({'DFrI_SLT'},[dirdiags_nc 'nctiles_monthly/'],iz,itime,flag_field);
% AO.DFrI_TH=merge_tiles_arctic_ocean({'DFrI_TH'},[dirdiags_nc 'nctiles_monthly/'],iz,itime,flag_field);
% AO.KPPg_SLT=merge_tiles_arctic_ocean({'KPPg_SLT'},[dirdiags_nc 'nctiles_monthly/'],iz,itime,flag_field);
% AO.KPPg_TH=merge_tiles_arctic_ocean({'KPPg_TH'},[dirdiags_nc 'nctiles_monthly/'],iz,itime,flag_field);
% AO.logdiffkr=merge_tiles_arctic_ocean({'logdiffkr'},[dirdiags_nc 'nctiles_monthly/'],iz,[],flag_field);

%-------- with attributes 'long_name' and 'units' and time averaged -----------%
flag_field=0;
varnames={'SALT','THETA'};
for i=1:length(varnames)
    varName=varnames{i};
    % AO.(varName).data=merge_tiles_arctic_ocean(varName,[dirdiags_nc 'nctiles_monthly/'],iz,itime,flag_field);
    tmp=merge_tiles_arctic_ocean(varName,[dirdiags_nc 'nctiles_monthly/'],iz,itime,flag_field);
    AO.(varName).data=mean(tmp,4); % average over time
    AO.(varName).name=ncreadatt([dirdiags_nc 'nctiles_monthly/' varName '/' varName '.0008.nc'],varName,'long_name');
    AO.(varName).units=ncreadatt([dirdiags_nc 'nctiles_monthly/' varName '/' varName '.0008.nc'],varName,'units');
end

% kappa effective has no time dimension
varName='logdiffkr';
itime=[];
AO.(varName).data=merge_tiles_arctic_ocean(varName,[dirdiags_nc 'nctiles_monthly/'],iz,itime,flag_field);
AO.(varName).name=ncreadatt([dirdiags_nc 'nctiles_monthly/' varName '/' varName '.0008.nc'],varName,'long_name');
AO.(varName).units=ncreadatt([dirdiags_nc 'nctiles_monthly/' varName '/' varName '.0008.nc'],varName,'units');

ncload([dirgrid_nc 'GRID.0008.nc'],'RC','DRF');
z_coord=RC;
z_thic=DRF;
clear RC DRF;

% Save Arctic Ocean Structure 
save('AO_struct_2008-2012.mat','AO','z_coord','z_thic');
