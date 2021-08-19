function varargout=isincreasing(x)
% [C,K]=isincreasing(x)
%
% Finds the index where the numbers are not monotomically increasing by 1
%
% Input:
%
% x              Vector of data indexes 
%
% Output:
%
% C              Cell array of segments of data
% K              Upper bound indexes of the data segments
%
% Last modified by pdabney@princeton.edu, 8/16/21

K=[];
% Create vector of lower bound indexes
for i = 1:length(x)-1
    if x(i)+1 ~= x(i+1)
        k = find(x == x(i));
        K = [K; k];
     elseif x(i)+1 == x(i+1)
        % it is increasing by only 1
    end
end

% Divide segments into cells
% Deal with the first and last segment
C = cell(1,length(K));
C{1} = x(1:K(1));
C{length(K)} = x(K(end)+1:end);

% Deal with the middle segments
% --- should look into removing the for loops in the future ---
for j = 2:length(K)-1
    C{j} = x(K(j)+1:K(j+1));
end

% Optional Output
vars = {C,K};
varargout=vars(1:nargout);
end

