function varargout=joinseg(p,ts1,ts2,ts3)
% [T,S,sd1,tim1,sd2,ntim2,sd3,ntim3]=JOINSEG(ts1,ts2,ts3)
%
% Takes in multiple segments of time series and links them together to form a single
% time series
%
% INPUT:
%
% ts1, ts2        Struct of time series segments data. Data per time series
%                 must be in the format:
%                       ts1.t = [time vector]; 
%                       ts1.sd = [data vector]; 
%                       ts1.h = [header data];
% ts3             Optional third segment data struct

% OUPT:
%
% T               Appended x data array (1-D)
% S               Appended y data array (1-D)
% sd1             First segment data array (1-D)
% tim1            First segment corresponding time array (1-D)
% sd2             Second segment data array (1-D)
% ntim2           Corrected second segment time array (1-D)
% sd3             Third segment data array (1-D)
%                 (Only exists if there is a third segment input)
% ntim3           Corrected third segment time array (1-D)
%                 (Only exists if there is a third segment input)
%
% Last modified by pdabney@princeton.edu, 09/14/21

% Extract the data from the struct
% Segment 1
tim1 = ts1.t(:); sd1 = ts1.sd(:); hdr1 = ts1.h;
% Segment 2
tim2 = ts2.t(:); sd2 = ts2.sd(:); hdr2 = ts2.h;

% Offset of the 2nd segments
offset1 = hdr1.E;

switch nargin
   case 4 % If the third segment exists
     % Extract data from third segment struct
     tim3 = ts3.t(:); sd3 = ts3.sd(:); hdr3 = ts3.h;
       
     % Offset of the third segment
     offset2 = hdr1.E + hdr2.E;
     
     % Append the segments
     SD = vertcat(sd1,sd2,sd3);
     ntim2 = tim2 + offset1;
     ntim3 = tim3 + offset2;
     T = horzcat(tim1,ntim2,ntim3);
     T = T(:);

     % Optional output
     varns={T,S,sd1,tim1,sd2,ntim2,sd3,ntim3};
     varargout=varns(1:nargout);

   case 3 % If there are only two files
     % Append the segments
     S = vertcat(sd1,sd2);
     ntim2 = tim2 + offset1; 
     T = vertcat(tim1,ntim2);
     T = T(:);

     % Optional output
     varns={T,S,sd1,tim1,sd2,ntim2};
     varargout=varns(1:nargout);

   otherwise
     warning('Need at least 2 inputs')
end

end

