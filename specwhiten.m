function varargout=specwhiten(ts,mtype, window)
% [wts]=SPECWHITEN(ts,mtype,window)
%
% Whitens a time series by normalizing the spectrum by the magnitude of the amplitude
% spectrum. Options include a 'smooth' or 'unsmooth' magnitude.
% 
%
% Input:
%
% ts            Time series data (1-D array)
% mtype         Magnitude type: 0 unsmoothed, 1 smoothed
% window        Window length for moving average (required if mtype = 1)
%
% Output:
%
% wts           Whitened time series
%
% Last modified by pdabney@princeton.edu, 01/24/22


% Default value
defval('mtype', 1)

% Take the fft
tsfft = fft(ts);

% Obtain the magnitude
switch nargin
  case 2
    mag = movmean(abs(tsfft),window);
  case 1
    mag = abs(tsfft);
end

% Divide by amplitude spectrum and return to time domain
wts = real(ifft(tsfft./mag));

% Provide output
vars={wts};
varargout=vars(1:nargout);
end

