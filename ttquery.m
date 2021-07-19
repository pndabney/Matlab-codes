function varargout=ttquery(rlat,rlon,elat,elon,edepth)
% [data]=ttquery(rlat,rlon,elat,elon,edepth)
%
% Obtains a data table with P and S travel times from IRIS.
%
% INPUT:
%
% rlat          Latitude of receiver 
% rlon          Longitude of receiver
% elat          Event latitude
% elon          Event longitude
% edepth        Event depth
%
% OUTPUT:
%
% data          Table with travel time data
%
% Last modified by pdabney@princeton.edu, 07/19/21

% Initialize constant substrings
inital = 'http://service.iris.edu/irisws/traveltime/1/query?';
model = 'model=prem'; 
phases = 'phases=S,P';
sta = 'staloc='; 

% Reformat and join substrings
locs = sprintf('[%.4f,%.4f] ',rlat,rlon); % required
locIn = strrep(locs,' ',','); % reformat string
loc = locIn(1:end-1); % remove extra comma at the end
staloc = strcat(sta,loc);
begin = strcat(inital,staloc);

evdepth = sprintf('evdepth=%.1f',edepth);
evloc = sprintf('evloc=[%.4f,%.4f]',elat, elon); % required

% List of all the substrings
words = {begin,evloc,evdepth,phases,model};

% Join all the substrings
query = strjoin(words,'&');

% Get travel time data from IRIS
data = webread(query);

% option for output
varns={data};
varargout=varns(1:nargout);

end

