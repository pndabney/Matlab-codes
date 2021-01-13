function dir2pchave(direc)
% DIR2PCHAVE(direc)
%
% Reads SAC files from data directory and runs through pchave to obtain
% spectral density estimation plots
%
% INPUT:
%
% direc         a string with the data directory
%
% Note:
%
% Requires slepian_alpha for routines readsac and pchave
%
% Last modified by pdabney@princeton.edu, 01/12/2021

% Where to put the plots
dirf='~/Documents/MATLAB/PDFs';

% Where the data is kept
filelist=fullfile(direc, '*.SAC'); % read all SAC files in directory
files=dir(filelist);

for k=1:length(files)
% read in SAC files
plotornot=0; % does not plot data through readsac
resol=0; osd='l'; 
[SeisData,HrData,tnu,pobj,tims]=readsac(fullfile(files(k).folder, files(k).name),plotornot,osd,resol);
% Calculate a power spectral density estimate using pchave
lwin=256; olap=70; nfft=256;
dval='MAD'; winfun='hamming'; fs=mean(diff(tims));
[SD,F]=pchave(SeisData,lwin,olap,nfft,fs,dval,winfun);

% plot figures
figure()
plot(tims,SeisData);
axis tight; grid on
xlabel('Time (s)');
title(sprintf(files(k).name))
% save and store plot
saveas(gcf,fullfile(dirf,sprintf('SeisPlot%d.pdf',k)));

figure()
subplot(2,1,1);
plot(F,SD,'b-','LineW',1);
axis tight; grid on
xlabel('Frequency (Hz)'); ylabel('Spectral Density (Energy/Hz));
title(sprintf(files(k).name))
subplot(2,1,2);
plot(F, 10*log10(SD), 'b-','LineW',1);
axis tight; grid on 
xlabel('Frequency (Hz)'); ylabel('Spectral Density (Energy/Hz)');
suptitle('Power Spectral Density Estimate')
% save and store plot
saveas(gcf,fullfile(dirf,sprintf('PSDplot%d.pdf',k)))

% Pause
pause(0.2)


end
