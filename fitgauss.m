function varargout=fitgauss(y,x,freq,wlen,thresh)
% [X,Y,cfit,e,res]=fitgauss(y,x,freq,wlen,thresh)
%
% Fit gaussian distribution curve to single peak of interest.
% Note: Only works if there is a single peak, need to look into a 
% new method for multiple peaks (such as mode splitting).
%
% Input:
% 
% y              Data (1-D)
% x              Corresponding x-axis data (1-D)
% freq           Single frequencies of interest
% wlen           Length of window
% thresh         Minimum height difference between a peak and its neighbors
%
% Output:
%
% Y              Data in specifed frequency range of interest (1-D)             
% X              Corresponding x-axis data (1-D)
% cfit           Gaussian curve fit result, use for plotting
% e              Root mean squared error
% res            Residuals, as vector
%
% Last modified by pdabney@princeton.edu, 9/16/21

% Take half the window 
halfwin = wlen/2;
% Obtain a frequency range of interest
frange = [freq-halfwin freq+halfwin];

% Find indexes for lower and upper bounds
[~,lb] = min(abs(frange(1)-x));
[~,ub] = min(abs(frange(2)-x));
% Obtain data from only the range of interest
X = x(lb:ub); Y = y(lb:ub);

% Need to obtain the full width at half maximum 
[pks,locs,wdt,~]=findpeaks(Y,X,'Threshold',thresh,'WidthReference','halfheight');

% Can only imput one width as a starting point, thus must have only a single peak.
if wdt > 1
    error('Must obtain a single peak.')
end

% Choose starting points for fit
[i,j]=max(Y);
gmodel = fittype('a1*exp(-((x-b1)/c1)^2)');
[cfit,gof,output] = fit(X,Y,gmodel,'StartPoint',[i X(j) wdt]);

% Residuals
res = output.residuals;
% Root mean square error
e = gof.rmse;

% Optional Output
vars={X,Y,cfit,e,res};
varargout=vars(1:nargout);

end

