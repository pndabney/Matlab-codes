function varargout=specwhiten(ts,method, window)
% [wts]=SPECWHITEN(ts,method,window)
%
% Whitens a time series. There are two methods: one is by normalizing the 
% spectrum by its magnitude, or to set the spectrum values to 1 . Options for 
% normalizing include a 'smooth' or 'unsmooth' magnitude.
% 
%
% Input:
%
% ts            Time series data (1-D array)
% method        Whitening method: 
%                  0 unsmoothed magnitude
%                  1 smoothed magnitude
%                  2 set to 1
% window        Window length for moving average (required if mtype = 1)
%
% Output:
%
% wts           Whitened time series
%
% Last modified by pdabney@princeton.edu, 02/10/22


% Default value
defval('mtype', 1)

% Take the fft
tsfft = fft(ts);

% Obtain the magnitude
switch nargin
  case 3
    mag = movmean(abs(tsfft),window);
  case 2
    if method == 0
        mag = abs(tsfft);
    elseif method == 2
        mag = tsfft;
    end
end

% Divide by amplitude spectrum and return to time domain
wts = real(ifft(tsfft./mag));

% Provide output
vars={wts};
varargout=vars(1:nargout);
end

