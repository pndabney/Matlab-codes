function varargout=ttquery(rlat,rlon,elat,elon,edepth)
% [query]=ttquery(rlat,rlon,elat,elon,edepth)
%
%
% Creates a string in the format for an IRIS traveltime query
%
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
% query         String to copy and paste into address bar
%
%
% Last modified by pdabney@princeton.edu, 01/26/21

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


% option for output
varns={query};
varargout=varns(1:nargout);
