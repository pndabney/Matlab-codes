function varargout=fitgauss(y,x,freq,frange,thresh,plotornot)
% [X,Y,cfit,gof,e,res]=fitguass(y,x,freq,frange,thresh,plotornot)
%
% Fit gaussian distribution curve to single peak of interest.
%
% Input:
% 
% y              Data (1-D)
% x              Corresponding x-axis data (1-D)
% freqs          Vector containing mode frequencies of interest
% frange         Vector containing frequency range of interest
% thresh         Minimum height difference between a peak and its neighbors
% plotornot      0 does not plot 
%                1 plot
%
% Output:
%
% Y              Data in specifed frequency range of interest (1-D)             
% X              Corresponding x-axis data (1-D)
% cfit           Gaussian curve fit result
% e              Root mean squared error
% res            Residuals, as vector
%
% Example:
%
% N = 2000;Fs = 1000;T = 1/Fs;
% x = (0:N-1)*T; y = sin(2*pi*120*x) + randn(size(x));
% lwin = round(N/2); olap = 70;
% [SD,F,Ulog,Llog,Ulin,Llin,Snon,Qnon,Qrob,Qchi]=pchave(y,lwin,olap,lwin,Fs);
% freq = 120; fdist = 50; 
% [X,Y,cfit,gof,e,res]=fitgauss(SD,F,freq,fdist,0.1,0);
%
% Last modified by pdabney@princeton.edu, 7/13/21


X = x(frange);
Y = y(frange);
[pks,locs,wdt,~]=findpeaks(Y,X,'Threshold',thresh,'WidthReference','halfheight');
% Ensure there is only one peak
if length(pks) > 1
    error('Must obtain a single peak')
end

% Choose starting points for fit
[i,j]=max(Y);
gmodel = fittype('a1*exp(-((x-b1)/c1)^2)');
[cfit,gof,output] = fit(X,Y,gmodel,'StartPoint',[i X(j) wdt]);

% Residuals
res = output.residuals;
% Root mean square error
e = gof.rmse;

% Optional Figure
if plotornot == 1
    figure(clf);
    plot(X,Y,'ok'); hold on
    plot(cfit,'r'); hold off
    xlim([X(1) X(end)])
    ylabel('Spectral Density (Energy/Hz)')
    xlabel('Frequency (Hz)')
    legend({'Spectral Density','Best Fit Gaussian'})
elseif plotornot == 0
    % Do not plot
end

% Optional Output
vars={X,Y,cfit,gof,e,res};
varargout=vars(1:nargout);

end

