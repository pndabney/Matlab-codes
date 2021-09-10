function varargout=identifypeaks(x,y,freqs,frange,thresh,units)
% [X,pks,locs,width,prom,freqs,FREQ,err]=IDENTIFYPEAKS(x,y,freqs,frange,thresh,units);
%
% Identifies and characterizes peaks given a specified threshold. 
%
% Input:
%
% y              Data array (1-D)
% x              Corresponding x-axis data (1-D)
% freqs          Vector containing mode frequencies of interest, in hertz
% frange         Frequency range of interest, in hertz (format: [f1 f2])
% thresh         Minimum height difference between a peak and its neighbors
% units          0 Hertz
%                1 Millihertz [default]
%                2 Microhertz
%
% Output:
%
% X              X-axis data array with converted units
% pks            Vector with local maxima (peaks) 
% locs           Location where peaks occur
% width          Width of the peaks
% prom           Prominence of the peaks
% freqs          Vector containing all mode frequencies in range of interest
% corfreq        Mode frequencies likely identified
% err            Vector containing the difference in observed versus known mode frequencies
%
% NOTE:
%
% Data from  Free Oscillations: Frequencies and Attenuations by Masters and Widmer 1995.
%
% Last modified by pdabney@princeton.edu, 9/10/21

% CONVERT UNITS
if units == 0
    ucon = 1;
elseif units == 1
    ucon = 1e3;
elseif units == 2
    ucon = 1e6;
end

% Convert x data units
X = x*ucon;
% Convert frequency units
freqs = freqs*ucon;
% Distannce range around frequency of interest
freqd = 5*1e-5*ucon;

%-------------------------------------------------------------------------------------
% FIND PEAK IN THE DATA
[pks, LOCS, width, prom] = findpeaks(y,X,'MinPeakHeight',thresh); 
freqrange = zeros(length(freqs),2);
freqrange(:,1) = freqs - freqd;
freqrange(:,2) = freqs + freqd;

% ELIMINATE PEAKS THAT ARE NOT WITHIN A SPECIFIED RANGE
% Deal with the upperbound
Ku=find(LOCS > freqrange(length(freqs),2));
LOCS(Ku)=[]; pks(Ku)=[]; prom(Ku)=[]; width(Ku)=[];
% Deal with the middle section
% Make sure to not remove points if there is overlap in frequency range
for j = 1:length(freqs)-1
    if freqrange(j,2) < freqrange(j+1,1)
        Km = find(LOCS > freqrange(j,2) & LOCS < freqrange(j+1,1));
        LOCS(Km)=[]; pks(Km)=[]; prom(Km)=[]; width(Km)=[];
    end
end
% Deal with the lowerbound
Kl=find(LOCS < freqrange(1,1));
LOCS(Kl)=[]; pks(Kl)=[]; prom(Kl)=[]; width(Kl)=[];

% DETERMINE WHICH PEAK BEST CORRESPONDS WITH A KNOWN MODE FREQUENCY
% AND REMOVE THE OTHERS (Note: May use to replace section above.)
if ~isempty(LOCS) == 1
    [corfreq,locs,err]=peakcomparison(freqs,LOCS);
    for i = 1:length(locs)
        idp(i) = find(locs(i) == LOCS);
    end
    pks=pks(idp); prom=(idp); width=width(idp);
else
    % If locs is empty, set locs to NaN for plotting purposes
    locs = NaN;
    corfreq = NaN; err = NaN;
end

%-------------------------------------------------------------------------------------
% Optional output
varns={X,pks,locs,width,prom,freqs,corfreq,err};
varargout=varns(1:nargout);

end
