function varargout=isincreasing(x)
% [C,K]=isincrease(x)
%
% Finds the index where the numbers are not monotomically increasing by 1
%
% Input:
%
% x              Data array containing gaps (includes NaN)
%
% Output:
%
% C              Cell array of segments of data
% K              Upper bound indexes of the data segments
%
% Last modified by pdabney@princeton.edu, 8/16/21

% Create vector of lower bound indexes
% --- should look into removing the for loops in the future ---
for i = 1:length(x)-1
    if x(i)+1 ~= x(i+1)
        K = find(x == x(i));
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
for j = 2:length(K)-1
    C{j} = x(K(j)+1:K(j+1));
end

% Optional Output
vars = {C,K};
varargout=vars(1:nargout);
end

