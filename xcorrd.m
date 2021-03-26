function varargout=xcorrd(a,b,meth)
% [xc,nxc,et]=XCORRD(a,b,meth)
%
% Cross-correlation of two time series 
%
% INPUT:
%
% a,b         Time series segments (format must be Nx1)
% meth        1 Explicit for-loops
%             2 First attempt at vectorization
%
% OUTPUT:
% 
% xc          Cross-correlation of time series a and b
% nxc         Normalized cross-correlation of time series a and b
% et          Elapsed time
%
% EXAMPLE:
%
% t = 1:3:100;
% a = 2*sin(4*pi*t);
% b = 3*sin(3*pi*t/2 + 1/2);
% [~,nxc]=xcorrd(a,b);
%
% Last modified pdabney@princeton.edu, 03/26/2021


if ~isstr(a)
  % Defaults
  defval('meth',1)
  
  % Force it to be a ROW
  a=a(:)';
  b=b(:)';
  
  N = length(a);
  M = length(b);
  
  % Shift segment a past segment b
  l = N-1;
  A = a;
  B = [zeros(1,l),b,zeros(1,l)];
  
  s = N+M-1;
  norma = 0;
  % Compute cross correlation
  tic
  for k = 1:s
    xc(k) = 0;
    switch meth
     case 1
      for i = 1:min(length(A),length(B))
	cc(i) = A(i)*B(i+k-1);
	% Build the sum
	xc(k) = xc(k) + cc(i);
	% Build the sum of squares
	norma = norma + cc(i)^2;
      end
     case 2
      ii=1:min(length(A),length(B));
      cc = A(ii).*B(ii+k-1);
      % Build the sum
      xc(k) = sum(cc(ii));
      % Build the sum of squares
      norma = norma + cc*cc';
    end
  end
  et=toc;
  
  xc = flip(xc); 
  
  % Normalize
  nxc = xc./sqrt(norma);
  
  % Optional output
  varns={xc,nxc,et};
  varargout=varns(1:nargout);
elseif strcmp(a,'demo1')
  TT=[10:100:1000];
  for index=1:length(TT)
    t=1:3:TT(index);           
    a = 2*sin([4+rand]*pi*t+rand);
    b = 3*sin([3+pi]*pi*t/2 + 1/2+rand);
    [~,nxc1,wun(index)]=xcorrd(a,b,1);
    [~,nxc2,too(index)]=xcorrd(a,b,2);
  end
  clf                
  plot(TT,wun,'LineWidth',2,'Color','r')
  plot(TT,too,'LineWidth',2,'Color','b','LineStyle','--') 
  grid on
  hold on
  plot(TT,wun,'LineWidth',2,'Color','r')                 
  xlabel('dimension')
  ylabel('elapsed time')
  legend('method 1','method 2','location','northeast')
  longticks(gca)
end
