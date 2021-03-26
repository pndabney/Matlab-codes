function varargout=xcorrd(a,b)
% [xc,nxc]=XCORRD(a,b)
%
% Cross-correlation of two time series 
%
%
% INPUT:
%
% a,b         Time series segments (format must be Nx1)
%
%
% OUTPUT:
% 
% xc          Cross-correlation of time series a and b
% nxc         Normalized cross-correlation of time series a and b
%
%
% Example:
%
% t = 1:3:100;
% a = 2*sin(4*pi*t);
% b = 3*sin(3*pi*t/2 + 1/2);
% [~,nxc]=xcorrd(a,b);
%
% Last modified pdabney@princeton.edu, 2/9/2021

N = length(a);
M = length(b);

% Shift segment a past segment b
l = N-1;
A = a;
B = [zeros(1,l),b,zeros(1,l)];


s = N+M-1;
norm = 0;
% Compute cross correlation
for k = 1:s
     xc(k) = 0;
     for i = 1:min(length(A),length(B))
         cc(i) = A(i)*B(i+k-1);
         xc(k) = xc(k) + cc(i);
         norm = norm + cc(i)^2;
     end
end

xc = flip(xc); 

% Normalize
nxc = xc./sqrt(norm);


% Optional output
varns={xc,nxc};
varargout=varns(1:nargout);
