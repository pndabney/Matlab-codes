function [XD,YD]=inrange(x,y,xrange)
% [XD,YD] = inrange(x,y,xrange)
%
% Obtains data and corresponding x-axis array in the specified range of interest.
%
% Input:
%
% y              Data array (1-D)
% x              Corresponding x-axis array (1-D)
% xrange         Range of interest (format: [x1 x2])
%
% Output:
%
% YD             Data array only within range of interest 
% XD             Corresponding x-axis array within range of interest
%
% Last modified by pdabney@princeton.edu, 9/28/21

% Ensure frange is increasing
frange = sort(xrange);

% Error if the range of interest is outside data available
if (frange(1) < x(1) || frange(2) > x(end))
    error('Range of interest is outside band of available data')
end

% Obtain indexes for range of interest
[~,ub]=min(abs(frange(2) - x));
[~,lb]=min(abs(frange(1) - x));

% Return data arrays within range of interest
XD = x(lb:ub); YD = y(lb:ub);

end

