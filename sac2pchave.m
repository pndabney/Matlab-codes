function varargout=sac2pchave(fname,r,lwin,plt)
% [F,SD]=SAC2PCHAVE(fname,r,lwin,plt)
% 
% Reads SAC-formatted data and runs the program pchave to obtain
% spectral density estimation plots
%
% INPUT:
%
% fname           Filename, full path included
% r               Integer factor to decrease sampling rate by [default: 6]
% lwin            Length of windowed segment, in samples, for pchave [default: 512]
% plt             1 makes a plot
%                 0 does not make a plot [default]             
%
% OUTPUT:
%
% F               Frequency axis
% SD              Robust estimate of SPECTRAL DENSITY (UNIT^2/Hz)
%
% NOTE:
% 
% Requires repository slepian_alpha and slepian_oscar
% 
% See PCHAVE, READSAC, DEFVAL
% 
% Example:
%
% fname='/home/pdabney/Documents/Esacfiles/sacfiles/EQ_ANMO/dfilter/vel_IU.ANMO.00.BHZ.2020.204.06.12.44.SAC';
% [F,SD]=sac2pchave(fname,6,512,0);
%
% Last modified by pdabney@princeton.edu, 4/17/21


% Default
defval('plt',0);
defval('b',1);
defval('lwin',512);
defval('r',6);


% Where to put the plots
dirp='~/Documents/MATLAB/PDFs';


% Read the SAC data
plotornot=0; % to not plot data through READSAC
osd = 'l'; resol = 0;
[SeisData,HrData,~,~,tims]=readsac(fname,plotornot,osd,resol);

% Start date
day = datestr(HrData.NZJDAY+1,'mm-dd'); % must add 1 to get the correct date
date = join([string(HrData.NZYEAR),day],'-');

% Decrease sampling rate by a factor of r
[sdata,tim]=resamp(SeisData,tims,r);

% Calculate PSD
olap=70; dval='MAD'; winfun='hamming';
[SD,F]=pchave(sdata,lwin,olap,lwin,1/HrData.DELTA,dval,winfun);


% Optional figure
if plt == 1
    % plot of PSD
    figure()
    loglog(F, SD,'b-'); 
    grid on;
    ylim([1e4 1e11]);
    xlabel('Frequency (Hz)'); ylabel('Spectral Density (Energy/Hz)');
    fig2print(gcf,'landscape');
    title('Power Spectral Density Estimate');
    saveas(gcf,fullfile(dirp,sprintf('PSD%s_r%f.pdf',date,r)));
end




% Optional output
varns={F,SD};
varargout=varns(1:nargout);
