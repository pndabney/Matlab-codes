function varargout=identifypeaks(x,y,freqs,thresh,ptype,units)
% [pks,locs,width,prom,nfreqs,ipks,P1]=IDENTIFYPEAKS(x,y,freqs,thresh,ptype)
%
% Identify peaks in  data that meet a specified threshold
%
% Input:
%
% y              Data (1-D)
% x              Corresponding x-axis data (1-D)
% freqs          Vector containing mode frequencies of interest
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
% In the frequency range of 0.2-1.0 mHz (0S2 0T2 2S1 0S3 0T3 0S4 1S2 0T4 0S0 0S5 1S3 3S1 2S2)
% Data from  Free Oscillations: Frequencies and Attenuations by Masters and Widmer 1995
%
% [seisdata,Hdr,~,~,t]=readsac('~/Documents/Esacfiles/sacfiles/sumatra/vstim/velp_IU.ANMO.00.BHZ.2004.361.20.58.52.9d.SAC',0,'l',0);
% lwin=length(seisdata)/1.5; olap=70; nfft=lwin; Fs=1./Hdr.DELTA;
% [SD,F,Ulog,Llog,Ulin,Llin,Snon,Qnon,Qrob,Qchi]=pchave(seisdata,lwin,olap,nfft,Fs);
% 
% T=readtable('/home/pdabney/Documents/MATLAB/gitrepo/Insight/masterswidmer.txt');
% T(1,:)=[]; T.freq_prem = str2double(T.freq_prem); T.freq_obs = str2double(T.freq_obs);  
% T.uncertainty = str2double(T.uncertainty);                                 
%
% freqs = T.freq_obs*1e-6; % Hz 
% freqs(isnan(freqs))=[];
%
% [pks,locs,width,prom,nfreqs,ipks,P1]=identifypeaks(F,SD,freqs,2.5e7,2,1);
%
% Last modified by pdabney@princeton.edu, 6/29/21

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
% Threshold for prominence
threshp = 5e8;
% Adjust x and y limits to correspond with conversion
exlim = [0.0002 0.001]*ucon;

% y limits for ptype=0,1
p01ylim = [-5e8 12e9];
% y limits for ptype=2,3
p23ylim = [5e4 max(y)];


% Find peaks in the data
[pks, locs, width, prom] = findpeaks(y,x,'Threshold',thresh); 
freqrange = zeros(length(freqs),2);
i = 1:length(freqs);
freqrange(i,1) = freqs(i) + freqd;
freqrange(i,2) = freqs(i) - freqd;

% Eliminate peaks that are not within a specified frequency range
% Deal with the upperbound
for k = length(locs):-1:1
    if (locs(k) > freqrange(length(freqs),1))
        locs(k)=[];
        width(k)=[];
        prom(k)=[];
        pks(k)=[];
    end
end

% Deal with the middle section
for j = 1:length(freqs)-1
    for k = length(locs):-1:1
        if locs(k) > freqrange(j,1) && locs(k) < freqrange(j+1,2)
            locs(k)=[];
            width(k)=[];
            prom(k)=[];
            pks(k)=[];
        end
    end
end

% Need to adjust the lower bound for this specific frequency range
for k = length(locs):-1:1
    if (locs(k) < freqrange(1,2) - freqb) 
        locs(k)=[];
        width(k)=[];
        prom(k)=[];
        pks(k)=[];
    end
end

% Eliminate peaks based on prominence
for k = length(prom):-1:1
    if prom(k) < threshp
       prom(k)=[];
       locs(k)=[];
       width(k)=[];
       pks(k)=[];
   end
end

% Additional info
% Peaks identified
ipks = length(locs);
% Number of frequencies 
nfreqs = length(freqs);

%--------------------------------------------------------------------------------
% Plot of mode frequencies in power spectrum
f = figure('Units', 'centimeters', 'Position', [0.05, 2.8, 18, 16], 'PaperPositionMode','Auto');
%figure(gcf); clf;
set(gca, 'LineWidth', 1.25, 'FontSize', 8);
hx1 = subplot(211);
set(hx1,'Position',[0.15, .57, .8, .32]);
ax1 = gca; 
%ax1.XAxis.Exponent=0; %ax1.YAxis.Exponent=0;
if ptype == 0
    P1=plot(x,y,'LineWidth',2);    
    hold on;
    for i = 1:length(freqs)
        p1=plot([freqs(i) freqs(i)], p01ylim, 'r', 'LineWidth',0.1);
    end
    hold off;
    ylim(p01ylim)
elseif ptype == 1
    P1=semilogx(x,y,'LineWidth',2);
    hold on;
    for i = 1:length(freqs)
        p1=plot([freqs(i) freqs(i)], p01ylim, 'r', 'LineWidth',0.1);
    end
    hold off;
    ylim(p01ylim)
elseif ptype == 2
    P1=semilogy(x,y,'LineWidth',2);
    hold on;
    for i = 1:length(freqs)
        p1=plot([freqs(i) freqs(i)], p23ylim, 'r', 'LineWidth',0.1);
    end
    hold off;
elseif ptype == 3
    P1=loglog(x,y,'LineWidth',2);    
    hold on;
    for i = 1:length(freqs)
        p1=loglog([freqs(i) freqs(i)], p23ylim, 'r', 'LineWidth',0.1);
    end
    hold off;
end
uistack(P1,'top');
xlim(exlim)
ax1.XGrid = 'off'; ax1.YGrid = 'on';
set(ax1,'xticklabel',[]);
ylabel({'Spectral Density', '(Energy/Hz)'});
if exist('p1')
    legend([p1],{'Widmer & Masters'});
end
hx2 = subplot(212);
set(hx2,'Position',[0.15, .22, .8, .32]);
%hx2.XAxis.Exponent=0; %hx2.YAxis.Exponent=0;
if ptype == 0
    P2=plot(x,y,'LineWidth',2);
    hold on;
    for i = 1:length(locs)
        p2=plot([locs(i) locs(i)], p01ylim, 'k', 'LineWidth', 0.1);
    end
    hold off;
    ylim(p01ylim)
elseif ptype == 1
    P2=semilogx(x,y,'LineWidth',2);
    hold on;
    for i = 1:length(locs)
        p2=plot([locs(i) locs(i)], p01ylim, 'k', 'LineWidth', 0.1);
    end
    hold off;
    ylim(p01ylim)
elseif  ptype == 2
    P2=semilogy(x,y,'LineWidth',2);
    hold on;
    for i = 1:length(locs)
        p2=plot([locs(i) locs(i)], p23ylim, 'k', 'LineWidth', 0.1);
    end
    hold off;
elseif ptype == 3
    P2=loglog(x,y,'LineWidth',2);
    hold on;
    for i = 1:length(locs)
        p2=plot([locs(i) locs(i)], p23ylim, 'k', 'LineWidth', 0.1);
    end
    hold off
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
    legend([p2],{'Estimated'});
end


% Optional output
varns={pks,locs,width,prom,nfreqs,ipks,P1};
varargout=varns(1:nargout);
end


