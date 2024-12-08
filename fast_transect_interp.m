function trans = fast_transect_interp(start_lon,start_lat,end_lon,end_lat,AO_lon,AO_lat,n_points,tmp)

% This function is uses a k-d tree to interpolate data along a transect
% it finds the nearest grid cell to a sepcific transect coordinate point 
% The k-d tree method is an efficient way to find nearest neighbors in 
% high-dimensional spaces, but it has some limitations when dealing with 
% geospatial data on a spherical surface. The primary issue is that the 
% k-d tree does not account for the curvature of the Earth, which can 
% result in inaccuracies, especially over large distances or near the poles.

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
% i must find the nearest grid cell to each point of the coordinate transect
% let's use a k-d tree! because why not? ;-)  

% Create a matrix of the grid points
grid_points = [AO_lat(:), AO_lon(:)];

% Convert lat/lon to radians
grid_points_rad = deg2rad(grid_points);

% Use a k-d tree for efficient nearest-neighbor searching
MdlKDT = KDTreeSearcher(grid_points_rad);

% Flatten the 3D array tmp to a 2D array
tmp_2d = reshape(tmp, [], size(tmp, 3));

% Initialize the array for storing transect values
trans = NaN(n_points, size(tmp, 3));

% Precompute transect points in radians
transect_points_rad = deg2rad([lat_transect', lon_transect']);

% Number of nearest neighbors to consider in the pre-filtering step
num_neighbors = 10; % modify if needed

for k = 1:n_points
    % Find the nearest neighbors using k-d tree
    idx_candidates = knnsearch(MdlKDT, transect_points_rad(k, :), 'K', num_neighbors);

    % Convert linear indices back to subscripts
    [candidate_indices, candidate_jndices] = ind2sub(size(AO_lat), idx_candidates);

    % Find the exact nearest neighbor using the Haversine distance
    min_dist = Inf;
    nearest_idx = 0;
    
    for n = 1:length(idx_candidates)
        i = candidate_indices(n);
        j = candidate_jndices(n);
        
        % compute haversine distance
        dist = haversine(lat_transect(k), lon_transect(k), AO_lat(i, j), AO_lon(i, j));
        
        % find closest neighbour within the 10
        if dist < min_dist
            min_dist = dist;
            nearest_idx = idx_candidates(n);
        end
    end

    % Store the corresponding field cell in the array only if distance <20km 
    % otherwise we asume it has gone on land so don't save point
    if min_dist < 20
        trans(k, :) = tmp_2d(nearest_idx, :);
    end
end

