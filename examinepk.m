function varargout=examinepk(x,y,freq,ptype,lwin,olap,thresh,T,N,Nwin,dt)
% [p,l,sigma,mu,g,pks,locs,wdt,prm,fw,Ra,skw,kurt]=examinepk(x,y,freq,ptype,lwin,olap,thresh,T,N,Nwin,dt)
%
% Examines the size and shape, mean and standard deviation, and fits a gaussian distribution to a single peak of interest. 
% In addition, a spectral density estimate plot centered on a single peak of interest is produced overlaying a gaussian 
% distribution plot.
%
% Input:
%
% y              Data (1-D)
% x              Corresponding x-axis data (1-D)
% freq           Mode frequency of interest
% ptype          0 regular plot
%                1 log scale on x-axis [default]
%                2 log scale on y-axis
%                3 log-log scale plot
% olap           Percent overlap
% thresh         Threshold, minimum peak height
% T              Duration (hr)
% N              Window Length (hr)
% Nwin           Number of windows
% dt             Sampling period (s)
% 
% Output:
%
% p              Axis handles to the lines plotted
%                1 the spectral density, as a line
%                2 the gaussian distribution
% l              Vertical line plot at the mode frequency of interest
% sigma          Standard Deviation (1 spectral density, 2 gaussian function)
% mu             Mean (1 spectral density, 2 gaussian function)
% g              Gaussian Curve
% pks            Peak height (1 spectral density, 2 gaussian function)
% locs           Location of peak (1 spectral density, 2 gaussian function) 
% wdt            Full width of peak at the half maximum 
%                (1 spectral density, 2 gaussian function)
% Ra             Ratio of the area of the LHS to the RHS
% skw            Skewness, measure of asymmetry of the data 
%                (1 spectral density, 2 gaussian function)
% kurt           Kurtosis, measure of how outlier-prone a distribution 
%                (1 spectral density, 2 gaussian function)

% Note:
%
% [seisdata,Hdr,~,~,t]=readsac('~/Documents/Esacfiles/sacfiles/sumatra/vstim/velp_IU.ANMO.00.BHZ.2004.361.20.58.52.9d.SAC',0,'l',0);
% lwin=round(length(seisdata)/2); olap=70; nfft=lwin; Fs=1./Hdr.DELTA;
% [SD,F,Ulog,Llog,Ulin,Llin,Snon,Qnon,Qrob,Qchi]=pchave(seisdata,lwin,olap,nfft,Fs);
% dt = Hdr.DELTA; T = Hdr.E*s2h; N = (lwin*dt)*s2h; Nwin = round(Hdr.NPTS/lwin);
% [p,l,sigma,mu,g,pks,locs,wdt,prm,fw,Ra,skw,kurt]=examinepk(F,SD,8.1439e-04,2,lwin,olap,1e9,T,N,Nwin,dt);
%
% Last modified by pdabney@princeton.edu, 7/12/21


% Convert to millihertz
ucon = 1e3;
x = x*ucon;
freq = freq*ucon;
% frequency window distance
fdist = 5e-5*ucon;
% Determine indexes for range of interest
frange = find(x>= freq-fdist & x<= freq+fdist);
X = x(frange);
Y = y(frange);

%----------------------------------------------------------------------------------
% Bounds are specific to mode frequency 8.1439e-04, change limits for other frequencies
% y limit lower bound buffer
ylbnd1 = 1e8;
ylbnd2 = 1e6;
% y limit upper bound buffer
yubnd1 = 1e9;
yubnd2 = 2.5e9;

%----------------------------------------------------------------------------------
% Compute Gaussian Distribution
[X,Y,cfit,e,res]=fitgauss(Y,X,freq,fdist,thresh,0);  
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
% Determine how outlier prone the distribution is
kurt = [kurtosis(Y) kurtosis(g)];

% Determine how symmetric the peak is
[Ra,skw]=howsymmetric(x,y,g,frange,locs(1));



% FOR PLOTTING
% y axis limits
if ptype == 0
    eylim = [min(y(frange))-ylbnd1 max(y(frange))+yubnd1];
elseif ptype == 1
    eylim  = [min(y(frange))-ylbnd1 max(y(frange))+yubnd1];
elseif ptype == 2
    eylim = [min(y(frange))-ylbnd2 max(y(frange))+yubnd2];
elseif ptype == 3
    eylim = [min(y(frange))-ylbnd2 max(y(frange))+yubnd2];
else
    error('Ptype does no exisit')
end

% Create plot
figure(gcf); clf
if ptype == 0
    p(1)=plot(x,y); hold on
    l(1)=plot([freq freq], eylim, 'k', 'LineWidth',0.1);
    p(2)=plot(x(frange),g,'r', 'LineWidth',1);
    hold off
    xlim([x(frange(1)) x(frange(end))])
    ylim(eylim)
elseif ptype == 1
    p(1)=semilogx(x,y); hold on
    l(1)=plot([freq freq], eylim, 'k', 'LineWidth',0.1);
    p(2)=semilogx(x(frange),g,'r', 'LineWidth',1);
    hold off
    xlim([x(frange(1)) x(frange(end))])
    ylim(eylim)
elseif ptype == 2
    p(1)=semilogy(x,y); hold on
    l(1)=plot([freq freq], eylim, 'k', 'LineWidth',0.1);
    p(2)=semilogy(x(frange),g,'r', 'LineWidth',1);
    hold off
    xlim([x(frange(1)) x(frange(end))])
    ylim(eylim)
elseif ptype == 3
    p(1)=loglog(x,y); hold on
    l(1)=plot([freq freq], eylim, 'k', 'LineWidth',0.1);
    p(2)=loglog(x(frange),g,'r', 'LineWidth',1);
    hold off
    xlim([x(frange(1)) x(frange(end))])
    ylim(eylim)
end
grid on
legend([p(1) p(2)],{'Spectral Density','Gauss Distribution'})
xlabel('Frequency (mHz)')
ylabel('Spectral Density (Energy/Hz)')
title(sprintf('T = %.f, N = %.f, Nwin = %.f, olap = %.f, \n dt = %.f, taper = dpss, NW = 4 ',...
              T,N,Nwin,olap,dt))


% Optional Output
vars={p,l,sigma,mu,g,pks,locs,wdt,prm,Ra,skw,kurt};
varargout=vars(1:nargout);

end


%---------------------------------------------------------------------------------
function [Ra,skw]=howsymmetric(x,y,g,frange,loc)
    % find center point
    cp = find(x == loc,1);
    % end and starting points
    ep = frange(end); sp = frange(1);
    
    % Area of the RHS
    A1 = trapz(x(cp:ep),y(cp:ep));
    % Area of the LHS
    A2 = trapz(x(sp:cp),y(sp:cp));
    % Ratio of the area of the  RHS and LHS 
    % if R > 1, A1 > A2; if R < 1, A1 < A2
    Ra = A1/A2;
    % Measure of the asymmetry of the data around the sample mean
    skw = [skewness(y(frange)) skewness(g)];
end
%----------------------------------------------------------------------------------

