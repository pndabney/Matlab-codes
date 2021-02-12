function joinseg(filename1,filename2,filename3)
% JOINSEG(filename1,filename2,filename3)
%
%
% Reads in multiple SAC files that link together to form a single
% time series
%
%
% INPUT:
%
% filename1                First segment filename, full path included
% filename2                Second segment filename, full path included
% filename3                Optional third segment filename, full path included
%
%
% NOTE:
%
% Requires repository slepian_oscar
%
% See READSAC
%
%
% Last modified by pdabney@princeton.edu, 02/05/21


% Where to put the data?
dirp = '~/Documents/MATLAB/PDFs';


switch nargin
   case 3 % If the third file exists

       % main function
       plotornot=0; osd='l'; resol=0;
       [s1,h1,~,~,t1]=readsac(filename1,plotornot,osd,resol);
       [s2,h2,~,~,t2]=readsac(filename2,plotornot,osd,resol);
       [s3,h3,~,~,t3]=readsac(filename3,plotornot,osd,resol);

       offset1 = h1.E;
       offset2 = h1.E + h2.E;

       % connect the segments
       S = vertcat(s1,s2,s3);
       nt2 = t2 + offset1;
       nt3 = t3 + offset2;
       T = horzcat(t1,nt2,nt3);
% Plot 
       figure()
       plot(t1,s1);
       hold on
       plot(t2+offset1,s2);
       plot(t3+offset2,s3);
       hold off
       xlabel('Time (s)');
       title('Plot of Time Series Segments')

       figure()
       plot(T,S);
       xlabel('Time (s)');
       title('Plot New Time Series')

   case 2 % If there are only two files
       plotornot=0; osd='l'; resol=0;
       [s1,h1,~,~,t1]=readsac(filename1,plotornot,osd,resol);
       [s2,h2,~,~,t2]=readsac(filename2,plotornot,osd,resol);

       offset1 = h1.E;

       % connect the segments
       S = vertcat(s1,s2);
       nt2 = t2 + offset1;
       T = horzcat(t1,nt2);

       % Plot
       figure()
       plot(t1,s1);
       hold on
       plot(t2+offset1,s2);
       hold off
       xlabel('Time (s)');
       title('Plot of Time Series Segments')

       figure()
       plot(T,S);
       xlabel('Time (s)');
       title('Plot New Time Series')

   otherwise
       warning('Need at least 2 inputs')

end
