function add_degree(ax)
% ADD_DEGREE(ax)
%
% Adds the degree symbol to axes tick labels
%
% Input:
%
% ax          Choose axis to add degrees to tick labels:
%               1)  x-axis - 'xtick'
%               2)  y-axis - 'ytick'
%               3)  z-axis - 'ztick'   
%
% Last modified by pdabney@princeton.edu, 10/06/21

if ax == 'xtick'
    axlabel = 'xticklabel';
elseif ax == 'ytick'
    axlabel = 'yticklabel';
elseif ax == 'ztick'
    axlabel = 'zticklabel';
end

% Old ticks
ticks = get(gca,ax);

% Add degree symbol to old ticks
nticks=cell(1,length(ticks));
for i = 1:length(ticks)
    nticks{i} = sprintf('%d\\circ',ticks(i));
end

% Set new tick labels
set(gca,axlabel,nticks)


end

