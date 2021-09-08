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
% peakinfo       Struct of information about peak of interest
% gaussfit       Struct of information about gaussian distribution 
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
[pks1,locs1,wdt1,prm1]=findpeaks(Y,X,'MinPeakHeight',thresh,'WidthReference','halfheight');
[pks2,locs2,wdt2,prm2]=findpeaks(g,X,'MinPeakHeight',thresh,'WidthReference','halfheight');


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
% Peak
peakinfo.Mean = mu(1); peakinfo.Standard_Deviation = sigma(1);
peakinfo.Height = pks1; peakinfo.Location = locs1;
peakinfo.Width = wdt1; peakinfo.Prominence = prm1;
peakinfo.Area = Area(1); peakinfo.RA = Ra(1);
peakinfo.Skewness = skw(1); peakinfo.Kurtosis = kurt(1);
% Gaussian Distribution
gaussfit.Mean = mu(2); gaussfit.Standard_Deviation = sigma(2);
gaussfit.Height = pks2; gaussfit.Location = locs2;
gaussfit.Width = wdt2; gaussfit.Prominence = prm2;
gaussfit.Area = Area(2); gaussfit.RA = Ra(2);
gaussfit.Skewness = skw(2); gaussfit.Kurtosis = kurt(2);


% Optional Output
vars={X,Y,g,peakinfo,gaussfit};
varargout=vars(1:nargout);

end

