function varargout=sac2pchave(direc,fname,b,plot)
% [F,SD]=SAC2PCHAVE(direc,fname,b)
% 
% Reads SAC-formatted data and runs the program pchave to obtain
% spectral density estimation plots
%
% INPUT:
%
% direc           Data directory, full path included
% fname           Filename, do not include path
% b               Seismogram component of interest: 
%                 1 U-component
%                 2 V-component
%                 3 W-component [default]
% plot            1 makes a plot
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
% [F,SD]=sac2pchave(getenv('CEVENTS'),'S0105_sac',1,0)
%
% Last modified by pdabney@princeton.edu, 3/27/21


% Default
defval('plot',0);
defval('b',1);


% Where to put the plots
dirp='~/Documents/MATLAB/PDFs';


% Obtain and reformat the data
files = fullfile(direc,fname);
f = dir(files);
f(1:2,:) = []; % remove first 2 rows

% Read the SAC data
plotornot=0; % to not plot data through READSAC
osd = 'l'; resol = 0;
[SeisData,HrData,~,~,tims]=readsac(fullfile(f(b).folder,f(b).name),...
                                   plotornot,osd,resol);
% Calculate PSD
lwin=256; olap=70; nfft=256;
dval='MAD'; winfun='hamming';
fs=mean(diff(tims));
[SD,F]=pchave(SeisData,lwin,olap,nfft,fs,dval,winfun);



% Optional figure
if plot == 1
    % plot of PSD
    figure()
    subplot(2,1,1);
    plot(F, SD,'b-','LineW',1); axis tight; grid on
    xlabel('Frequency (Hz)'); ylabel('Spectral Density (Energy/Hz)');

    subplot(2,1,2);
    plot(F, 10*log10(SD),'b-','LineW',1); axis tight; grid on
    fig2print(gcf,'landscape')
    xlabel('Frequency (Hz)'); ylabel('Spectral Density (Energy/Hz)');
    suptitle('Power Spectral Density Estimate')
    saveas(gcf,fullfile(dirp,'Pchave_splot.pdf'));
else
end



% Optional output
varns={F,SD};
varargout=varns(1:nargout);



end