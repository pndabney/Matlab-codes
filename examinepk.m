function varargout=examinepk(x,y,freq,frange,ptype,thresh)
% [Y,X,g,peak,gauss]=examinepk(x,y,freq,frange,ptype,thresh)
%
% Examines the size and shape, mean and standard deviation, and fits a gaussian distribution to
% a single peak of interest. 
%
% Input:
%
% y              Data array (1-D)
% x              Corresponding x-axis array (1-D)
% freq           Mode frequency of interest
% frange         Index for frequency range 
% thresh         Threshold, minimum peak height
%
% Output:
%
% Y              Data array of only specifed frequency range of interest (1-D)
% X              Corresponding x-axis array (1-D)
% g              Gaussian Curve
% peak           Struct of information about peak of interest
% gauss          Struct of information about gaussian distribution 
%
% Last modified by pdabney@princeton.edu, 9/8/21

% Compute Gaussian Distribution
% Does not create a plot through fitgauss
plotornot = 0;
[X,Y,cfit,~,~]=fitgauss(y,x,freq,frange,thresh,plotornot);  
% Variables for Gaussian function
a1 = cfit.a1; b1 = cfit.b1; c1 = cfit.c1;
g = a1*exp(-((X-b1)/c1).^2);

% Find peak,location, width, prominence
[pks1,locs1,wdt1,~]=findpeaks(Y,X,'MinPeakHeight',thresh,'WidthReference','halfheight');
[pks2,locs2,wdt2,~]=findpeaks(g,X,'MinPeakHeight',thresh,'WidthReference','halfheight');


% Find the mean and standard deviation for the Data and Gaussian distribution
mu = [mean(Y) mean(g)]; sigma = [std(Y) std(g)];
% Find Area of the data and the gaussian distribution
Area = [trapz(X,Y) trapz(X,g)];
% Determine how outlier prone the distribution is
kurt = [kurtosis(Y) kurtosis(g)];
% Measure of the asymmetry of the data around the sample mean
skw = [skewness(X) skewness(g)];

% Determine how symmetric the peak is
% Center peak location index
cp = find(X == locs1,1); cpg = find(X == locs2,1);
% Area of the RHS
A1 = [trapz(X(cp:end),Y(cp:end)) X(cpg:end),g(cpg:end))];
% Area of the LHS
A2 = [trapz(X(1:cp),Y(1:cp)) X(1:cpg),g(1:cpg))];
% Ratio of the area of the  RHS and LHS 
% (if R > 1, A1 > A2; if R < 1, A1 < A2)
Ra = [A1(1)/A2(1) A1(2)/A2(2)];


% Create struct for output
% Gaussian curve
gauss.height = pks2; gauss.location = locs2; gauss.width = wdt2;
gauss.mu = mu(2); gauss.sigma = sigma(2); 
gauss.kurtosis = kurt(2); gauss.skewness = skew(2);
gauss.area = Area(2); gausa.RA = Ra(2);
% Identified peak
peak.height = pks1; peak.location = locs1; peak.width = wdt1;
peak.mu = mu(1); peak.sigma = sigma(1);
peak.kurtosis = kurt(1); peak.skewness = skew(1);
peak.area = Area(1); peak.Ra = Ra(1);


% Optional Output
vars={X,Y,g,peak,gauss};
varargout=vars(1:nargout);

end

