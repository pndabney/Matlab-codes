function varargout=fetchEQ(network,station,location,channel,startdate,enddate)
% [amp,phase]=fetchEQ(network,station,location,channel,startdate,enddate)
%
% Requests waveform and instrument response data from IRIS and saves the data in a directory.
% Waveform data is in the format of a SAC file. Instrument response data is in the format of a RESP file. 
%
% Input:
% 
% network          Network name [e.g. 'IU']
% station          Station name [e.g. 'ANMO']
% location         Location code [e.g. '00']
% channel          Component of interest [e.g. 'BHZ']
% startdate        Start date [format: 'yyyy-mm-dd hh:mm:ss']
% enddate          End Date [format: 'yyyy-mm-dd hh:mm:ss']
%
% Output:
%
% amp              Amplitude data produced from evalresp 
% phase            Phase data produced from evalresp
%
% Last modified by pdabney@princeton.edu, 7/19/21

% Directory to put the waveform and instrument response data
direc = '/home/pdabney/Documents/ANMO/';

% Request waveform data and put in specified directory
irisFetch.SACfiles(network,station,location,channel,startdate,enddate,direc);

%--------------------------------------------------------------------------------------------------------------
% Get the instrument response data from iris
% Reformat start date and end date
starttime = strrep(startdate,' ','T');
endtime = strrep(enddate,' ','T');
% Format url request
ini_inresp = 'http://service.iris.edu/irisws/resp/1/query?';
param_inresp = sprintf('net=%s&sta=%s&loc=%s&cha=%s&starttime=%s&endtime=%s',network,station,location,channel,starttime,endtime);
query_inresp = strcat(ini_inresp,param_inresp);
% Obtain web content
re = webread(query_inresp);

% Create RESP file
fileID = fopen(fullfile(direc,sprintf('RESP.%s.%s.%s.%s',network,station,location,channel)),'w');
fprintf(fileID,re);
fclose(fileID);

%---------------------------------------------------------------------------------------------------------------
% Evaluate evalresp to get amp and phase files
% Format url request
ini_eresp = 'http://service.iris.edu/irisws/evalresp/1/query?';
param_eresp = sprintf('net=%s&sta=%s&loc=%s&cha=%s&time=%s&output=fap',network,station,location,channel,startdate);
query_eresp = strcat(ini_eresp,param_eresp);
% Obtain web content
fap = webread(query_eresp);

% Format the data to correspond with results from Evalresp
data = textscan(fap,'%f %f %f');
amp = [data{1} data{2}];
phase = [data{1} data{3}];

%---------------------------------------------------------------------------------------------------------------
% Optional Ouput
vars={amp,phase}
varargout=vars(1:nargout);

end

