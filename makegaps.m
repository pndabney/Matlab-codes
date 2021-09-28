function varargout=makegaps(sd,tim,dt,num,d,thresh)
% [CD,pmis,Ng,lplot,SData]=MAKEGAPS(sd,tim,dt,num,d,thresh)
%
% Takes a time series and creates synthetic gaps
%
% INPUT:
%
% sd               Seismic data array (1-D)
% tim              Corresponding time axis
% dt               Sampling rate (s)
% num              Number of gaps to create [default: 10]
%                  (Note: if threshold is implemented, the number of gaps inputed 
%                  may not be equal to the actual number of gaps created)
% d                Distribution of gaps
%                  'rgaps' uniformly random distributed gaps [default]
%                  'egaps' evenly distributed gaps
% thresh           Optional threshold for minimum length of data segments, in samples
% 
% OUTPUT:
%
% CD               Cell array of the remaining segments
% pmis             Percentage of missing data
% Ng               Number of gaps
% lplot            Array of ones with gaps (demonstraes gaps in data as a simple line plot)
% SData            New seismic array with gaps (use for plots)
%
% Note:
% 
% Requires repository slepian_alpha. See defval, matranges and isincreasing.
%
% EXAMPLE:
%
% sd = ones(1,2048); tim = 1:2048; dt=1;  num = randi(10); d = 'rgaps';
% [CD,pmis,Ns,Ng,T,mu,M,lplot,SData]=makegaps(sd,tim,dt,num,d);
%
% Last modified by pdabney@princeton.edu 09/24/21

N=length(sd);

% MAIN
if strcmp(d,'rgaps') == 1
    ng = sort(unique(round(N*rand(1,2*num))));
    % must be an even amount to form pairs
    while mod(length(ng),2) == 1
        ext = round(N*rand(1)); 
        ng = unique(sort(horzcat(ng,ext)));
    end
elseif strcmp(d,'egaps') == 1
    if num == 1
        error('Number of gaps must be greater than 1')
    end
    % ensure ng consists of integers
    ng = round(linspace(1,N,2*num));
end

% Create gaps by replacing segments of data with NaN
SData = sd; SData(matranges(ng))=NaN;
% Find indexes of data
nsd = find(~isnan(SData));
% Creates a cell array of the INDEXES of the data segments
[C,K]=isincreasing(nsd);

% Optional threshold
switch nargin
    case 8
      % Ensure segments are longer than thresh
      clen=cellfun(@length,C);
      K=find(clen < thresh);
      C(K)=[];
    case 7
      % do nothing
end
% Rerun code if cell array is empty
if isempty(C) == 1
    [CD,pmis,Ns,Ng,T,mu,M,lplot,SData]=mgaps_m1(sd,tim,dt,num,d,p,units,thresh);
end

%--------------------------------------------------------------
% Create a cell array for each to be filled with the data of each section
l = ones(length(SData),1); lplot=l;
for i = 1:length(C)
    l(C{i})=NaN; % needed to update array if threshold was used
    CD{i} = sd(C{i}); % fill cell with data
end
% Update arrays used for plotting
% Fills nonNaN with NaN because l originally filled sections of data with NaN
% Now the data segments in CD correspond to SData segments
j = find(~isnan(l));
SData(j)=NaN;
lplot(j)=NaN;

%--------------------------------------------------------------
% Calculate the percent of data missing
pmis = ((N-sum(abs(~isnan(SData))))/N) * 100; 
% Number of gaps
Ng = length(ng)/2;

%--------------------------------------------------------------
% Optional output
varns={CD,pmis,Ng,lplot,SData};
varargout=varns(1:nargout);
end

