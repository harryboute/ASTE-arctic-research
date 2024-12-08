function [ticks, tickLabels] = customTicks(cbarlim)

% linspace(3) =  cbarlim(2)*2+1 for cbarlim = [-n n]
% linspace(3) =  cbarlim(2)+1   for cbarlim = [0 n]
% linspace(3) = -cbarlim(1)+1   for cbarlim = [-n 0]
% linspace(3) = cbarlim(2)-cbarlim(1)+1 
%                               for cbarlim = [-n -m]  
%                                or cbarlim = [n m]

% Define ticks and labels in scientific notation
ticks = linspace(cbarlim(1), cbarlim(2), cbarlim(2)*2+1); % Adjust the number of ticks as needed
tickLabels = arrayfun(@(x) sprintf('%d0^{%d}', sign(x), abs(x)), ticks, 'UniformOutput', false);
tickLabels = strrep(tickLabels, '00^{0}', '0'); % Replace 10^0 with 0

end

