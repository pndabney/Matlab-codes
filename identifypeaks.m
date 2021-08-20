function varargout=identifypeaks(x,y,freqs,frange,thresh,ptype,units)
% [pks,locs,width,prom,nfreqs,ipks,P1]=IDENTIFYPEAKS(x,y,freqs,frange,thresh,ptype,units)
%
% Identify and plot peaks given a specified threshold.
%
% Input:
%
% y              Data (1-D)
% x              Corresponding x-axis data (1-D)
% freqs          Vector containing mode frequencies of interest
% frange         Frequency range of interest, in hertz (format: [f1 f2])
% thresh         Minimum height difference between a peak and its neighbors
% ptype          0 regular plot
%                1 log scale on x-axis
%                2 log scale on y-axis [default]
%                3 log-log scale plot
% units          0 Hertz
%                1 Millihertz [default]
%                2 Microhertz
% Output:
%
% pks            Vector with local maxima (peaks) 
% locs           Location where peaks occur
% width          Width of the peaks
% prom           Prominence of the peaks
% nfreqs         Number of mode frequencies
% ipks           Number of identified peaks
% P1             Seismic Data used for plots
%
% NOTE:
%
% Data from  Free Oscillations: Frequencies and Attenuations by Masters and Widmer 1995.
%
% Last modified by pdabney@princeton.edu, 8/19/21

% Default values
defval('ptype',2)
defval('units',1)
defval('thresh',2.5e7)

% Unit Converison
if units == 0
    ucon = 1;
elseif units == 1
    ucon = 1e3;
elseif units == 2
    ucon = 1e6;
end

% Convert x data units
x = x*ucon;
% Convert frequency units
freqs = freqs*ucon;
% Distannce range around frequency of interest
freqd = 9.5*1e-6*ucon;
% Lower bound frequency adjustment
freqb = 1e-5*ucon;

% Adjust x and y limits to correspond with conversion
exlim = frange*ucon; % Will need to make this an input range in the future
in = find(x >= exlim(1) & x <= exlim(2));
% y limits for ptype=0,1
p01ylim = [-5e8 max(y(in))+1e8];
% y limits for ptype=2,3
p23ylim = [min(y(in))+5e4 max(y(in))+5e9];

%-------------------------------------------------------------------------------------
% Find peaks in the data
[pks, locs, width, prom] = findpeaks(y,x,'MinPeakHeight',thresh); 
freqrange = zeros(length(freqs),2);
freqrange(:,1) = freqs + freqd;
freqrange(:,2) = freqs - freqd;
% Eliminate peaks that are not within a specified frequency range
% Deal with the upperbound
Ku=find(locs > freqrange(length(freqs),1));
locs(Ku)=[]; pks(Ku)=[]; prom(Ku)=[]; width(Ku)=[];
% Deal with the middle section
for j = 1:length(freqs)-1
    Km = find(locs > freqrange(j,1) & locs < freqrange(j+1,2));
    locs(Km)=[]; pks(Km)=[]; prom(Km)=[]; width(Km)=[];
end
% Need to adjust the lower bound for this specific frequency range
Kl=find(locs < freqrange(1,2) - freqb);
locs(Kl)=[]; pks(Kl)=[]; prom(Kl)=[]; width(Kl)=[];

% Additional info
% Peaks identified
ipks = length(locs);
% Number of frequencies 
nfreqs = length(freqs);

%------------------------------------------------------------------------------------
% Plot of mode frequencies in power spectrum
f = figure('Units', 'centimeters', 'Position', [0.05, 2.8, 18, 16], 'PaperPositionMode','Auto');
%figure(gcf); clf;
set(gca, 'LineWidth', 1.25, 'FontSize', 8);
hx1 = subplot(211);
set(hx1,'Position',[0.15, .57, .8, .32]);
ax1 = gca; 
if ptype == 0
    P1=plot(x,y,'LineWidth',2);    
    hold on;
    p1=plot([freqs freqs], p01ylim, 'r', 'LineWidth',0.1);
    hold off;
    ylim(p01ylim)
elseif ptype == 1
    P1=semilogx(x,y,'LineWidth',2);
    hold on;
    p1=plot([freqs freqs], p01ylim, 'r', 'LineWidth',0.1);
    hold off;
    ylim(p01ylim)
elseif ptype == 2
    P1=semilogy(x,y,'LineWidth',2);
    hold on;
    p1=plot([freqs freqs], p23ylim, 'r', 'LineWidth',0.1);
    hold off;
    ylim(p23ylim)
elseif ptype == 3
    P1=loglog(x,y,'LineWidth',2);    
    hold on;
    p1=loglog([freqs freqs], p23ylim, 'r', 'LineWidth',0.1);
    hold off;
    ylim(p23ylim)
end
uistack(P1,'top');
xlim(exlim)
ax1.XGrid = 'off'; ax1.YGrid = 'on';
set(ax1,'xticklabel',[]);
ylabel({'Spectral Density', '(Energy/Hz)'});
if exist('p1')
    legend({'Widmer & Masters'});
end
hx2 = subplot(212);
set(hx2,'Position',[0.15, .22, .8, .32]);
if ptype == 0
    P2=plot(x,y,'LineWidth',2);
    hold on;
    p2=plot([locs locs], p01ylim, 'k', 'LineWidth', 0.1);
    hold off;
    ylim(p01ylim)
elseif ptype == 1
    P2=semilogx(x,y,'LineWidth',2);
    hold on;
    p2=plot([locs locs], p01ylim, 'k', 'LineWidth', 0.1);
    hold off;
    ylim(p01ylim)
elseif  ptype == 2
    P2=semilogy(x,y,'LineWidth',2);
    hold on;
    p2=plot([locs locs], p23ylim, 'k', 'LineWidth', 0.1);
    hold off;
    ylim(p23ylim)
elseif ptype == 3
    P2=loglog(x,y,'LineWidth',2);
    hold on;
    p2=plot([locs locs], p23ylim, 'k', 'LineWidth', 0.1);
    hold off
    ylim(p23ylim)
end
uistack(P2,'top');
hx2.XGrid = 'off'; hx2.YGrid = 'on';
xlim(exlim)
ylabel({'Spectral Density', '(Energy/Hz)'})

% Determine Frequency unit label
if units == 0
    xlabel('Frequency (Hz)') 
elseif units == 1
    xlabel('Frequency (mHz)')
elseif units == 2
    xlabel('Frequency (\muHz)')
else
    warning('Frequency units unspecified')
    xlabel('Frequency')
end

if exist('p2')
    legend({'Estimated'});
end

%-----------------------------------------------------------------------------------------
% Optional output
varns={pks,locs,width,prom,freqs,nfreqs,ipks,P1};
varargout=varns(1:nargout);
end
