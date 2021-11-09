function [X,Y] = fitwin(x,y,loc)
% [X,Y]=fitwin(x,y,loc)
%
% Determines the window to fit the gaussian distribution. 
% (Ensures only single peaks are fitted)
%
% Input:
%
% y              Data (1-D)
% x              Corresponding x-axis data (1-D)
% loc            Location of the peak
%
% Output:
%
% Y              Data window to fit gaussian (1-D)             
% X              Corresponding x-axis data (1-D)
%
%
% Last modifed by pdabney@princeton.edu, 11/08/21

locin = find(loc == x);

% Find the index of the local min of the LHS 
[Xl,Yl,bnds] = inrange(x,y,[x(1) loc]);
[lmin, lin]=findlocmin(Yl,1);
% If the local min is the starting point
if isempty(lmin) == 1
    lmin = min(Yl);
    lin = find(lmin == Yl);
end


% Find the index of the local min of the RHS
[Xr,Yr,bnds] = inrange(x,y,[loc x(end)]);
[rmin, rin]=findlocmin(Yr,2);
% If the local min is the starting point
if isempty(lmin) == 1
    rmin = min(Yr);
    rin = find(rmin == Yr);
end
rin = locin + rin; % update rin to apply to the rhs


% Get range between the local minimas
X = x(lin:rin); Y = y(lin:rin);
end

