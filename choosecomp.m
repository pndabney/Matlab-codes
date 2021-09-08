function varargout=choosecomp(Xi1,Xi2,comp)
% [tseries1,tseries2]=CHOOSECOMP(Xi1,Xi2,comp)
%
% Takes two three-component time series folders and picks files for two components 
%
% INPUT:
%
% Xi1,Xi2             Data directories containing the three components of a seismogram,
%                     full path included
% comp                Choose two components (UU=1, UV=2, UW=3, VU=4, VV=5, VW=6, WU=7,
%                     WV=8, WW=9) 
%
% OUTPUT:
%
% tseries1,tseries2   Filenames of SAC data for the choosen time series, full path included   
%
% NOTE:
%
% Example:
%
% Xi1 = '/data2/InSight/ce_IPGP_deglitched/S0105_IPGP_corr';
% Xi2 = '/data2/InSight/ce_IPGP_deglitched/S0132_IPGP_corr';
% [tseries1,tseries2]=choosecomp(Xi1,Xi2,1)
%
% Last modified by pdabney@princeton.edu, 09/08/21

% Read in data
dXi1 = dir(Xi1);
dXi2 = dir(Xi2);

% ignore the two files (.) and (..)
dXi1(1:2,:)=[];
dXi2(1:2,:)=[];

% Creates two matrices
for i =1:3
    ts1(:,i) = dXi1(i);
    ts2(:,i) = dXi2(i);
end

% Determines file names for two components of interest
if comp == 1
   tseries1 = fullfile(ts1(1).folder,ts1(1).name);
   tseries2 = fullfile(ts2(1).folder,ts2(1).name);
elseif comp == 2
   tseries1 = fullfile(ts1(1).folder,ts1(1).name);
   tseries2 = fullfile(ts2(2).folder,ts2(2).name);
elseif comp == 3
   tseries1 = fullfile(ts1(1).folder,ts1(1).name);
   tseries2 = fullfile(ts2(3).folder,ts2(3).name);
elseif comp == 4
   tseries1 = fullfile(ts1(2).folder,ts1(2).name);
   tseries2 = fullfile(ts2(1).folder,ts2(1).name);
elseif comp == 5
   tseries1 = fullfile(ts1(2).folder,ts1(2).name);
   tseries2 = fullfile(ts2(2).folder,ts2(2).name);
elseif comp == 6
   tseries1 = fullfile(ts1(2).folder,ts1(2).name);
   tseries2 = fullfile(ts2(3).folder,ts2(3).name);
elseif comp == 7
   tseries1 = fullfile(ts1(3).folder,ts1(3).name);
   tseries2 = fullfile(ts2(1).folder,ts2(1).name);
elseif comp == 8
   tseries1 = fullfile(ts1(3).folder,ts1(3).name);
   tseries2 = fullfile(ts2(2).folder,ts2(2).name);
elseif comp == 9
   tseries1 = fullfile(ts1(3).folder,ts1(3).name); 
   tseries2 = fullfile(ts2(3).folder,ts2(3).name);
 else
   warning('Does not exist')
end

% Optional output
varns={tseries1,tseries2};
varargout=varns(1:nargout);



end