function varargout=findpks(SD,F,frange)
% [peaks,locs,width,prom]=findpks(SD,F,frange)
%
% Finds peaks in a specified range of interest that meets a specified threshold.
%
% INPUT: 
%
% SD       Data array
% F        Frequency array
% frange   Frequency range of interest, in increasing order (format: [f1 f2])
%
% OUTPUT:
%
% peaks
% locs
% width
% prom
%
% Last modified by pdabney@princeton.edu, 09/28/2022


% Find all peaks in range of interest
idx = find(F >= frange(1) & F <= frange(2));
[ipks,ilocs,iw,ip]=findpeaks(SD(idx),F(idx));

% Find the standard deviation 
sigma = std(ipks);

% Find peaks given a minimum peak prominence
[peaks,locs,width,prom]=findpeaks(SD(idx),F(idx),'Threshold',sigma);


% Optional output
vars={peaks,locs,width,prom};
varargout=vars(1:nargout);

end
