function varargout=specwhiten(ts)
% [nts]=SPECWHITEN(ts)
%
% Flattens the time series by applying the Hann window and Fourier transforming the 
% signal and normalizing by the amplitude spectrum, and then inverse Fourier
%  transforming it.
%
% Input:
%
% ts            Time series data (1-D array)
%
% Output:
%
% wts           Whitened time series
%
% Last modified by pdabney@princeton.edu, 5/17/21



% Get number of array elements
L = numel(ts);

% Use a Hann Window
Hw = hann(L);

% Take the fft
tsfft = fft(Hw.*ts,L);

% Obtain the magnitude
magn = abs(tsfft);

% Divide by amplitude spectrum and return to time domain
wts = ifft(tsfft./magn);


% Provide output
vars={wts};
varargout=vars(1:nargout);
end

