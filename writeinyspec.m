function writeinyspec(filename,dirn,earthmod,attn,g,outp,ptc,len,rdepth,...
numr,rlatlon)
% WRTIEINYSPEC(filename,dirn,earthmod,attn,g,outp,ptc,len,rdepth,numr,rlatlon)
%
%
% Creates multiple input parameter files whose format is compatable the program YSPEC.
%
%
% INPUT:
%
% filename       CMT filename in .ndk format 
% dirn           Directory containing the CMT file, full path included
% earthmod       Earh model input parameter for YSPEC [default: prem.200]
% attn           attenuation switch: 1=on, 0=off [default: 1]
% g              gravitation: 0=none, 1=cowling; 2=self [default: 2]
% outp           0=displacement, 1=velocity, 2=acceleration [default: 2]
% ptc            potential and tilt corrections: 0=no, 1=yes [default: 1]
% len            length of time series (min)
% rdepth         receiver depth (km)
% numr           number of receivers
% rlatlon        cell array of the latitudes and longitudes of each
%                receiver
%
%
% NOTES:
%
% Requires repository slepian_oscar. 
% 
% Details for the format for the input parameter file is in the yspec manual. 
%
%
% See YSPEC and readCMT
%
%
% Last modified by pdabney@princeton.edu, 01/26/21

% Get data from CMT file
tbeg=0; tend=Inf; mblo=0; mbhi=Inf; depmin=0; depmax=Inf;
[QUAKES]=readCMT(filename,dirn,tbeg,tend,mblo,mbhi,depmin,depmax);

% Loop through the CMT collected data
% Write multiple yspec.in files
for i=1:length(QUAKES)
    
    % Create output file in the format to create input parameter file for YSPEC
    fileID=fopen(sprintf('yspec.in%d',i),'w'); % Input file name must be 'yspec.in'

    % Write output file
    fprintf(fileID, '# This file contains the parameters needed to run the \n# program yspec\n')
    fprintf(fileID,'\n# prefix for output files\n yspec.out\n')
    fprintf(fileID,'\n# Earth model\n %s\n',earthmod)
    fprintf(fileID,'\n# attenuation switch\n %d\n', attn)
    fprintf(fileID,'\n# gravitation: 0 = none, 1 = cowling, 2 = self\n %d\n',g)
    fprintf(fileID,'\n# output: 0 = displacement, 1 = velocity, 2 = acceleration\n %d\n',outp)
    fprintf(fileID,'\n# potential and tilt corrections: 0 = no, 1 = yes\n %d\n',ptc)

    ts=1.0; lmin=0; lmax=1500; fmax=100; fmin=0.2; % should always be greater than 0
    fprintf(fileID,'\n# lmin\n %d\n',lmin) % spherical harmonic degree
    fprintf(fileID,'\n# lmax\n %d\n',lmax)
    fprintf(fileID,'\n# fmin (mHz)\n %d\n',fmin) % frequency for calculations
    fprintf(fileID,'\n# fmax (mHz)\n %d\n',fmax)
    fprintf(fileID,'\n# length of time series\n %d\n',len)
    fprintf(fileID,'\n# time step (sec)\n %d\n',ts)

    % FILTERING
    f11=1; f12=2; f21=98; f22=100;
    fprintf(fileID,'\n# f11 filter (mHz)\n %d\n',f11)
    fprintf(fileID,'\n# f12 filter (mHz)\n %d\n',f12)
    fprintf(fileID,'\n# f21 filter (mHz)\n %d\n',f21)
    fprintf(fileID,'\n# f22 filter (mHz)\n %d\n',f22)

    % Event info
    fprintf(fileID,'\n# source depth (km)\n %d\n',QUAKES(i,2))
    fprintf(fileID,'\n# source latitude (deg)\n %d\n',QUAKES(i,3))
    fprintf(fileID,'\n# source longitude (deg)\n %d\n',QUAKES(i,4))

    % Moment tensor components
    fprintf(fileID,'\n# M_{r,r} (Nm)\n %d\n',QUAKES(i,5))
    fprintf(fileID,'\n# M_{r,theta} (Nm)\n %d\n',QUAKES(i,6))
    fprintf(fileID,'\n# M_{r,phi} (Nm)\n %d\n',QUAKES(i,7))
    fprintf(fileID,'\n# M_{theta,theta} (Nm)\n %d\n',QUAKES(i,8))
    fprintf(fileID,'\n# M_{theta,phi} (Nm)\n %d\n',QUAKES(i,9))
    fprintf(fileID,'\n# M_{phi,phi} (Nm)\n %d\n',QUAKES(i,10))

    % Receiver info
    fprintf(fileID,'\n# receiver depth\n %d\n',rdepth)
    fprintf(fileID,'\nnumber of receivers\n %d\n',numr)
    fprintf(fileID,'\n# receiver latitudes and longitudes\n')
    fprintf(fileID,' %f %f\n',rlatlon(:,1),rlatlon(:,2))


    fclose(fileID);


end
