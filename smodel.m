function varargout=smodel(N,num,frange,df,len,dt,sigma1,sigma2,plotornot,numtest)
% [S,tim,mfreqs,a,b]=smodel(N,num,frange,df,len,dt,sigma1,sigma2,plotornot,numtest)
%
% Generates multiple synthetic seismograms (M x N) by specifying the 
% coefficients. 
%
% Input:
%
% N                 Number of seismograms to create (default: 3)
% num               Number of frequencies to alter power intensity 
% frange            Vector containing 2 frequencies in order of increasing 
%                   frequency. These specify the range of interest
% df                Frequency step (Hz)
% len               Total length of time series (s)
% dt                Sample rate of the data (s)
% sigma1, sigma2    Standard deviations for normal distributions to pick random
%                   frequencies for generating the coefficents for the signal.
% plotornot         1 - to plot
%                   0 - to not plot (default)
% numtest           Number of synthetics tests to generate (default: 31)
%
% Output:
%
% S                 Synthetic time series (M x N). If numtest is greater than 1, then the
%                   output is in a cell array. If numtest is equal to 1, the output is a matrix
% tim               Time vector (1 x M)
% mfreqs            Frequencies with increase power intensity
%
% Note:
% 
% Requires repository slepian_alpha. See defval.
%
% Last modified by pdabney@princeton.edu, 04/04/22

defval('N',3)
defval('num',5)
defval('frange',[0.001 0.05])
defval('df',0.0001);
defval('len', 24*3600)
defval('dt',10)
defval('sigma1', 1)
defval('sigma2',5)
defval('plotornot',0)
defval('numtest',31) 

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
while length(ndxab) ~= (M-num)
    sdxab = randi(M,num,1);
    [ndxab,~]=skip(1:M,sdxab);
end
mfreqs = freq(sdxab);
if numtest > 1
    S = cell(numtest,1);
    A = cell(numtest,1);
    B = cell(numtest,1);
end

for i = 1:numtest
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
    ts = cos(2*pi*tim(:)'.*freq(:))'*a + sin(2*pi*tim(:)'.*freq(:))'*b;
    
    if numtest == 1
        S = ts;
        A = a;
        B = b;
    else
        S{i} = ts;
        A{i} = a;
        B{i} = b;
    end
end

% Optional plot
if plotornot ==1
    subplot(211)
    k = randi(N);
    plot(tim,ts(:,k))
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
vars={S,tim,mfreqs,A,B};
varargout=vars(1:nargout);

end
