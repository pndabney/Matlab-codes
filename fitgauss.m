function varargout=fitgauss(y,x,loc,wdt)
% [Y,X,cfit,e,res]=fitgauss(y,x,loc,wdt);
%
% Fit gaussian distribution curve to single peak of interest.
%
% Input:
% 
% y              Data (1-D)
% x              Corresponding x-axis data (1-D)
% loc            Location of the peak
% wdt            Full width at half maximum
%
% Output:
%
% Y              Data in specifed frequency range of interest (1-D)             
% X              Corresponding x-axis data (1-D)
% cfit           Gaussian curve fit result, use for plotting
% e              Root mean squared error
% res            Residuals, as vector
%
% Last modified by pdabney@princeton.edu, 11/08/21

% Determine window to fit the gaussian
[X,Y] = fitwin(x,y,loc);

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
vars={Y,X,cfit,e,res};
varargout=vars(1:nargout);

end