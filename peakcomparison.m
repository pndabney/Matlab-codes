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
% err              Absolute error, the difference between the identified and known frequency 
%
% Last modified by pdabney@princeton.edu, 9/01/21

% Ensure locs is not NaN
if isnan(pkloc) == 1
    f = []; err = []; locs = [];
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

    % Absolute error
    abs_err = abs(locs-f);
    % Relative error
    rel_err = abs(abs_err./f);
    % Percent error
    per_err = rel_err*100;
end

% Optional Output
vars={f,locs,abs_err,rel_err,per_err};
varargout=vars(1:nargout);

end
