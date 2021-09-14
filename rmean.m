function ts=rmean(x)
% [ts]=RMEAN(x);
%
% Removes the mean from a time series.
%
% Input:
%
% x         Time series data array (1-D)
%
% Output:
%
% ts        New time series with mean removed
%
% Last modified by pdabney@princeton.edu, 5/27/2021

x = x(:);

rm = mean(x);

ts = (x - rm);

end