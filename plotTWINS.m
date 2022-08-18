function varargout=plotTWINS(file,dtype,k)
% [t,data,fs,LMST]=plotTWINS(file,dtype,k)
%
% Plots horizontal wind speed or temperature calibrated data collected from InSight's TWINS.
% See https://atmos.nmsu.edu/data_and_services/atmospheres_data/INSIGHT/insight.html for more
% details on TWINS data and format.
%
% Input:
%
% file      TWINs mat file (converted from CSV format. See csv2mat.m)
% dtype     Data type 
%           'MW' - BMY_HORIZONTAL_WIND_SPEED (default)
%           'PW' - BPY_HORIZONTAL_WIND_SPEED
%           'MT' - BMY_TIP_ROD_TEMP
%           'PT' - BPY_TIP_ROD_TEMP
%            
% k         Number of tick marks for x axis
%
% Output:
%
% t         Time vector, datetime format
% data      Data vector
% fs        Sampling rate vector 
% LMST      Cell array of Local Mean Solar Time
%
% Note: 
%     
% Requires respository slepian_alpha. See Defval.
%
% Last modified by pdabney@princeton.edu, 08/18/2022

% Default values
defval('dtype','MT')
defval('file','/data2/InSight/TWINS_data/twins_calib_0196_02.mat')
defval('k',6)

[path,name,ext]=fileparts(file);
% Load in TWINs data
d=load(file); % '/data2/InSight/TWINS_data/twins_calib_0196_02.mat');

% Extract data
t=d.t;
d=d.d;
LMST = d.LMST;

%  Data type
if strcmp(dtype,'PW')
    data=d.BPY_HORIZONTAL_WIND_SPEED;
    fs=d.BPY_WIND_FREQUENCY;
    leg='BPY_HORIZONTAL_WIND_SPEED';
elseif strcmp(dtype,'MW')
    data=d.BMY_HORIZONTAL_WIND_SPEED;
    fs=d.BMY_WIND_FREQUENCY;
    leg='BMY_HORIZONTAL_WIND_SPEED';
elseif strcmp(dtype,'PT')
    data=d.BPY_TIP_ROD_TEMP;
    fs=d.BPY_AIR_TEMP_FREQUENCY;
    leg='BPY_TIP_ROD_TEMP';
else
    data=d.BMY_TIP_ROD_TEMP;
    fs=d.BMY_AIR_TEMP_FREQUENCY;
    leg='BMY_TIP_ROD_TEMP';
end

% For axis label
if contains(dtype,'W')
    y_label='Wind speed (m/s)';
else
    y_label='Temperature (K)';
end



% Find NaN indexes
index=find(isnan(data)==1);
% delete all NaN
data(index)=[];
LMST(index)=[];
t(index)=[];
fs(index)=[];

% Determine the number of tick marks
interval = floor(length(data)/(k-1));

% Extract axis label information
axes2{1}=datestr(datenum(t(1)));

% Extract date information
Sol = str2num(LMST{1}(1:5)); % Use %g
Sday=str2num(axes2{1}(1:2));
Smonth=axes2{1}(4:6);
Syear= str2num(axes2{1}(8:11));

% Continue extracting axis label info
axes2{1}=axes2{1}(13:end);
axes1{1}=LMST{1}(7:end-4);
for i=1:k-2
    axes1{i+1} = LMST{1+interval*i}(7:end-4);
    taxes2 = datestr(datenum(t(1+interval*i)));
    axes2{i+1}=taxes2(13:end);
end
axes1{k}=LMST{end}(7:end-4);
taxes2= datestr(datenum(t(end)));
axes2{k}=taxes2(13:end);

%% Plot figure
clf;
plot(t,data)
ax = gca;

%% Axis label - add LMST on the bottom and UTC on top
% Shift figure to create space for axis label
scale = 0.82;
pos = get(ax, 'Position');
pos(4) = (scale)*pos(4);
pos(2) = 1.5*pos(2);
set(ax, 'Position', pos)

% Set normal axis
xlim(ax,[t(1) t(end)])
startpt=datenum(t(1)); endpt=datenum(t(end));
xtickmarks=linspace(startpt,endpt,k);
set(ax,'Xtick',datetime(xtickmarks,'ConvertFrom','datenum'))
set(ax,'XTicklabels',axes1)
longticks(ax,2)
xlabel(ax,{'LMST',sprintf('Sol %.f',Sol)}); ylabel(sprintf('%s',y_label))

% Add legend
l=legend(leg,'Location','northwest'); set(l,'Interpreter','none', 'FontSize',8);

% Create the upper axis
ax2=axes('Position', get(ax, 'Position'), 'XAxisLocation','top', 'Ytick',[],...
         'YTickLabel',[],'Color','none');
xlim(ax2,datenum([t(1) t(end)]))
set(ax2,'Xtick',xtickmarks);
set(ax2,'XTickLabels',axes2)
xlabel(ax2,{sprintf('%.f-%s-%.f',Sday,Smonth,Syear),'UTC'})

% Save figure
saveas(gcf,fullfile(path,sprintf('%s_sol%.f.pdf',leg,Sol)))

% Optional output
vars={t,data,fs,LMST};
varargout=vars(1:nargout);

end

