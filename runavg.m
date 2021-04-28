function varargout=runavg(x,lwin)
% [xout]=runavg(x,wind)
%
% Running average given fixed window length using a convolution
%
% Input:
% 
% x         Signal (1-D array)
% lwin      Window length (in samples)
%
% Output:
%
% xout      Resulting signal after moving average
%
%
% Last modified by pdabney@princeton.edu, 4/27/21

N = length(x);

if N < lwin
    warning('Window is longer than the signal')
else
  wmat = ones(1,lwin);
  % Only returns parts that are computed without zero-padded edges
  xout = conv(x,wmat./lwin,'valid');
end

% Provide output
vars={xout};
varargout=vars(1:nargout);
end

