function varargout=joinseg(p,filename1,filename2,filename3)
% [T,S]=JOINSEG(p,filename1,filename2,filename3)
%
% Reads in multiple SAC files that link together to form a single
% time series
%
% INPUT:
%
% filename1          First segment filename, full path included
% filename2          Second segment filename, full path included
% filename3          Optional third segment filename, full path included
% p                  1 makes a plot
%                    0 does not make a plot [default]
% OUPT:
%
% T                  Appended x data
% S                  Appended y data
%
% NOTE:
%
% Requires repository slepian_oscar and slepian alpha
%
% See READSAC, DEFVAL
%
% EXAMPLE:
%
% (1)
% filename1 = '/data2/InSight/all_deglitched/MPS_v1/corrected/sacfiles/XB.ELYSE.02.BHU.R.2019.073.203313.SAC';
% filename2 = '/data2/InSight/all_deglitched/MPS_v1/corrected/sacfiles/XB.ELYSE.02.BHU.R.2019.073.212836.SAC';
% [T,S]=joinseg(0,filename1,filename2);
%
% (2)
% filename1 ='/data2/InSight/all_deglitched/MPS_v1/corrected/sacfiles/XB.ELYSE.02.BHU.R.2019.102.174424.SAC';
% filename2 = '/data2/InSight/all_deglitched/MPS_v1/corrected/sacfiles/XB.ELYSE.02.BHU.R.2019.102.180000.SAC';
% filename3 = '/data2/InSight/all_deglitched/MPS_v1/corrected/sacfiles/XB.ELYSE.02.BHU.R.2019.102.183912.SAC';
% [T,S]=joinseg(0,filename1,filename2,filename3)
%
% Last modified by pdabney@princeton.edu, 03/27/21

% Default
defval('p',0);


% Where to put the data?
dirp = '~/Documents/MATLAB/PDFs';

% main
% Read SAC files
plotornot=0; osd='l'; resol=0;
[s1,h1,~,~,t1]=readsac(filename1,plotornot,osd,resol);
[s2,h2,~,~,t2]=readsac(filename2,plotornot,osd,resol);

% Offset
offset1 = h1.E;


switch nargin
   case 4 % If the third file exists
     % Include third file
     [s3,h3,~,~,t3]=readsac(filename3,plotornot,osd,resol);
       
     % Include second offset
     offset2 = h1.E + h2.E;
     
     % connect the segments
     S = vertcat(s1,s2,s3);
     nt2 = t2 + offset1;
     nt3 = t3 + offset2;
     T = horzcat(t1,nt2,nt3);
     T = T(:);

     % Plot 
     if p==1
         figure()
         plot(t1,s1);
         hold on;
         plot(t2+offset1,s2);
         plot(t3+offset2,s3);
         hold off;
         axis tight;
         xlabel('Time (s)');
         title('Time Series Segments')
         saveas(gcf,fullfile(dirp,sprintf('Seg%s_plot%d%d.pdf',h1.KSTNM,h1.NZJDAY,h1.NZYEAR)));
       
         figure()
         plot(T,S);
         axis tight;
         xlabel('Time (s)');
         title('Appended Time Series')
         saveas(gcf,fullfile(dirp,sprintf('Append%s_plot%d%d.pdf',h1.KSTNM,h1.NZJDAY,h1.NZYEAR))));
     else
     end

   case 3 % If there are only two files
     % connect the segments
     S = vertcat(s1,s2);
     nt2 = t2 + offset1;
     T = horzcat(t1,nt2);
     T = T(:);

     if p==1
         % Plot
         figure()
         plot(t1,s1);
         hold on;
         plot(t2+offset1,s2);
         hold off;
         axis tight;
         xlabel('Time (s)');
         title('Time Series Segments');
         saveas(gcf,fullfile(dirp,sprintf('Seg%s_plot%d%d.pdf',h1.KSTNM,h1.NZJDAY,h1.NZYEAR)));
         
         figure()
         plot(T,S);
         axis tight;
         xlabel('Time (s)');
         title('Appended Time Series');
         saveas(gcf,fullfile(dirp,sprintf('Append%s_plot%d%d.pdf',h1.KSTNM,h1.NZJDAY,h1.NZYEAR)));
     else 
     end 
   otherwise
     warning('Need at least 2 inputs')

end


% Optional output
varns={T,S};
varargout=varns(1:nargout);


end

