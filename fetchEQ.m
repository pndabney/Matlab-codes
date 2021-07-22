function fetchEQ(network,station,location,channel,startdate,enddate,minfreq,maxfreq,numfreq)
% [direc]=fetchEQ(network,station,location,channel,startdate,enddate,minfreq,maxfreq,numfreq)
%
% Requests waveform and instrument response data from IRIS and saves the data in a directory.
% Waveform data is in the format of a SAC file and instrument response data is in the format of a RESP file. 
% Then runs evalresp to obtain the AMP and PHASE files. This function requires that you already have
% EVALRESP software (available at https://ds.iris.edu/ds/nodes/dmc/software/downloads/evalresp/)
%
% Input:
% 
% network          Network name [e.g. 'IU']
% station          Station name [e.g. 'ANMO']
% location         Location code [e.g. '00']
% channel          Component of interest [e.g. 'BHZ']
% startdate        Start date [format: 'yyyy-mm-dd hh:mm:ss']
% enddate          End Date [format: 'yyyy-mm-dd hh:mm:ss']
% minfreq          Minimum frequency for EVALRESP
% maxfreq          Maximum frequency for EVALRESP
% numfreq          Number of frequency for EVALRESP
%
%
% Last modified by pdabney@princeton.edu, 7/22/21

% Directory to put the waveform and instrument response data
direc = '~/Documents/ANMO/';

% Request waveform data and put in specified directory
irisFetch.SACfiles(network,station,location,channel,startdate,enddate,direc);

% Reformat start date and end date for Resp, amp, phase request
starttime = strrep(startdate,' ','T');
endtime = strrep(enddate,' ','T');

%--------------------------------------------------------------------------------------------------------------
% Get the instrument response data from iris
% Format url request
ini_inresp = 'http://service.iris.edu/irisws/resp/1/query?';
param_inresp = sprintf('net=%s&sta=%s&loc=%s&cha=%s&starttime=%s&endtime=%s',network,station,location,channel,starttime,endtime);
query_inresp = strcat(ini_inresp,param_inresp);
% Obtain web content
re = webread(query_inresp);

% Create RESP file
filename = sprintf('RESP.%s.%s.%s.%s',network,station,location,channel);
fileID = fopen(fullfile(direc,filename),'w');
fprintf(fileID,re);
fclose(fileID);

%---------------------------------------------------------------------------------------------------------------
% Evaluate evalresp to get amp and phase files
% Extract the datetime for year and day
date = datetime(extractBefore(startdate,' '));

% Make command sequence
% Go to specified location for the output then run EVALRESP
tcom=sprintf('cd %s ; evalresp %s %s %g %g %g %g %g -f %s -u vel',...
             direc,station,channel,year(startdate),day(date,'dayofyear'),minfreq,maxfreq,numfreq,filename);
% Execute the command sequence
system(sprintf('%s',tcom));

% optional output
vars={direc};
varargout=vars(1:nargout);
end

