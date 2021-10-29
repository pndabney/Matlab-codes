function varargout=isdecreasing(x)
% [locmin,index]=isdecreasing(x)
%
% Finds the index and value of the first local minima
%
% Input:
%
% x              Vector of decreasing integers 
%
% Output:
%
% locmin         Local minima value
% index          Index of the local minima
%
% Last modified by pdabney@princeton.edu, 10/29/21

% Determine the local minima
diffval = diff(x);

% Find the first value where it goes from decreasing to increasing
index = find(diffval > 0, 1, 'first');

% Local minima value
locmin = x(index);

% Optional Output
vars = {locmin,index};
varargout=vars(1:nargout);
end