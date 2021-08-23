function varargout=peakcomparison(freqs,locs)
% [f,err]=peakcomparison(freqs,locs)
%
% Determines which peak identified best corresponds with a mode frequency of interest
%
% Input:
%
% freqs            Vector containing mode frequencies of interest
% locs             Locations for identified peaks
%
% Output:
%
% f                Mode frequencies likely identified
% err              Difference in observed versus mode frequencies
%
% Last modified by pdabney@princeton.edu, 8/20/21

% Determine which peak location is likely a mode frequency
for i = 1:length(locs)
    d = abs(freqs-locs(i));
    [~,Ind(i)]=min(d);
end
f = freqs(Ind);

% Difference in observed versus mode frequencies
err = abs(f-locs);

% Optional Output
vars={f,err};
varargout=vars(1:nargout);

end

