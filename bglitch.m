function varargout=bglitch(sd,t,num,d,amp,method,p)
% [GD,loc]=BGLITCH(sd,t,num,d,amp,method,p)
%
% Takes in a time series and creates synthetic glitches
%
% INPUT:
%
% sd               Seismic data array (1-D)
% t                Corresponding time data
% num              Number of glitches to create
% d                Distribution of glitches
%                  'rando' randomly distributed gaps
%                  'eveno' evenly distributed gaps
% amp              Array for the amplitude of glitches 
%                  (Number of amplitudes must be equal to number of glitches)
% method           Method of creating glitches: "add" or "replace"
%                  "add" - Adds inputed glitch amplitude to existing data
%                  "replace" - Replaces data point with glitch
% p                1 makes a plot
%                  0 does not make a plot
%
% OUTPUT:
%
% GD               New glitched data array
% loc              Array of glitch locations
% 
% EXAMPLE:
% 
% sd=rand(1,1028); t=1:1048; num=randi(25); d='rando'; amp=randi([-10 10],1,num); p=1;
% [GD,loc]=bglitch(sd,t,num,d,amp,p);
%
% Last modified by pdabney@princeton.edu 12/06/21

% Factor to multiply by for text position
tp = 0.88;

% Must ensure the number glitches corresponds to number of amplitudes
if length(amp) == num
    % Choose distribution and location of gaps in the time series
    if d ==  'rando'
        loc = sort(randi([1 length(sd)],1,num));
    elseif d == 'eveno'
        loc = round(linspace(1,length(sd),num));
    end
    GD = sd(:);
    if method == "add"
        % Add glitches into the data
        GD(loc) = GD(loc) + amp(:);
    elseif method == "replace"
        % Replace data points with glitches
        GD(loc) = amp(:);
    end
else
    warning('Length of amplitude array must equal number of glitches.')
end
if p == 1
    figure
    subplot(2,1,1)
    plot(t,sd)
    xlim([1 length(sd)]); xlabel('Time (s)')
    title('Original Time Series')
    subplot(2,1,2)
    plot(t,GD); box on;
    xlim([1 length(sd)]);
    xlabel('Time (s)')
    xL=xlim; yL=ylim;
    text(tp*xL(2),tp*yL(2),sprintf('N = %.f',num))
    title('Glitched Time Series')
end

% Optional output
varns={GD,loc};
varargout=varns(1:nargout);
end



