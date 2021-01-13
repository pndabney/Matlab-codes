function sac2pchave(filename)
% SAC2PCHAVE(filename)
%
%
% Reads SAC-formatted data and runs the program pchave to obtain
% spectral density estimation plots
%
% INPUT:
%
% filename        The filename, full path included
%
% Note:
%
% Requires routines in slepian_oscar and slepian_alpha 
% 
%
% Last modified by pdabney@princeton.edu 12/10/2020

plotornot=0; % does not plot the data through readsac
[SeisData,HdrData,tnu,pobj,tims]=readsac(filename,plotornot,'l',0);
lwin = 256; olap = 70; nfft = 256;
dval = 'MAD'; winfun = 'hamming';
fs = mean(diff(tims));
[SD,F]= pchave(SeisData,lwin,olap,nfft,fs,dval,winfun);

figure(1)
plot(tims, SeisData); axis tight; grid on
xlabel('Time (s)');
title(sprintf(filename))

figure(2)
subplot(2,1,1);
plot(F,SD,'b-','LineW',1); axis tight; grid on
xlabel('Frequency (Hz)'); ylabel('Spectral Density (Energy/Hz)');
subplot(2,1,2);
plot(F,10*log10(SD),'b-','LineW',1);
axis tight; grid on; fig2print(gcf,'landscape')
xlabel('Frequency (Hz)'); ylabel('Spectral Density (Energy/Hz)');
suptitle('Power Spectral Density Estimate')
