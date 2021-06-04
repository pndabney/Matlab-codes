function varargout = sachanning(x,r)
% [ts,N]=SHANNING(x,r);
%
% Applies hanning taper to each end of the data for a given length. 
% Computation attempt to be equivalent to SAC command TAPER. See SAC manual for more details.
%
% Input:
%
% x         Time series (1-D array)
% r         Taper width on each end of the data as a fraction of the window that is tapered. r 
%           must be between 0 and 0.5. If r < 0, then r is set to 0. If r > 0.5, then r is set to
%           0.5. [default: 0.05]
%
% Output:
%
% ts         Tapered time series
% N          Length of taper at each end (in samples) 
%
% NOTE:
%
% Code still needs work. For large L, the tolerance is exceeded (1e-6). In addition, for some
% circumstances, N must use floor instead of round.
%
% Requires slepian_alpha.
%
% Last modified by pdabney@princeton.edu, 6/04/2021

% Default values
defval('r','0.05');

ts = x(:);
L = length(x);

% Set r to specified values if r is greater than 0.5 or r is less than 0. 
if r < 0
    r = 0;
    warning('r has been set to 0')
elseif r > 0.5
    r = 0.5;
    warning('r has been set to 0.5')
end

% Determine length of taper at each end
% NOTE: For some circumstances, round must be changed to floor
% e.g. L = 250, r = 0.05 ==> floor(r*L)
N = round(r*L);

% IN SAC (for even and odd #), N = 0,1,2 ==> Taper is always the same first 3 elements = 0, 0.5, 1
% In the code below: N = 0 ==> NaN, 1, 1; N = 1 ==> 0, 1, 1; N = 2 ==> 0, 0.5, 1
% Set N = 2 when N is equal to 0 or 1
if N == 0
   N = 2;
elseif N == 1
   N = 2;
end

% TAPER  
omega = pi/N;

% If interested in another taper such as hamming, simply change F0 and F1
F0 = 0.50; F1 = 0.50;

% This approach works for most values where N is less than half the length of the data
if N < floor(L/2)
    % LHS taper
    tl = (F0-F1*cos(omega*[0:N]));
    kl = ts(1:N+1).*tl(:);
    ts(1:N+1) = kl;
    
    % RHS taper
    tr = flipud(tl);
    kr = ts(L:-1:L-N).*tr(:);
    ts(L:-1:L-N) = kr;
elseif N == floor(L/2)
    % This approach is for when r = 0.5
    % LHS taper
    tl = (F0-F1*cos(omega*[0:N]));
    kl = ts(1:N).*tl(1:end-1).';
    ts(1:N) = kl;
    
    % RHS taper
    tr = flipud(tl);
    kr = ts(L:-1:L-N+1).*tr(1:end-1).';
    ts(L:-1:L-N+1) = kr;
end

% Optional Output
vars={ts,N}
varargout=vars(1:nargout);

end
