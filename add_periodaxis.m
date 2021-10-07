function ax2 = add_periodaxis(ax, scale)
% [ax2] = ADD_PERIODAXIS(ax,scale)
%
% Creates a upper period axis corresponding to the lower frequency axis.
%
% Input:
%
% ax                   Handle to the figure panel [default: gca]
% scale                Axis scale ('log' or 'linear')        
%
% Output:
%
% ax2                  Period axis
%
% Last modified by pdabney@princeton.edu, 10/07/21


% Get tick marks for the time axis
xt = get(ax,'XTick');

% Convert to period (s)
xp = 1./xt;

% Create the upper axis
ax2=axes('Position', get(ax, 'Position'), 'XAxisLocation','top','YTickLabel',[],'XLim',...
         get(ax, 'XLim'), 'XTickLabel', str2num(sprintf('%.f ', xp)),'Color','none');

% Ensure the scale of the upper axis corresponds to the scale of the lower
set(ax2,'xscale',scale); 

% Label
xlabel(ax2,'Period (s)','FontSize',10);

end