function varargout=findpks(SD,F,frange,R,wlen)
% [peaks,locs,width,prom,meth]=findpks(SD,F,frange,R,wlen)
%
% Finds peaks in a specified range of interest that meets a specified threshold.
%
% INPUT: 
%
% SD       Data array
% F        Frequency array
% frange   Frequency range of interest, in increasing order (format: [f1 f2])
% R        Prominence height ratio threshold value, between 0-1 (default: 0.7)
% wlen     Window length, in samples (default: 20)
%
% OUTPUT:
%
% peaks    Local maxima array
% locs     Corresponding frequency array
% width    Width array
% prom     Prominence array
%
% Last modified by pdabney@princeton.edu, 09/29/2022

% default values
defval('R',0.7)
defval('wlen',20)

% Find all peaks in range of interest
idx = find(F >= frange(1) & F <= frange(2));
[peaks,locs,width,prom]=findpeaks(SD(idx),F(idx));

if length(locs) == 0
    disp('No peaks were found.')
else

    % Only keep peaks that meet ratio standard
    ratio = prom./peaks;
    k = find(ratio >= R);
    peaks=peaks(k);
    locs=locs(k);
    width=width(k);
    prom=prom(k);
    
    % Elimate peaks that do not meet height threshol
    index=[];
    % Retreive smoothed data - required because data is not relatively falt
    y=movmean(SD(idx),wlen);
    for i = 1:length(locs)
        l = find(F(idx) == locs(i),1);
        if peaks(i) < y(l)+std(SD(idx))
            index=[index;i];
        end
    end
    % Remove values
    peaks(index)=[];
    locs(index)=[];
    width(index)=[];
    prom(index)=[];
end

% Optional output
vars={peaks,locs,width,prom};
varargout=vars(1:nargout);

end
