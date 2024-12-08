Harry Boutemy, Summer 2024

data:   ASTE_R1 reanalysis model output produced by An Nguyen
region: Arctic Ocean (extended)
tiles:  5:17,19,21,23,24,27 (Nordic Seas, Baffin Bay, Arctic Ocean, Bering Strait)
files:  NetCDF files in nctiles_monthly (stored by field & by tile) and in nctiles_grid (grid info stored by tile)

Original package and nc files downloaded from https://arcticdata.io/data/10.18739/A2CV4BS5K/.
matlab_tools/ is the starter package to start analysing ASTE_R1 output data.
    it contains ASTE_mlibrary that has many important functions.

This package contains:
   * Original ASTE package
        matlab_tools/        (original scripts and hboutemy scripts)
        nctiles_grid/        (ASTE grid info for all tiles)
        nctiles_monthly/     (monthly fields for all tiles) 
   * New diffusivity and flux data sent by An Nguyen
        diags_binary_diffkr/ (binary data for tiles 5:17,19,21)
   * From MITgcm package: mgrid.mat, regional_logicals.mat and Kappa_OBS.mat
   * Functions from TEOS-10 GSW toolbox
   * An Arctic Ocean structure called 'AO_struct_2008-2012.mat' with all mixing fields and for tiles 5:17,19,21 (Arctic Ocean + Nordic Seas)
   * Functions and scripts by Harry Boutemy from summer 2024 internship with Professor Stephanie Waterman

Look at slides: ASTE, ASTE Story and Final Slides, for plots outputed by the following scripts

Functions:
1. array_info.m - displays some info for array of any size/dimension
2. merge_tiles_arctic_ocean.m - reads nc files for a given field and merge the tiles to output a single 4D array
        function modified from merged_tiles_nordic_seas_tracers.m in the original ASTE matlab_tools/example_NordicSeas folder
        Land mask is applied directly to each tile array as NaN
        uses nctile2aste_v2.m function from original ASTE_mlibrary package 
        the original nctiles2aste_v2.m was modified to handle fields with no time dimension
3. customMap.m - custom colorbar to plot field with both negative and positive values 
        negative is blue, zero is white, positive is red
4. customTicks.m - custom colorbar ticks for logged10 values 
5. haversine.m - computes haversine distance between 2 points given start and end coordinates
6. fast_transect_interp.m - uses KDtree search to extract a transect (vertical profile) of data given start and end coordinates
7. slow_transect_interp.m - loops over whole grid to find each nearest point to transect. More relibable but slower. 
        fast version will return almost exactly the same profile as the slower, more relibale version (ie fast is good enough)
8. symlog.m - function by Robert Perrotta used here to symlog x axis in vertical profiles.       

Scripts: 
1.  data_extraction.m - to extract and 2d plot ASTE fields
        select grid info or field (with specified depth and time) to extract. 
        uses merge_tiles_arctic_ocean.m to produce an array of the full AO grid.
        create and save an Arctic Ocean Structure with all the extracted fields and grid info.
        if any field is calculated in another script, you can add it to the original structure and save it again.
        WARNING: if large iz and itime, build the structure one field at a time to not kill MATLAB
        NOTE: an averaged 2008-2012 structure and a dec2017 structure with all mixing fields is provided.
2.  spatial_variation.m - plot a 2D AO map for some field using imagesc and M_Map
        plot AO grid with imagesc once to see what the raw array looks like then prioritize using 
        the M_Map package with a stereogeographic projection (https://www.eoas.ubc.ca/~rich/map.html).
4.  depth_maps_animated.m - look at each depth of a field 
5.  regions_interpolation.m - creates 2D regions interpolated from MITgcm and adding North Pacific
6.  transects_interpolation.m - plots a transects and vertical profile for some field
        uses fast_transect_interp.m to extract a vertical profile along a transect
        start and end coordinates for any transect can be found using google earth with grid on
        already contains coordinates for 4 transects: Fram Strait, CANBAR, Beaufort Gyre and Laptev Sea
        for each transect, define the number of points to be interpolated by thinking approximatly how many points does the transects cover on ASTE grid
        can set: cbarlim - colorbar limits
                 colormap - use customMap.m for fields with botb positive and negative values
                 colorbar ticks - use customTicks.m for logged10 data
7.  derivatives.m - calculate and plot gradients of Temperature and Salinity
        No need to use since sent by An Nguyen in ASTE rerun
8.  stratification.m - computes and saves density (RHO) and stratification (N2) with TEOS-10 GSW toolbox functions found in gsw_functions
9.  TSdiagram.m - plots Temperature-Salinity diagram of the entire grid and of each region. uses gsw_rho.m for density contours
10. new_vertical_profiles.m - plots vertical profiles (depth mean and full mean) weighted by volume of each region
11. simple_vertical_profiles.m - non-weighted
12. distrib2.m - plots distribution (histogram) of regions at each depth

ASTE vs OBS: 
13. interp3D.m - interpolate MITgcm Kappa_OBS on ASTE grid
        The next scripts use Kappa_OBS interpolated on ASTE grid
14. vertical_profiles_reg.m - vertical profile for each region of kappa_CTL, kappa_OBS and diffkr (non-weighted)
15. distributions_reg.m - full distribution of regions for kappa_OBS and diffkr 
16. Copy_of_diffkr_vs_kppobs.m - distribution of regions per depth for kappa_OBS and diffkr

Kappa and Diffusive fluxes (from meeting with An Nguyen):
17. extract_kappa_binary.m - extract and merge tiles
18. readbin.m      - function given by An Nguygen used in extract_kappa_binary.m
NOTE: use only new diffusivities and fluxes sent in binary files by An Nguyen from ASTE rerun
Look at emails between An, Stephanie and me to get a better undertanding of diffuivities and fluxes


From meeting with An: (read this with readme.txt from diags_binary_diffkr/ open)

KPdiffT1 (kpp diffusion) + DIFFKrBG (background) + GM_Kwz (redi) = Total vertical diffusion
plot these with depth

DBgr_TH (vertical diff from background) + DKpr_TH (... from kpp) + DReI_TH (... from redi) = DFrI_TH (total implicit)

Explicit DFrE_TH is only from redi. Compare DFrE_TH (explicit) with DReI_TH (redi of implicit)

Full flux is still DFrE_TH + DFrI_TH
Implicit is across density boundary projection on vertical, explicit is along density boundary projection on vertical. This is why we add them






