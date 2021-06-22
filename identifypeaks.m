function varargout=identifypeaks(x,y,freqs,thresh)
% [pks, locs, width, prom]=IDENTIFYPEAKS(x,y,freqs,thresh)
%
% Identify peaks in  data that meet a specified threshold
%
% Input:
%
% y              Data (1-D)
% x              Corresponding x-axis data (1-D)
% freqs          Vector containing mode frequencies of interest
% thresh         Minimum height difference between a peak and its neighbors
%
% Output:
%
% pks            Vector with local maxima (peaks) 
% locs           Location where peaks occur
% width          Width of the peaks
% prom           Prominence of the peaks
%
% NOTE:
%
% In the frequency range of 0.2-1.0 mHz (0S2 0T2 2S1 0S3 0T3 0S4 1S2 0T4 0S0 0S5 1S3 3S1 2S2)
% Data from  Free Oscillations: Frequencies and Attenuations by Masters and Widmer 1995
%
% [seisdata,Hdr,~,~,t]=readsac('~/Documents/Esacfiles/sacfiles/sumatra/vstim/velp_IU.ANMO.00.BHZ.2004.361.20.58.52.9d.SAC',0,'l',0);
% lwin=length(seisdata)/1.5; olap=70; nfft=lwin; Fs=1./Hdr.DELTA;
% [SD,F,Ulog,Llog,Ulin,Llin,Snon,Qnon,Qrob,Qchi]=pchave(seisdata,lwin,olap,nfft,Fs);
% freqs = [0.30945 0.3773 0.40396 0.46855 0.5876 0.6468 0.680 0.7669 0.81439 0.84008 0.9396 0.9442 0.93785]*1e-3; % [mHz]
%
% [pks, locs, width, prom]=identifyingpeaks(F,SD,freqs,5e6);
%
% Last modified by pdabney@princeton.edu, 6/22/21


% Find peaks in the data
[pks, locs, width, prom] = findpeaks(SD,1./(F(2)-F(1)),'Threshold',thresh);
freqrange = zeros(length(freqs),2);
i = 1:length(freqs);
freqrange(i,1) = freqs(i) + 9.5e-6;
freqrange(i,2) = freqs(i) - 9.5e-6;


for j = 1:length(freqs)-1
    for k = length(locs):-1:1
        if locs(k) > freqrange(j,1) && locs(k) < freqrange(j+1,2)
            locs(k)=[];
        end
    end
end

% Deal with the end points
for k = length(locs):-1:1
    if (locs(k) > freqrange(length(freqs),1))
        locs(k)=[];
    end
end

% Need to adjust the lower bound for this specific frequency range
for k = length(locs):-1:1
    if (locs(k) < freqrange(1,2) - 1e-5) 
        locs(k)=[];
    end
end


% Plot of mode frequencies in power spectrum
f = figure('Units', 'centimeters', 'Position', [0.05, 2.8, 18, 16], 'PaperPositionMode','Auto');
set(gca, 'LineWidth', 1.25, 'FontSize', 8);
hx1 = subplot(211);
set(hx1,'Position',[0.17, .55, .8, .3]);
ax1 = gca; 
ax1.XAxis.Exponent=0; %ax1.YAxis.Exponent=0;
ax1.XGrid = 'off'; ax1.YGrid = 'on';
box on;
hold on;
for i = 1:length(freqs)
    p1=plot([freqs(i) freqs(i)], [0 12*10^9], 'r', 'LineWidth',0.1)
end
plot(F,SD,'LineWidth',1);
xlim([0.0002 0.001]);
hold off;
set(ax1,'xticklabel',[]);
ylabel({'Spectral Density', '(Energy/Hz)'});
legend([p1],{'Widmer & Masters'});
hx2 = subplot(212);
set(hx2,'Position',[0.17, .22, .8, .3]);
hx2.XGrid = 'off'; hx2.YGrid = 'on';
hx2.XAxis.Exponent=0; %hx2.YAxis.Exponent=0;
box on; 
hold on;
for i = 1:length(locs)
    p2=plot([locs(i) locs(i)], [0 12*10^9], 'k', 'LineWidth', 0.1)
end
plot(F,SD,'LineWidth',1);
xlim([0.0002 0.001]);
hold off;
xlabel('Frequency (Hz)'); ylabel({'Spectral Density', '(Energy/Hz)'});
legend([p2],{'Estimated'});




% Additional info
peaksfound = length(locs);
numpeaks = length(freqs);


% Optional output
varns={pks,locs,width,prom,peaksfound,numpeaks};
varargout=varns(1:nargout);
end

