function varargout=singlepktest(fname,freq,fwd,olap,num,ptype,thresh,plotornot)
% [p,l,g,peakinfo,gaussfit,T,N,Nwin,dt,olap,sigma,mu]=singlepktest(fname,freq,fwd,olap,num,ptype,thresh,plotornot)
%
% Creates a spectral density estimate plot including confidence intervals, focused 
% on one frequency of interest. 
%
% Input:
%
% fname          Filename, full path included
% freq           Mode frequency of interest
% fwd            Frequency window distance from the center (half the full length of the window)
% olap           Percent overlap
% num            Number of segments for window length for pchave
% ptype          0 regular plot
%                1 log scale on x-axis [default]
%                2 log scale on y-axis
%                3 log-log scale plot
% thresh         Threshold, minimum peak height
% plotornot      0 does not plot [default]
%                1 creates a plot
%
% Output:
%
% p             Axis handles to the lines plotted
%               1 the spectral density, as a line
%               2 the lower uncertainty interval
%               3 the bound uncertainty interval
%               4 the first set of 10 points of the spectral density
%               5 the gaussian distribution
% l             Vertical line plot at the mode frequency of interest
% g             Fitted gaussian distribution curve
% peakinfo      Structure array of information about the peak
% gaussfit      Structure array with information about the gaussian distribution
% T             Duration (hr)
% N             Window Length (hr)
% Nwin          Number of windows
% dt            Sampling period (s)
% sigma         Standard Deviation of the data
% mu            Mean of the data
%
% Note:
%
% Requires respository slepian_oscar and slepian_alpha. See PCHAVE and DEFVAL.
% 
% Example:
%
% fwd = 5e-5; freq = 8.1439e-04; olap = 70; num = 2; ptype = 2; thresh = 1e9;
% fname = '~/Documents/Esacfiles/sacfiles/sumatra/vstim/velp_IU.ANMO.00.BHZ.2004.361.20.58.52.9d.SAC';
% [p,l,g,peakinfo,gaussfit,T,N,Nwin,dt,olap,sigma,mu]=singlepktest(fname,freq,fwd,olap,num,ptype,thresh);
%
% Last modified by pdabney@princeton.edu, 7/13/21


% Default values
defval('ptype',2)
defval('freq',8.1439e-04)
defval('thresh',1e9)
defval('olap',70)
defval('fwd',5e-5)
defval('num',2)


%----------------------------------------------------------------------------------
% Bounds are specific to mode frequency 8.1439e-04, change limits for other frequencies
% y limit lower bound buffer
ylbnd1 = 1e8;
ylbnd2 = 1e6;
% y limit upper bound buffer
yubnd1 = 1e9;
yubnd2 = 2.5e9;

%----------------------------------------------------------------------------------
% Unit Conversion
% hertz to millihertz
ucon = 1e3;
% seconds to hours
s2h = 1/3600;

% Read in data
[seisdata,Hdr,~,~,t]=readsac(fname);

% Input variables for pchave
L = length(seisdata);
lwin = round(L/num); Fs = 1./Hdr.DELTA; nfft = lwin;
[SD,F,Ulog,Llog,Ulin,Llin,Snon,Qnon,Qrob,Qchi]=pchave(seisdata,lwin,olap,nfft,Fs);

% Convert data to millihertz
F = F*ucon;
omega = freq*ucon;
fdist = fwd*ucon;
% Determine indexes for range of interest
frange = find(F>= omega-fdist & F<= omega+fdist);

% Computations for figure
% Sampling rate (s)
dt = 1/Fs;
% Duration (Hr)
T = Hdr.E*s2h;
% Length of window (Hr)
N = (lwin*dt)*s2h;
% Number of windows
Nwin = round(Hdr.NPTS/lwin);


