function varargout=preprocess(x,t,r,delta,freqlim,units,file,Int)
% [ts,tout]=PREPROCESS(x,t,r,delta,freqlim,units,file,Int)
%
% Runs through preprocessing steps: 1) remove mean, 2) remove trend,
% 3) taper, 4) remove instrument response, and 5) decimate.
%
% Input:
%
% x                 Seismic data vector (1-D)
% t                 Corresponding time data (1-D)
% r                 Taper width of the data, each tapered end of the data is r/2. r is the
%                   ratio of cosine-tapered section length to the entire window length. r
%                   must be between 0 and 1. If r < 0, then r is set to 0. If r > 1,
%                   then r is set to 1. [default: 0.1]
% delta             Sample rate of the data
% freqlim           Vector containing four frequencies in increasing order. Frequencies
%                   specify the corners of a cosine filter to stabilize the deconvolution 
%                   for the transfer function.
% units             Output units: 'displacement','velocity', or 'acceleration'
%                   [default: 'velocity']
% file              RESP file, full path included
% Int               Integer factor to decrease sample rate by. Set to 0 to keep sampling
%                   rate the same [default: 0]
%
% Output:
%
% ts                Preprocessed data (1-D)
% tout                 Corresponding time data (1-D)
% Note: 
%
% Requires respository slepian_alpha and rflexa. See TRANSFER and READSAC.
%
% Last modified by pdabney@princeton.edu, 6/18/21

% Default values
defval('r',0.1);
defval('units','velocity');


x = x(:);
t = t(:);
L = length(x);

% Remove mean
rmSD = rmean(x);

% Remove trend
% Subtracts the best-fit line in the least squares sense from the data
rtSD = detrend(rmSD);

% Set r to specified values if r is greater than 1 or r is less than 0. 
if r < 0
    r = 0;
    warning('r has been set to 0')
elseif r > 1.0
    r = 1;
    warning('r has been set to 1')
end

% Taper
w = tukeywin(L,r);
tSD = rtSD.*w;

% Remove instrument response
fileType = 'resp';
[data] = transfer(tSD,delta,freqlim,units,file,fileType);

% Decimate/Resample the data
if Int  == 0 
    ts = data;
else
    [ts,t] = resamp(data,t,Int);
end


% Option Output
vars={ts,tout};
varargout=vars(1:nargout);
end

