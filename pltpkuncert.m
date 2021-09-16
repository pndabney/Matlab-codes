function varargout=pltpkuncert(freqs,specd,frange,gvar,sdvar)
% []=pltpkuncert(freqs,specd,sigma);
%
% Input:
%
% freqs       Vector of observed frequencies (1-D)
% specd       Vector of spectral density peak maximums (1-D)
% frange      Vector containg the frequency range of interest (format: [f1 f2])
% gvar        Vector of fitted gaussian variances (1-D)
% sdvar       Vector of spectral density peak variance (1-D)
%
% Output:
%
% Last modified by pdabney@princeton.edu, 9/16/21

yneg,ypos = sdvar;
xneg,xpos = gvar;

figure
errorbar(freqs,specd,yneg,ypos,xneg,xpos,'o')
xlim([frange(1) frange(2)]
xlabel('Frequency (mhz)')
ylabel('Spectral Density (energy/hz)')
grid on

end

