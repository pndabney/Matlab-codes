function varargout=bglitch(sd,num,d,amp,p)
% [GD,pdif]=BGLITCH(sd,num,d,amp,p)
%
% Takes in a time series and creates synthetic glitches
%
% INPUT:
%
% sd               Seismic data array (1-D)
% num              Number of glitches to create
% d                Distribution of glitches
%                  'rando' randomly distributed gaps
%                  'eveno' evenly distributed gaps
% amp              Array for the amplitude of glitches 
%                  (length must be equal to number of glitches)
% p                1 makes a plot
%                  0 does not make a plot
%
% OUTPUT:
%
% GD               New glitched data array
% pdiff            Percentage of corruption of the data
%
% Requires repository slepian_alpha
%
% See defval
%
% EXAMPLE:
% 
% sd = rand(1028,1); num=randi(25); d = 'rando'; amp = randi([-10 10],1,num);
% [GD,pdiff]=bglitch(sd,num,d,amp,1);
%
% Last modified by pdabney@princeton.edu 04/10/21

% Sensible working defaults
defval('sd',rand(1028,1))
defval('num',randi(25))
defval('p',1)
defval('d','rando')
defval('amp',randi([-10 10],1,num))


% main
% ensure the number glitches corresponds 
if length(amp) == num
    % Choose distribution and location of gaps in the time series
    if isstr(d) & d=='rando'
        loc = randi([1 length(sd)],1,num);
        loc = sort(loc);
    elseif isstr(d) & d=='eveno'
        loc = linspace(1,length(sd),num);
        % ensure loc consists of integer
        loc = round(loc);
    end
   
    % Add glitches into the data
    GD = sd;
    for i = 1:length(amp)
        GD(loc(i)) = GD(loc(i)) + amp(i);
    end
else
    warning('Length of amplitude array must equal number of glitches.')
end

% Calculate the percentage of difference between original and glitched data
pdif = mean((GD-sd)./GD * 100);

% Optional figure
if p == 1
    figure()
    subplot(2,1,1)
    plot(sd);
    xlim([1 length(sd)]); 
    xlabel('Time (s)');
    title('Original Time Series');
    subplot(2,1,2)
    plot(GD);
    xlim([1 length(sd)]);
    ylim([-(max(abs(amp))+2) (max(abs(amp))+2)]);
    xlabel('Time (s)');
    title('Glitched Time Series');
end



% Optional output
varns={GD,pdif};
varargout=varns(1:nargout);
end

