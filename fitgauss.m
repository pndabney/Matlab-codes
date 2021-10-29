function varargout=fitgauss(y,x,pk,loc,wdt)
% [X,Y,bnds,cfit,e,res]=fitgauss(y,x,pk,loc,wdt);
%
% Fit gaussian distribution curve to single peak of interest.
% Note: Only works if there is a single peak, need to look into a 
% new method for multiple peaks (such as mode splitting).
%
% Input:
% 
% y              Data (1-D)
% x              Corresponding x-axis data (1-D)
% pk             Maximum of the peak
% loc            Location of the peak
% wdt            Full width at half maximum
%
% Output:
%
% Y              Data in specifed frequency range of interest (1-D)             
% X              Corresponding x-axis data (1-D)
% bnds           Vector containing the upper and lower bound indexes for range of interest
% cfit           Gaussian curve fit result, use for plotting
% e              Root mean squared error
% res            Residuals, as vector
%
% Last modified by pdabney@princeton.edu, 10/29/21


% Find the index of the local min of the LHS 
[Xl,Yl,bnds] = inrange(x,y,[x(1) loc]);
[lmin, lin]=findlocmin(flip(Yl));
xl = find(Xl(end - lin) == x); yl = find(Yl(end - lin) == y);

% Find the index of the local min of the RHS
[Xr,Yr,bnds] = inrange(x,y,[loc x(end)]);
[rmin, rin]=findlocmin(Yr);
xr = find(Xr(rin)==x); yr = find(Yr(rin) == y);

% Get range between the local minimas
X = x(xl:xr); Y = y(yl:yr);


% Choose fittype to be a gaussian
gmodel = fittype('a1*exp(-((x-b1)/c1)^2)');

% Choose starting points for fit
[i,j]=max(Y);
% Creates a curve fitting object used to plot and evaluate the fit
[cfit,gof,output] = fit(X,Y,gmodel,'StartPoint',[i X(j) wdt]);


% Residuals
res = output.residuals;
% Root mean square error
e = gof.rmse;


% Optional Output
vars={X,Y,bnds,cfit,e,res};
varargout=vars(1:nargout);

end
