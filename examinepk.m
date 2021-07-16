function varargout=examinepk(x,y,freq,frange,ptype,thresh)
% [X,Y,sigma,mu,g,pks,locs,wdt,prm,Ra,skw,kurt]=examinepk(x,y,freq,frange,ptype,thresh)
%
% Examines the size and shape, mean and standard deviation, and fits a gaussian distribution to
% a single peak of interest. 
%
% Input:
%
% y              Data (1-D)
% x              Corresponding x-axis data (1-D)
% freq           Mode frequency of interest
% frange         Frequency range for window of interest 
% ptype          0 regular plot
%                1 log scale on x-axis [default]
%                2 log scale on y-axis
%                3 log-log scale plot
% thresh         Threshold, minimum peak height
%
% Output:
%
% sigma          Standard Deviation (1 spectral density, 2 gaussian function)
% mu             Mean (1 spectral density, 2 gaussian function)
% g              Gaussian Curve
% pks            Peak height (1 spectral density, 2 gaussian function)
% locs           Location of peak (1 spectral density, 2 gaussian function) 
% wdt            Full width of peak at the half maximum 
%                (1 spectral density, 2 gaussian function)
% Area           Area beneath the curve
%                (1 spectral density, 2 gaussian function)
% Ra             Ratio of the area of the LHS to the RHS
% skw            Skewness, measure of asymmetry of the data 
%                (1 spectral density, 2 gaussian function)
% kurt           Kurtosis, measure of how outlier-prone a distribution 
%                (1 spectral density, 2 gaussian function)
% 
% Last modified by pdabney@princeton.edu, 7/16/21


% Compute Gaussian Distribution
% Does not create a plot through fitgauss
plotornot = 0;
[X,Y,cfit,e,res]=fitgauss(y,x,freq,frange,thresh,plotornot);  

% Variables for Gaussian function
a1 = cfit.a1; b1 = cfit.b1; c1 = cfit.c1;
g = a1*exp(-((X-b1)/c1).^2);


% Find peak,location, width, prominence
[pks1,locs1,wdt1,prm1]=findpeaks(Y,X,'MinPeakHeight',thresh,'WidthReference','halfheight');
[pks2,locs2,wdt2,prm2]=findpeaks(g,X,'MinPeakHeight',thresh,'WidthReference','halfheight');
pks=[pks1 pks2]; locs=[locs1 locs2]; wdt=[wdt1 wdt2]; prm=[prm1 prm2];


% Find the mean and standard deviation for the Data and Gaussian distribution
mu = [mean(Y) mean(g)];
sigma = [std(Y) std(g)];

% Find Area
Area = [trapz(X,Y) trapz(X,g)];

% Determine how outlier prone the distribution is
kurt = [kurtosis(Y) kurtosis(g)];
% Measure of the asymmetry of the data around the sample mean
skw = [skewness(X) skewness(g)];


% Determine how symmetric the peak is
% Center peak location index
cp = find(X == locs(1),1);
% Area of the RHS
A1 = trapz(X(cp:end),Y(cp:end));
% Area of the LHS
A2 = trapz(X(1:cp),Y(1:cp));
% Ratio of the area of the  RHS and LHS 
% if R > 1, A1 > A2; if R < 1, A1 < A2
Ra = A1/A2;


% Optional Output
vars={X,Y,sigma,mu,g,pks,locs,wdt,prm,Area,Ra,skw,kurt};
varargout=vars(1:nargout);

end

