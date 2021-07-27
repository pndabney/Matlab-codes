function varargout=getfreqs(frange,mtype,dset)
% [freqs,mlabel,tdata]=getfreqs(frange,mtype,dset)
%
% Reads in file 'masterswidmer' and extracts mode frequencies for specified range and types.
% NOTE: Assumes you have the data file, 'masterwidmer'. Data units are in microhertz.
%
% Input:
%
% frange        Vector containing 2 frequencies in microhertz (e.g. [0.2e3 1e3])
% mtype         Type of modes: 'spheriodal','toroidal','both'
% dset          0 prem modes
% 		1 observed modes
%
% Output;
%
% freqs         Vector containing mode frequencies of interest (in microhertz)
% mlabel        String array with the labels to the corresponding mode frequency       
% tdata         Data table containing the observed modes, their uncertainity, and the prem computed
%               modes (in microhertz)
% 
% Note:
%
% Data table from Free Oscillations: Frequencies and Attenuations by Masters and Widmer.
% Requires repository slepian_alpha. See defval.
%
% Last modified by pdabney@princeton.edu, 7/27/21

% Default values
defval('dset',1)

% Ensure there are only 2 frequencies
if length(frange) == 2
    frange = sort(frange);
else
    error('There must be 2 frequencies')
end

% Read in data
data = readtable('masterswidmer');
% Can remove the first row
data(1,:)=[];

% If interested in only spheriodal or toroidal modes
if strcmp(mtype,'spheriodal') == 1
    k = find(contains(string(data.Mode),"T") == 1);
    data(k,:)=[];
elseif strcmp(mtype,'toroidal') == 1
    k = find(contains(string(data.Mode),"S") == 1);
    data(k,:)=[];
elseif strcmp(mtype,'both') == 1
    % Do nothing 
end

%-----------------------------------------------
% Remove frequencies that are NOT observed
rmf = find(string(data.freq_obs) == "");
data(rmf,:)=[];
%-----------------------------------------------

% Remove data  outside frequency range of interest
fobs = str2double(data.freq_obs);
lb = find(fobs < frange(1));
data(lb,:)=[];
ub = find(fobs > frange(2));
data(ub,:)=[];

% Separate mode labels and numerical data
mlabel = string(data.Mode);
tdata = [str2double(data.freq_obs) str2double(data.uncertainty) str2double(data.freq_prem)];

% Interested in only prem or observed modes
if dset == 1
    freqs = tdata(:,1);
elseif dset == 0
    freqs = tdata(:,3);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Optional Output
vars={freqs,mlabel,tdata};
varargout=vars(1:nargout);
end

