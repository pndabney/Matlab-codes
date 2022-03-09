function varargout=taper(L,type,widt,x)
% [window,ts]=TAPER(L,type,widt,x);
%
% Applies symmetric taper to each end of the data for a given length. 
%
% Input:
%
% L         Length of taper
% type      Type of taper: Cosine, Hamming, Hanning (Case sensitive)
%           [default: Hanning]
% widt      Taper width on each end (in percent)
%           [default: 5]
% x         Optional: Time series to apply taper (1-D array)
%
% Output:
%
% window       
% ts        Tapered time series
% 
% NOTE:
%
% Requires slepian_alpha. See defval.
%
% Last modified by pdabney@princeton.edu, 03/09/2022

% Default values
defval('type','Hanning');
defval('widt',5);
defval('L',100);

% Error when the taper width is greater than 50
if widt > 50
    error('Error. Width input must be less than 50')
end

% Must be an integer
N = floor((widt/100)*L);

% Initialize taper
window = ones(1,L);

if strcmp('Cosine',type) == 1
    omega = pi/(2*N);
    % Coefficients
    F0 = 1.0; F1 = 1.0;
elseif strcmp('Hanning',type) == 1
    omega = pi/N;
    % Coefficients
    F0 = 0.50; F1 = 0.50;
elseif strcmp('Hamming',type) == 1
    omega = pi/N;
    % Coefficients
    F0 = 0.54; F1 = 0.46;
end

% Create taper
window(1:N) = F0-F1*cos(omega*(1:N));
window(end-N+1:end) = flip(window(1:N));

switch nargin
  case 4
    % Apply taper
    ts = x.*window;
    % Optional output
    vars = {window,ts};
  case 3
    % Optional output
    vars = {window};
end

% Output
varargout = vars(1:nargout);

end

