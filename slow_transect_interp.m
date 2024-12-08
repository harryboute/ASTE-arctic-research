function trans = slow_transect_interp(start_lon,start_lat,end_lon,end_lat,AO_lon,AO_lat,n_points,tmp)

% This function is 'relatively slow' (pretty fast for our 360x270 grid) 
% since it scans the whole grid at each iteration to find the nearest 
% grid cell to each transect coordinate point.
% You can try to optimize it but you might loose reliability and can
% encounter issues for transects that span off the grid. 
% (see sample code at the end)

% Convert start and end coordinates to map coordinates
[start_x, start_y] = m_ll2xy(start_lon, start_lat);
[end_x, end_y] = m_ll2xy(end_lon, end_lat);

% Generate points along the transect in map coordinates
x_transect = linspace(start_x, end_x, n_points);
y_transect = linspace(start_y, end_y, n_points);

% Convert back to latitude and longitude
[lon_transect, lat_transect] = m_xy2ll(x_transect, y_transect);
lon_transect(lon_transect>180)=lon_transect(lon_transect>180)-360;

% now i have a transect of latitute and longitude.
% i must find the nearest grid cell for every (lon, lat) couple

trans=NaN(n_points,size(tmp,3));

% Flatten the Arctic Ocean grid
AO_lon_flat = AO_lon(:);
AO_lat_flat = AO_lat(:);
tmp_flat = reshape(tmp, [], size(tmp, 3));

% for each (lon, lat) couple along the transect:
% 1. find the nearest point (lon, lat) on the arctic ocean grid using the Haversine formula
% 2. store the corresponding field cell (1x1xdepth) in the array 'trans'

for k = 1:n_points
    
    % measure distance between grid point and transect point using haversine formula
    dist = haversine(lat_transect(k), lon_transect(k), AO_lat_flat, AO_lon_flat);
    
    % find the minimum distance and its index
    [min_dist, linear_index] = min(dist(:));
    
    % check if nearest grid cell is less than 20km away in case transect goes off the grid
    if min_dist < 20
        trans(k, :) = tmp_flat(linear_index, :);
    end
end

% Detailed for loop:  (don't use, just to understand)
% for k = 1:n_points
%     
%     lat_pt=deg2rad(lat_transect(k));
%     lon_pt=deg2rad(lon_transect(k));
%     
%     min_dist=Inf;
%     nearest_index=0;
%     nearest_jndex=0;
%     
%     for i = 1:sz(1)
%         for j = 1:sz(2)
%             
%             grid_lat=deg2rad(AO.lat(i,j));
%             grid_lon=deg2rad(AO.lon(i,j));
%             
%             dlon=grid_lon-lon_pt;
%             dlat=grid_lat-lat_pt;
%             
%             % Haversine formula
%             a = sin(dlat/2).^2 + cos(lat_pt) * cos(grid_lat) .* sin(dlon/2).^2;
%             c = 2 * atan2(sqrt(a), sqrt(1-a));
%             dist = 6371 * c;
%             
%             if dist < min_dist
%                 min_dist=dist;
%                 nearest_index=i;
%                 nearest_jndex=j;
%             end
%         end
%     end
%     
%     if min_dist<20
%         trans(k,:)=tmp(nearest_index,nearest_jndex,:);
%     end
% end