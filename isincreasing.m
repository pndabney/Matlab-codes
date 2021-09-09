function varargout=isincreasing(x)
% [C,K]=isincreasing(x)
%
% Finds the index where integers are not monotomically increasing by 1 
% and divides sections into a cell
%
% Input:
%
% x              Vector of increasing integers 
%
% Output:
%
% C              Cell array of integer sequences which are increasing by 1
% K              Upper bound indexes of the sections
%
% Last modified by pdabney@princeton.edu, 9/9/21

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
% Deal with the first 
C = cell(1,length(K)+1);
C{1} = x(1:K(1));

% Deal with the middle segments
% --- should look into removing the for loops in the future ---
for j = 1:length(K)-1
    C{j+1} = x(K(j)+1:K(j+1));
end
% Deal with last segment
C{length(K)+1} = x(K(end)+1:end);

% Add index of the last element in the vector 
% to the upper bound index for output
K = [K; length(x)];

% Optional Output
vars = {C,K};
varargout=vars(1:nargout);
end

