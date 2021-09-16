function varargout=tshift(HrData,tims)
% [startdate,ntims]=TSHIFT(HrData,tims)
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
% startdate        Start date [format: 'yyyy-MM-dd HH:mm:ss.SSS']
%
% Note:
%
% Requires repository slepian_oscar. See jul2dat.
%
% Last modified by pdabney@princeton.edu, 09/14/21

% Conversion constants
days = 365; % days in a year
hrs = 24; % hours in a day
mins = 60; % minutes in an hour
secs = 60; % seconds in an minute

% Extract year and julian day 
juldate = HrData.NZJDAY;
yr = HrData.NZYEAR;
% Convert from julian date to get [month day year]
vdate = jul2dat(yr,juldate);
month = vdate(1); day = vdate(2);

% Obtain startdate
startdate = datetime(yr,month,day,HrData.NZHOUR,HrData.NZMIN,HrData.NZSEC,...
                    HrData.NZSEC,'Format','yyyy-MM-dd HH:mm:ss.SSS');

%--------------------------------------------------------------------------------
% Need a better method
%--------------------------------------------------------------------------------
% Convert startdate into seconds
yr_sec = yr*days*hrs*mins*secs;
day_sec = juldate*hrs*mins*secs;
hr_sec = HrData.NZHOUR*mins*secs;
min_sec = HrData.NZMIN*secs;
dat2sec = yr_sec + day_sec + hr_sec + min_sec + HrData.NZSEC;

% Shift the time data by the start date
ntims = startdate + tims;
%--------------------------------------------------------------------------------
% Optional output
varns={startdate,ntims};
varargout=varns(1:nargout);

end