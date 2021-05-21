function varargout=specwhiten(ts,fhandle,winopt)
% [wts]=SPECWHITEN(ts)
%
% Flattens the time series by applying a specified window and Fourier transforming the 
% signal and normalizing by the amplitude spectrum, and then inverse Fourier
%  transforming it.
%
% Input:
%
% ts            Time series data (1-D array)
% fhandle       Name of window function preceded by an @
%               (default: @hann)
% winopt        Window options (include a window parameter)
%               (See mathworks for window options for specified window)
%
% Output:
%
% wts           Whitened time series
%
% Last modified by pdabney@princeton.edu, 5/21/21



% Default value
defval('fhandle', '@hann');

% Get number of array elements
L = numel(ts);


switch nargin
  case 2
    % Specify the window
    w = window(fhandle,L);
    
  case 3 
    % Specify the window
    w = window(fhandle,L,winopt);

  otherwise
end

% Take the fft
tsfft = fft(w.*ts,L);

% Obtain the magnitude
magn = abs(tsfft);

% Divide by amplitude spectrum and return to time domain
wts = ifft(tsfft./magn);

% Provide output
vars={wts};
varargout=vars(1:nargout);
end

