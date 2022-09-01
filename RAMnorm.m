function [ts]=RAMnorm(wdata,data, wlen, Fs)
% 
% Applies running absolute mean normalization. Weights can be computed using
% the original data or filtered data and applied to the original data. Additionally, 
% the data edges are tapered.
%
% Input:
%
% wdata       Data array to compute the weights (1-D)     
% data        Data array to apply weights (1-D)
% wlen        Window length (in seconds)
% Fs          Sample rate (Hz)
%
% Output:
%
% ts          Output time series
%
% Last modified by pdabney@princeton.edu, 01/26/22

% Window length
lwin = round(wlen*Fs);
% Number of points
npts = length(data);

% Starting point
spt = 1; 
N = lwin;

xout=[];
while N < npts
    % Get window
    window = wdata(spt:N);
    % Compute weights
    weights = sum(mean(abs(window))) / (2 * lwin + 1);
    % Apply weights to the center point of the window
    xout(spt) =  data(spt + floor(lwin/2)) / weights;
    % Shift window
    spt = spt + 1;
    N = N + 1;

end

% Apply taper
[~,ts]=taper(length(xout),'Hanning',2,xout);


end