% Examine peak 
[X,Y,sigma,mu,g,pks,locs,wdt,prm,Ra,skw,kurt]=examinepk(F,SD,omega,frange,ptype,thresh);
% Create struct for peak
peakinfo.mean = mu(1); peakinfo.standard_deviation = sigma(1);
peakinfo.height = pks(1); peakinfo.location = locs(1);
peakinfo.width = wdt(1); peakinfo.prominence = prm(1);
peakinfo.skewness = skw(1); peakinfo.kurtosis = kurt(1);
% Create struct for gaussian distribution
gaussfit.mean = mu(2); gaussfit.standard_deviation = sigma(2);
gaussfit.height = pks(2); gaussfit.location = locs(2);
gaussfit.width = wdt(2); gaussfit.prominence = prm(2);
gaussfit.skewness = skw(2); gaussfit.kurtosis = kurt(2);


%----------------------------------------------------------------------------------
if plotornot == 1
    % Determine y axis limits
    if ptype == 0
        eylim = [min(Y)-ylbnd1 max(Y)+yubnd1];
    elseif ptype == 1
        eylim  = [min(Y)-ylbnd1 max(Y)+yubnd1];
    elseif ptype == 2
        eylim = [min(Y)-ylbnd2 max(Y)+yubnd2];
    elseif ptype == 3
        eylim = [min(Y)-ylbnd2 max(Y)+yubnd2];
    else
        error('Ptype does no exisit')
    end
    
    % Create plot
    figure(gcf); clf
    if ptype == 0
        p(3)=plot(F,Ulog); hold on
        p(2)=plot(F,Llog);
        p(1)=plot(F,SD,'LineWidth',2);
        p(4)=plot(F(1:10),SD(1:10),'+');
        l(1)=plot([freq freq], eylim, 'k', 'LineWidth',0.1);
        p(5)=plot(X,g,'--k', 'LineWidth',2);
        hold off
        xlim([X(1) X(end)])
        ylim(eylim)
    elseif ptype == 1
        p(3)=semilogx(F,Ulog); hold on
        p(2)=semilogx(F,Llog);
        p(1)=semilogx(F,SD,'LineWidth',2);
        p(4)=semilogx(F(1:10),SD(1:10),'+');
        l(1)=plot([freq freq], eylim, 'k', 'LineWidth',0.1);
        p(5)=semilogx(X,g,'--k', 'LineWidth',2);
        hold off
        xlim([X(1) X(end)])
        ylim(eylim)
    elseif ptype == 2
        p(3)=semilogy(F,Ulog); hold on
        p(2)=semilogy(F,Llog);
        p(1)=semilogy(F,SD,'LineWidth',2);
        p(4)=semilogy(F(1:10),SD(1:10),'+');
        l(1)=plot([freq freq], eylim, 'k', 'LineWidth',0.1);
        p(5)=semilogy(X,g,'--k', 'LineWidth',2);
        hold off
        xlim([X(1) X(end)])
        ylim(eylim)
    elseif ptype == 3
        p(3)=loglog(F,Ulog); hold on
        p(2)=loglog(F,Llog);
        p(1)=loglog(F,SD,'LineWidth',2);
        p(4)=loglog(F(1:10),SD(1:10),'+');
        l(1)=plot([freq freq], eylim, 'k', 'LineWidth',0.1);
        p(5)=loglog(X,g,'--k', 'LineWidth',2);
        hold off
        xlim([X(1) X(end)])
        ylim(eylim)
    end
    grid on
    legend([p(3) p(2) p(1) p(5)],{'Upper limit','Lower limit','Spectral Density','Gaussian Distribution'})
    xlabel('Frequency (mHz)')
    ylabel('Spectral Density (Energy/Hz)')
    title(sprintf('T = %.f, N = %.f, Nwin = %.f, olap = %.f, \n dt = %.f, taper = dpss, NW = 4 ',...
                  T,N,Nwin,olap,dt))



    % Optional Output
    vars={p,l,g,peakinfo,gaussfit,T,N,Nwin,dt,sigma,mu};
    varargout=vars(1:nargout);
else
    % Optional Output
    vars={g,peakinfo,gaussfit,T,N,Nwin,dt,sigma,mu};
    varargout=vars(1:nargout);
end



end

