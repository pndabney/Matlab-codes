function varargout=smodel(N,num,frange,df,len,dt,sigma1,sigma2,plotornot)
% [S,tim,mfreqs]=smodel(N,num,frange,df,len,dt,sigma1,sigma2,plotornot)
%
% Generates multiple synthetic seismograms (M x N) by specifying the 
% coefficients. 
%
% Input:
%
% N                 Number of seismograms to create
% num               Number of frequencies to alter power intensity
% frange            Vector containing 2 frequencies in order of increasing 
%                   frequency. These specify the range of interest
% df                Frequency step (Hz)
% len               Total length of time series (s)
% dt                Sample rate of the data (s)
% sigma1, sigma2    Standard deviations for normal distributions to pick random
%                   frequencies for generating the coefficents for the signal.
% plotornot         1 - to plot
%                   0 - to not plot
%
% Output:
%
% S                 Synthetic time series (M x N)
% tim               Time vector (1 x M)
% mfreqs            Frequencies with increase power intensity
%
% Note:
% 
% Requires repository slepian_alpha. See defval.
%
% Last modified by pdabney@princeton.edu, 02/25/22
defval('N',100)
defval('num',5)
defval('frange',[0.001 0.05])
defval('df',0.0001);
defval('len', 24*3600)
defval('dt',10)
defval('sigma1', 1)
defval('sigma2',5)
defval('plotornot',1)

% Time vector
tim = 0:dt:len;
% Frequency vector
freq = frange(1):df:frange(2);
% Number of rows
M = length(freq);
% N - number of columns

% Specific frequency indexes
sdxab = randi(M,num,1);
[ndxab,~]=skip(1:M,sdxab);
mfreqs = freq(sdxab);

% Pick data from a normal distribution
fpa = randn(M-num,N)*sigma1;
fpb = randn(M-num,N)*sigma1;
spa = randn(num,N)*sigma2;
spb = randn(num,N)*sigma2;

% Fill the coefficients
a = nan(M,N); b = nan(M,N);
a(ndxab,:)=fpa; b(ndxab,:)=fpb;
a(sdxab,:)=spa; b(sdxab,:)=spb;

% Compute signal
S = cos(2*pi*tim(:)'.*freq(:))'*a + sin(2*pi*tim(:)'.*freq(:))'*b;

% Optional plot
if plotornot ==1 
    subplot(211)
    k = randi(N);
    plot(tim,S(:,k))
    xlim([tim(1) tim(end)])
    xlabel('Time (s)')
    ylabel('Amplitude')
    subplot(212)
    plot(freq,sqrt(a(:,k).^2 + b(:,k).^2))
    xlim([freq(1) freq(end)])
    set(gca,'Xtick', sort(freq(sdxab)))
    set(gca, 'XGrid', 'on')
    ylabel('Intensity')
    xlabel('Frequency (Hz)')
end

% Optional Outputs
vars={S,tim,mfreqs};
varargout=vars(1:nargout);

end
