function d = haversine(lat1, lon1, lat2, lon2)
    % Haversine formula to compute distance between two points on the Earth
    % coordinates in DEGREES, longitudes are negative west of the prime meridian
    R = 6371; % Earth's radius in kilometers
    dlat = deg2rad(lat2 - lat1);
    dlon = deg2rad(lon2 - lon1);
    a = sin(dlat/2).^2 + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) .* sin(dlon/2).^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    d = R * c; % haversine distance
end

