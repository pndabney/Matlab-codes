function ax2 = add_periodax(ax, xscale, xunits)
% [ax2] = ADD_PERIODAX(ax,scale, xunits)
%
% Creates a upper period axis corresponding to the lower frequency axis.
%
% Input:
%
% ax                   Handle to the figure panel [default: gca]
% xscale                Axis scale ('log' or 'linear')        
% xunits               Units of the lower frequency axis 
%                      0 - hertz
%                      1 - millihertz
%                      2 - microhertz
%
% Output:
%
% ax2                  Period axis
%
% Last modified by pdabney@princeton.edu, 10/07/21

% Determine the correct unit conversion 
if xunits == 1
    ucon = 1e-3;
elseif xunits == 2
    ucon = 1e-6;
elseif xunits == 0
    ucon = 1;
end

% Shift figure down to create space for axis label
scale = 0.95;
pos = get(ax, 'Position');
pos(4) = (scale)*pos(4);
set(ax, 'Position', pos)

% Get tick marks for the time axis
xt = get(ax,'XTick');

% Convert to period (s)
xp = 1./(xt*ucon);

% Create the upper axis
ax2=axes('Position', get(ax, 'Position'), 'XAxisLocation','top', 'ytick',[],...
         'YTickLabel',[],'XLim',get(ax, 'XLim'), 'XTickLabel', str2num(sprintf('%.4f ', xp)),...
         'Color','none');

% Ensure the scale of the upper axis corresponds to the scale of the lower
set(ax2,'xscale',xscale); 

% Add label
xlabel(ax2,'Period (s)');


end

