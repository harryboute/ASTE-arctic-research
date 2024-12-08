function customColormap = customMap()
% Define the number of colors for the colormap
numColors = 256;

% Define the maximum shades of blue and red
blue_max = [0, 0.1, .7];  % Darker blue
red_max = [.6, 0.1, 0.1];   % Darker red

% Define the colors for the negative side (blue_max to white)
negColors = [linspace(blue_max(1), 1, numColors/2)', ...
             linspace(blue_max(2), 1, numColors/2)', ...
             linspace(blue_max(3), 1, numColors/2)'];

% Define the colors for the positive side (white to red_max)
posColors = [linspace(1, red_max(1), numColors/2)', ...
             linspace(1, red_max(2), numColors/2)', ...
             linspace(1, red_max(3), numColors/2)'];

% Combine the negative and positive colors
customColormap = [negColors; posColors];
end

