function varargout=movingabsm(tsraw,tsfil,t,tlwin)
% [newts,nt,dif]=movingabsm(tsraw,tsfil,t,lwin)
%
% Running absolute mean normalization. Computes the running average of the 
% absolute value of a waveform in a  normalization time window of a fixed length. 
% The weights are computed on waveform filtered in earthquake band and apply 
% to raw data.
%
% Input:
%
% tsraw            Raw time series data (1-D array)
% tsfill           Time series filtered in earthquake band (1-D)
% t                Corresponding time array (1-D)
% lwin             Length of window (in samples)
%
% Output:
%
% newts            Normalized time series (not original length)        
% nt               New time series (cut to the length of the normalized time series)
% dif              Number of samples removed
% weight           Calculated weight
%
% Last modified by pdabney@princeton.edu, 5/3/21

% Default values
defavl('lwin', 256);

tsraw = tsraw(:);
tsfil = tsfil(:);

% Take the absolute value of the waveform
a = abs(tsfil);

% Take the moving average
weight = runavg(a,lwin);

% Method - clips the beginning and ends of the raw time series to ensure
% the moving average array and raw time series array are the same length
dif = length(tsraw)-length(weight);
if rem(dif,2) == 0
    % remove the same number of samples at the beginning and end of the
    % time series
    newraw = tsraw(1+dif/2:end-dif/2);
    nt = t(1+dif/2:end-dif/2);
else
    r = dif - 1;
    % remove an additional sample at the beginning of the time series
    newraw = tsraw(1+r/2 +1:end-r/2);
    nt = t(1+r/2 + 1:end-r/2);
end

% Normalized time series
newst = newraw./weight;


% Provide output
vars={newst,nt,dif,weight};
varargout=vars(1:nargout);
end

