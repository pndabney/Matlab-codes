function varargout=singlepktest(x,y,Hdr,freq,ptype,Ubnd,Lbnd,lwin,olap)
% [p,l,T,N,Nwin,dt,olap]=singlepktest(x,y,Hdr,ptype,Ubnd,Lbnd,lwin,olap)
%
% Creates a spectral density estimate plot including confidence intervals, focused 
% on one frequency of interest.
%
% Input:
%
% y              Data (1-D)
% x              Corresponding x-axis data (1-D)
% Hdr            Header struct
% freq           Mode frequency of interest
% ptype          0 regular plot
%                1 log scale on x-axis [default]
%                2 log scale on y-axis
%                3 log-log scale plot
% Ubnd           Upper confidence limit
% Lbnd           Lower confidence limit
% olap           Percent overlap
%
%
% Output:
%
% p             Axis handles to the lines plotted
%               1 the spectral density, as a line
%               2 the lower uncertainty interval
%               3 the bound uncertainty interval
%               4 the first set of 10 points of the spectral density
% l             Vertical line plot at the mode frequency of interest
% T             Duration (hr)
% N             Window Length (hr)
% Nwin          Number of windows
% dt            Sampling period (s)
% olap          Percent overlap
%
% Note:
%
% [seisdata,Hdr,~,~,t]=readsac('~/Documents/Esacfiles/sacfiles/sumatra/vstim/velp_IU.ANMO.00.BHZ.2004.361.20.58.52.9d.SAC',0,'l',0);
% lwin=length(seisdata)/1.5; olap=70; nfft=lwin; Fs=1./Hdr.DELTA;
% [SD,F,Ulog,Llog,Ulin,Llin,Snon,Qnon,Qrob,Qchi]=pchave(seisdata,lwin,olap,nfft,Fs);
% [p,l,T,N,Nwin,dt,olap]=singlepktest(F,SD,Hdr,8.1439e-04,0,Ulog,Llog,lwin,olap);
%
% Last modified by pdabney@princeton.edu, 7/02/21

% Default values
defval('ptype',1)

% Convert to millihertz
ucon = 1e3;
x = x*ucon;
freq = freq*ucon;
% frequency window distance
fdist = 1e-4*ucon;

% Determine indexes for range of interest
frange = find(x>= freq-fdist & x<= freq+freqfdist);

%----------------------------------------------------------------------------------
% Bounds are specific to mode frequency 8.1439e-04, change limits for other frequencies
% y limit lower bound buffer
ylbnd1 = 1e8;
ylbnd2 = 1e6;

% y limit upper bound buffer
yubnd1 = 1e9;
yubnd2 = 2.5e9;

%----------------------------------------------------------------------------------
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

% Sampling rate (s)
dt = Hdr.DELTA;
% Duration (Hr)
T = Hdr.E/3600;
% Length of window (Hr)
N = (lwin*dt)/3600;
% Number of windows
Nwin = round(Hdr.NPTS/lwin);

%----------------------------------------------------------------------------------
% Create plot
figure
if ptype == 0
    p(3)=plot(x,Ubnd); hold on
    p(2)=plot(x,Lbnd);
    p(1)=plot(x,y);
    p(4)=plot(x(1:10),y(1:10),'+');
    l=plot([freq freq], eylim, 'k', 'LineWidth',0.1);
    hold off
    xlim([freq-fdist freq+fdist])
    ylim(eylim)
elseif ptype == 1
    p(3)=semilogx(x,Ubnd); hold on
    p(2)=semilogx(x,Lbnd);
    p(1)=semilogx(x,y);
    p(4)=semilogx(x(1:10),y(1:10),'+');
    l=plot([freq freq], eylim, 'k', 'LineWidth',0.1);
    hold off
    xlim([freq-fdist freq+fdist])
    ylim(eylim)
elseif ptype == 2
    p(3)=semilogy(x,Ubnd); hold on
    p(2)=semilogy(x,Lbnd);
    p(1)=semilogy(x,y);
    p(4)=semilogy(x(1:10),y(1:10),'+');
    l=plot([freq freq], eylim, 'k', 'LineWidth',0.1);
    hold off
    xlim([freq-fdist freq+fdist])
    ylim(eylim)
elseif ptype == 3
    p(3)=loglog(x,Ubnd); hold on
    p(2)=loglog(x,Lbnd); 
    p(1)=loglog(x,y); 
    p(4)=loglog(x(1:10),y(1:10),'+'); 
    l=plot([freq freq], eylim, 'k', 'LineWidth',0.1);
    hold off
    xlim([freq-fdist freq+fdist]) 
    ylim(eylim)
end
grid on
legend('Upper Bound','Lower Bound','Data')
xlabel('Frequency (mHz)')
ylabel('Spectral Density (Energy/Hz)')
title(sprintf('T = %.f, N = %.f, Nwin = %.f, olap = %.f, \n dt = %.f, taper = dpss, NW = 4 ',...
              T,N,Nwin,olap,dt))


%----------------------------------------------------------------------------------
% Optional Output
vars={p,l,T,N,Nwin,olap,dt};
varargout=vars(1:nargout);

end

