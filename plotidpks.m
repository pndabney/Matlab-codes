function varargout=plotidpks(x,y,locs,freqs,frange,ptype)
% [P1]=plotidpks(x,y,locs,freqs,frange,ptype);
%
% Plots identified peaks and compares them to known mode frequencies.
%
% Input:
%
% y         Data array (1-D)
% x         Corresponding x-axis data array, in millihertz (1-D)
% locs      Vector containing locations of identified peaks, in millihertz 
% freqs     Vector containing mode frequencies of interest, in millihertz 
% frange    Frequency range of interest, in millihertz  (format: [f1 f2])
% ptype     0 regular plot
%           1 log scale on x-axis
%           2 log scale on y-axis [default]
%           3 log-log scale plot
%
% Output: 
%
% P1        Used for plotting
%
% Last modified by pdabney@princeton.edu, 9/9/21

% Ensure f1 < f2 in frange
frange = sort(frange);

% Only get data within range of interest
in = find(x >= frange(1) & x <= frange(2));
X = x(in); Y = y(in);

% Get y-axis limits for different plot types
% y limits for NO y-axis log scale
nlylim = [min(Y)-1e8 max(Y)+1e8];
% y limits for y-axis log scale
lsylim = [min(Y)+5e4 max(Y)+5e9];

% Number of peaks identified 
ipks = length(locs);

%-----------------------------------------------------------------------------------------------------------
% Set up figure
f = figure('Units', 'centimeters', 'Position', [0.05, 2.8, 18, 16], 'PaperPositionMode','Auto');
%figure(gcf); clf;
set(gca, 'LineWidth', 1.25, 'FontSize', 8);

% Plot of known mode frequencies
hx1 = subplot(211);
set(hx1,'Position',[0.15, .57, .8, .32]);
ax1 = gca;
if ptype == 0
    P=plot(X,Y,'LineWidth',2); hold on;
    ylimits = nlylim;
elseif ptype == 1
    P=semilogx(X,Y,'LineWidth',2); hold on;
    ylimits = nlylim;
elseif ptype == 2
    P=semilogy(X,Y,'LineWidth',2); hold on;
    ylimits = lsylim;
elseif ptype == 3
    P=loglog(X,Y,'LineWidth',2); hold on;
    ylimits = lsylim;
end
pf=plot([freqs'; freqs'], ylimits, 'r', 'LineWidth',0.1); hold off;

title(sprintf('N=%.f',ipks)); ylabel({'Spectral Density', '(Energy/Hz)'});
axis tight; uistack(P,'top');
ax1.XGrid = 'off'; ax1.YGrid = 'on'; 
set(ax1,'xticklabel',[]);

if exist('p1')
    legend({'Widmer & Masters'});
end

% Plot of identified peaks
hx2 = subplot(212);
set(hx2,'Position',[0.15, .22, .8, .32]);

if ptype == 0
    P=plot(X,Y,'LineWidth',2); hold on;
    ylimits = nlylim;
elseif ptype == 1
    P=semilogx(X,Y,'LineWidth',2); hold on;
    ylimits = nlylim;
elseif ptype == 2
    P=semilogy(X,Y,'LineWidth',2); hold on;
    ylimits = lsylim;
elseif ptype == 3
    P=loglog(X,Y,'LineWidth',2); hold on;
    ylimits = lsylim;
end
pl=plot([locs'; locs'], ylimits, 'k', 'LineWidth', 0.1);

axis tight; uistack(P,'top');
hx2.XGrid = 'off'; hx2.YGrid = 'on';
xlabel('Frequency (mhz)'); ylabel({'Spectral Density', '(Energy/Hz)'})

if exist('p2')
    legend({'Estimated'});
end

%-------------------------------------------------------------------------------------------------------
% Optional output
varns={P,pf,pl};
varargout=varns(1:nargout);
      
end

