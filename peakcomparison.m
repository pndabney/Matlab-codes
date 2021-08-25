function varargout=peakcomparison(freqs,pkloc)
% [f,locs,err]=peakcomparison(freqs,pkloc)
%
% Determines which peak identified best corresponds with a mode frequency of interest
%
% Input:
%
% freqs            Array containing mode frequencies of interest
% pkloc            Array of peak locations 
%
% Output:
%
% f                Mode frequencies likely identified
% locs             Peak locations that likely correspond to a known mode frequency
% err              Difference in observed versus known mode frequencies
%
% Last modified by pdabney@princeton.edu, 8/25/21

% Ensure locs is not NaN
if isnan(pkloc) == 1
    f = [];
    err = [];
else
    % Determine which peak location is likely a mode frequency
    for i = 1:length(freqs)
        d = abs(freqs(i)-pkloc);
        [~,Ind(i)]=min(d);
    end
    locs = pkloc(unique(Ind));
    
    % Determine the mode frequencies identified
    for i = 1:length(locs)
        d = abs(freqs-locs(i));
        [~,id(i)]=min(d);
    end 
    f = freqs(unique(id));

    % Difference in observed versus mode frequencies
    err = abs(f-locs);
end

% Optional Output
vars={f,locs,err};
varargout=vars(1:nargout);

end
