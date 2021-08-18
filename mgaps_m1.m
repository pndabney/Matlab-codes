function varargout=mgaps_m1(sd,tim,num,d,p,thresh)
% [C,pmis,N,T,mu,M,SData]=MGAPS_M1(sd,tim,num,d,p,thresh)
%
% Takes a time series and creates synthetic gaps
%
% INPUT:
%
% sd               Seismic data array (1-D)
% tim              Corresponding time axis
% num              Number of gaps to create [default: 10]
%                  (Note: if threshold is implemented, the number of gaps inputed 
%                  may not be equal to the actual number of gaps created)
% d                Distribution of gaps
%                  'rgaps' uniformly random distributed gaps [default]
%                  'egaps' evenly distributed gaps
% p                1 makes a plot
%                  0 does not make a plot [default]
% thresh           Optional threshold for minimum length of data segments
% 
% OUTPUT:
%
% C                Cell array of the remaining segments
% pmis             Percentage of missing data
% N                Number of gaps actually created
% T                Total length of segmented data
% mu               Average length of the segmented data
% M                Two element vector containing the maximum and minimum segment length
%                  (format: [Min Max])
% SData            New seismic array with gaps (use for plots)
%
% Note:
% 
% Requires repository slepian_alpha. See matranges and isincreasing.
%
% EXAMPLE:
%
% sd = ones(1,2048); tim = 1:2048; num = randi(10); d = 'rgaps';
% [C,pmis,N,T,mu,M,SData]=mgaps_m1(sd,tim,num,d,1);
%
% Last modified by pdabney@princeton.edu 08/18/21

% Default values
defval('p',0);
defval('num',10);
defval('thresh',1);
defval('d','rgaps');

% Factor to multiply by for text position
tpx = 0.75;
tpy = 0.9;

% MAIN
if isstr(d) & d=='rgaps'
    ng = unique(sort(randi([1 length(sd)],1,2*num)));
    % must be an even amount to form pairs
    while mod(length(ng),2) == 1
        ext = randi([1 length(sd)],1,1);
        ng = unique(sort(horzcat(ng,ext)));
    end
elseif isstr(d) & d=='egaps'
    if num == 1
        error('Number of gaps must be greater than 1')
    end
    % ensure ng consists of integers
    ng = round(linspace(1,length(sd),2*num));
end

% Create gaps by replacing segments of data with NaN
SData = sd;
SData(matranges(ng))=NaN;
nsd = find(~isnan(SData));
% Create a cell array of the segmented data
[C,K]=isincreasing(nsd);

% Optional threshold
switch nargin
    case 5
    % Ensure segments are longer than thresh
    for k = length(C):-1:1
        if length(C{k}) <= thresh
            C(:,k)=[];
        end
    end
    case 4
      % do nothing
end

% Calculate the percent of data missing
pmis = ((length(sd)-sum(abs(~isnan(SData))))/length(sd)) * 100; 
% Number of gaps
N = length(ng)/2;
% Max and min segment length
clen = cellfun(@length,C);
M = [min(clen) max(clen)];
% Average length of data segments
tol = find(~isnan(SData));
T = length(tol);
mu = T/N;

% Optional plot
if p == 1
    plot(tim,SData);
    xlim([tim(1) tim(end)])
    xlabel('Time (s)');
    title(sprintf('Percent Missing: %.f',pmis))
    XL=xlim; YL=ylim;
    text(tpx*XL(2),tpy*YL(2),sprintf(...
        'T=%.2f s, mu=%.2f s,\nmin=%.f s, max=%.f s, N=%.f',T,mu,M(1),M(2),N),...
         'HorizontalAlignment','center');
end

% Optional output
varns={C,pmis,N,T,mu,M,SData};
varargout=varns(1:nargout);
end

