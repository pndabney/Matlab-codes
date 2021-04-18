function varargout=tshift(HrData,tims)
% [stdate,ntims]=TSHIFT(HrData,tims)
%
% Shifts the time array on the x-axis by the start time
% 
% INPUT:
%
% HrData           Header structure array 
% tims             Times on the x-axis
%
% OUTPUT:
%
% ntims            Shifted times on the x-axis
% stdate           Start date [format: 'yyyy-MM-dd HH:mm:ss.SSS']
%
%
% Last modified by pdabney@princeton.edu, 04/17/21


% Reformat
% Convert from julian date
day = datestr(HrData.NZJDAY+1,'mm-dd'); % must add 1 to get the correct date
stime = join([string(HrData.NZHOUR),string(HrData.NZMIN),string(HrData.NZSEC)],':');
starttime = join([stime,string(HrData.NZMSEC)],'.');
date = join([string(HrData.NZYEAR),day],'-');
st = datenum(join([date,starttime],' '));
std = datestr(st, 'yyyy-mm-dd HH:MM:SS.FFF');
stdate = datetime(std,'InputFormat','yyyy-MM-dd HH:mm:ss.SSS');

% Shift the time data by the start date
ntims = stdate + seconds(tims);


% Optional output
varns={stdate,ntims};
varargout=varns(1:nargout);

end