function [datev]=getdatevec(datestring)
% [datev]=getdatevec(datestring)
%
% Converts date and time to vector components. If milliseconds is not
% included, use matlab's datevec.
%
% Input:
%
% datestring      String of datetime (acceptable formats: 'yyyy-mm-dd HH:MM:SS.FFF',
%                 'yyyy-mm-ddTHH:MM:SS.FFF', 'HH:MM:SS.FFF')
%
% Output:
%
% datev           Date and time in vector components
%                 (format: [year,month,day,hour,minute,second,milliseconds] or
%                  [hour,minute,second,milliseconds])
%
% Last modified by pdabney@princeton.edu, 04/18/2022

% Ensure input is in a character array
datestr = char(datestring);

if numel(datestr) == 12
    % if date is not included
    hour = str2num(datestr(1:2));
    minute = str2num(datestr(4:5));
    second = str2num(datestr(7:8));
    millisec = str2num(datestr(10:12));
    datev = [hour,minute,second,millisec];
    
    % Ouput time vector - includes milliseconds
    datev =[hour,minute,second,millisec];
else
    % if full date is included
    year = str2num(datestr(1:4));
    month = str2num(datestr(6:7));
    day = str2num(datestr(9:10));
    hour = str2num(datestr(12:13));
    minute = str2num(datestr(15:16));
    second = str2num(datestr(18:19));
    millisec = str2num(datestr(21:23));

    % Ouput date vector - includes milliseconds
    datev = [year,month,day,hour,minute,second,millisec];
end

end