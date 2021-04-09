function varargout=mgaps(sd,tim,num,l,d)
% [C,pmis]=MGAPS(ydata,t,num,type)
%
% Reads in a time series and creates synthetic gaps. 
%
% INPUT:
%
% sd               Seismic data array
% tim              Time data array
% num              Number of gaps to create
% l                Total length of gap is 2l + 1
% d                Distribution of gaps
%                  'rand' randomly distributed gaps
%                  'even' evenly distributed gaps
%
% OUTPUT:
%
% C                Cell array of the remaining segments
% pmis             Percentage of missing data
%
% EXAMPLE:
%
% [C,mis]=mgaps(1:100,1:100,4,4,'rand')
%
% Last modified by pdabney@princeton.edu 04/08/21


% Choose distribution and location of gaps in the time series
if isstr(d) & d=='rand'
    t = randi([1 length(tim)],1,num);
    t = sort(t);
elseif isstr(d) & d=='even'
    t = linspace(tim(1)-1,tim(end)-1,num);
end


% Initialize space
C=cell(length(t),2);
% Create cell arrary for segments and time
% Main function
if t(1) > l % if there is an initial segment
    s1 = sd(1:t(1)-l);
    t1 = tim(1):tim(t(1)-l);
    C{1,1} = s1.'; C{1,2} = t1.';
        for i = length(t):-1:2
         k = find(sd <= sd(t(i)-l));
            if t(i-1)+l > k(end)
                % do nothing
            else
                k1 = find(k(t(i-1)+l) <= k);
                tims = tim(t(i-1)+l):tim(t(i)-l);
                C{i,1} = k1.';
                C{i,2} = tims.';
            end
        end       
else % if there is no initial segment
     % segments must be further than hlen apart
    for i = length(t):-1:2
        k = find(sd <= sd(t(i)-l));
        k1 = find(k(t(i-1)+l) <= k);
        tims = tim(t(i-1)+l):tim(t(i)-l);
        C{i-1,1} = k1.';
        C{i-1,2} = tims.';
    end
end
% Create and store an additional segment or remove space in the cell
if tim(end) > t(end)+l
    sl = sd(t(end)+l:end);
    tl = tim(t(end)+l):tim(end);
    C{length(t),1} = sl.'; C{length(t),2} = tl.';
else
    C{length(t),1} = []; C{length(t),2} = [];
end

% Remove any empty cells
C = C(~any(cellfun('isempty', C), 2), :);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sum of lengths of the remaining segments
s = 0;
for a = 1:length(C)
    s = s + length(C{a,2});
end

% Calculate the percentage missing
pmis = (length(sd)-s)/length(tim) * 100;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optional output
varns={C,pmis};
varargout=varns(1:nargout);
end

