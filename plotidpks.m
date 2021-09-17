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
% Last modified by pdabney@princeton.edu, 9/10/21

% Y limit constant as a buffer for plotting (change as needed)
ybuff = 1e8;

% Obtain data arrays only within range of interest
[X,Y] = inrange(x,y,frange);

% Get y-axis limits for different plot types
% y limits for NO y-axis log scale
nlylim = [min(Y)-ybuff max(Y)+ybuff];
% y limits for y-axis log scale
lsylim = [min(Y) max(Y)+ybuff];

% Determine y limits 
if (ptype == 0 || ptype == 1)
    ylimits = nlylim;
elseif (ptype == 2 || ptype == 3)
    ylimits = lsylim;
end

% Determine upper x-axis scale
if (ptype == 0 || ptype== 2)
    xscale = 'linear';
elseif (ptype == 1 || ptype == 3)
    xscale = 'log';
end

% Number of peaks identified 
ipks = length(locs);

%-----------------------------------------------------------------------------------------------------------
% Set up figure
figure('Units', 'centimeters', 'Position', [0.05, 2.8, 20, 16], 'PaperPositionMode','Auto')

% Insert invisible axes to connect lines from the bottom plots to the top
axes('Position',[0.15, .521, .8, .049]); 
if (ptype == 0 || ptype== 2)
   plot([locs'; locs'], [0 1], ':k', 'LineWidth', 0.5); xlim([X(1) X(end)]);
elseif (ptype == 1 || ptype == 3)
   semilogx([locs'; locs'], [0 1], ':k', 'LineWidth', 0.5); xlim([X(1) X(end)]);
end
set(gca,'visible','off');

%------------------------------------------------------------------------------------------------------
% Plot of known mode frequencies
% Set up first subplot
hx1 = subplot(211);
set(hx1,'Position',[0.15, .57, .8, .32]);

% Plot the data and known modes
if ptype == 0
    P=plot(X,Y,'LineWidth',1.5); hold on;
elseif ptype == 1
    P=semilogx(X,Y,'LineWidth',1.5); hold on;
elseif ptype == 2
    P=semilogy(X,Y,'LineWidth',1.5); hold on;
elseif ptype == 3
    P=loglog(X,Y,'LineWidth',1.5); hold on;
end
pf=plot([freqs'; freqs'], ylimits, 'r', 'LineWidth',0.1); hold off;
xlim([X(1) X(end)]); ylim(ylimits); uistack(P,'top');

% Create period axis on the top x-axis
ax1 = gca;
xt = get(ax1,'XTick');
xp = 1./(xt*0.001); % Conversion between millihertz to seconds
ax2=axes('Position', get(ax1, 'Position'), 'XAxisLocation','top','YTickLabel',[],'XLim',...
         get(ax1, 'XLim'), 'XTickLabel', str2num(sprintf('%.f ', xp)),'Color','none');
set(ax2,'xscale',xscale);set(ax1,'xticklabel',[]);
xlabel(ax2,'Period (s)','FontSize',10);

% Additional plot information
title(sprintf('N=%.f',ipks)); ylabel(ax1,{'Spectral Density', '(Energy/Hz)'});
ax1.XGrid = 'off'; ax1.YGrid = 'on'; 

% Add legend if modes exist
if exist('p1')
    legend({'Widmer & Masters'});
end

%------------------------------------------------------------------------------------------------------
% Plot of identified peaks
% Set up subplot
hx2 = subplot(212);
set(hx2,'Position',[0.15, .2, .8, .32]);

% Plot the data and peak identification
if ptype == 0
    P=plot(X,Y,'LineWidth',1.5); hold on;
elseif ptype == 1
    P=semilogx(X,Y,'LineWidth',1.5); hold on;
elseif ptype == 2
    P=semilogy(X,Y,'LineWidth',1.5); hold on;
elseif ptype == 3
    P=loglog(X,Y,'LineWidth',1.5); hold on;
end
pl=plot([locs'; locs'], ylimits, 'k', 'LineWidth', 0.1);

% Additional plot information
xlim([X(1) X(end)]); ylim(ylimits); uistack(P,'top');
hx2.XGrid = 'off'; hx2.YGrid = 'on';
xlabel('Frequency (mhz)'); ylabel({'Spectral Density', '(Energy/Hz)'})

% Add legend if peak frequencies exist
if exist('p2')
    legend({'Estimated'});
end
%-----------------------------------------------------------------------------------------------------
% Optional output
varns={P,pf,pl};
varargout=varns(1:nargout);
      
end

