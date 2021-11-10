function varargout=findlocmin(x,ws)
% [locmin,index]=findlocmin(x,ws)
%
% Finds the index and value of the local minima cloeset to the LHS or RHS
%
% Input:
%
% x              Vector of decreasing integers 
% ws             1 LHS
%                2 RHS
%
% Output:
%
% locmin         Local minima value
% index          Index of the local minima
%
% Last modified by pdabney@princeton.edu, 11/08/21


% Determine the local minima
diffval = diff(x);

% Find the indexes to all the negative values
negind = find(diffval < 0);

if isempty(negind) == 1
    if ws == 1
        index = 1;
    elseif ws ==2
        index = length(x);
    end
else
    % Find the indexes where is changes from negative to positive values
    [C,K]=isincreasing(negind);

    % Find local minimum closest to the peak
    if length(K) == 1
        index = negind(K);
    else
        if ws == 1
            index = negind(K(end))+1;
        elseif ws == 2
            index = negind(K(1));
        end
    end
end

% Local minima value
locmin = x(index);

% Optional Output
vars = {locmin,index};
varargout=vars(1:nargout);
end