function varargout=resamp(sinput,tinput,r)
% [sout,tout]=resamp(sinput,tinput,r)
%
% Takes in a time series and decreases the sample rate by a factor of r
%
% Input:
%
% sinput           Seismic data array (1-D)
% tinput           Time series time array (1-D)
% r                Integer factor to decrease sample rate by
%
% Output:
%
% sout             Resampled seismic data array
% tout             Resampled time series time array    
%
% Last modified by pdabney@princeton.edu, 4/17/21

% Default
defval('r',2);

% Resample
sout = decimate(sinput,r);
tout = decimate(tinput,r);



% Provide output
vars={sout,tout};
varargout=vars(1:nargout);


end

