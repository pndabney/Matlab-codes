function pltstations(stations,sta_names, event)
% PLTSTATIONS(stations,sta_names,event)
%
% Plots stations and an earthquake on a world map centered at the Pacific Ocean
%
% Input:
% 
% stations           [lat lon] of station locations
% sta_names          Vector containing the station names 
% event              [lat lon] of the event
%
% Note:
% 
% Requires repository slepian_alpha. See plotcont, plotplates,
%
% Example:
%
% event = [3.4125, 95.9012]; % [lat, lon]
%
% Last modified by pdabney@princeton.edu, 10/6/21

%---------------------------------------------------------------------------------------------
% SET VALUES
% Step increments for x and y axis tick labels
xstep = 60; % in degrees
ystep = 30; % in degrees
% Boundaries for the world map plots
c11 = [0 90];
cmn = [360 -90];

%---------------------------------------------------------------------------------------------
% PLOT MAP
% Plots continental outlines for the entire world and fills continents with a solid color
[axlim,handl,XYZ,xyze]=plotcont(c11, cmn, 7, 0, grey);

% Plot plate boundaries
[handl,XY]=plotplates(c11, cmn, 1);

%---------------------------------------------------------------------------------------------
% PLOT EVENT
plot(event(2), event(1), 'o', 'MarkerFaceColor', 'r', 'MarkerSize',8)

% Add aesthetics (rings about event location)
rsize = [10 16 24]; % makersize for rings
for i = 1:length(rsize)
    plot(event(2), event(1), 'o','MarkerEdgeColor', '[0.85 0.32 0.098]', 'MarkerSize',rsize(i))
end

%---------------------------------------------------------------------------------------------
% PLOT STATIONS
% Check for negative values
k = find(stations(:,2) < 0);
% Need to correct negative longitudinal values to plot on map (must shift negative values by 360)
if ~isempty(k) == 1
    stations(k,2) = stations(k,2) + 360;
end
% plot stations and station names
scatter(stations(:,2), stations(:,1), 30,'^', 'MarkerFaceColor','b', 'MarkerEdgeColor','k')
text(stations(:,2),stations(:,1)+5,sta_names,'Fontsize',7, 'FontWeight','bold') % shift text 5 degrees station location

%---------------------------------------------------------------------------------------------
% ADD FIGURE ACCESSORIES
% set axis
set(gca, 'YLim',[axlim(3) axlim(4)])
yt = axlim(3):ystep:axlim(4);
yticks(gca, yt)
set(gca, 'XLim',[axlim(1) axlim(2)])
xt = axlim(1):xstep:axlim(2);
xticks(gca, xt)
% Add degree symbol to axes
add_degree('ytick'); add_degree('xtick')
% Add axes labels 
xlabel('Longitude'); ylabel('Latitude')
% Put ticks on the outside of the plot
longticks(gca,2); box on

end