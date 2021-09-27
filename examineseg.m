function varargout=examineseg(CD,pdata,tim,dt,pmis,Ng)
% [Ns, T, M, mu] = examineseg(CD,pdata,tim,dt,pmis,Ng)
%
% Examines segmented data.
%
% Input:
%
% CD              Cell array of data segments
% pdata           Plotting data (OPTIONAL: insert data to plot or leave empty to NOT plot)
%                 IF pdata exist, then must also input:
%                     tim          Corresponding time axis 
%                     dt           Sampling rate (s)
%                     pmis         Percentage of missing data
%                     Ng           Number of gaps
% Output:
%
% Ns              Number of segments
% T               Total length of segments, in samples
% M               Vector containing the maximum and minimum length (format: [max min]), in samples
% mu              Average length of data segment, in samples
%
% Last modified by pdabney@princeton.edu, 9/27/21

% Number of segments
Ns = length(CD);

% Max and min segment length
clen = cellfun(@length,CD);
M = round([min(clen) max(clen)],2);

% Average length of data segments
tol = sum(clen);
T = round(tol,2); mu = round(T/Ns,2);
%--------------------------------------------------------------
switch nargin
  case 6
    
    % Factor to multiply by for text position
    tpx = 0.80;
    tpy = 0.80;
    
    % Create plot
    plot(tim,pdata);
    xlim([tim(1) tim(end)])
    xlabel('Time (s)');
    title(sprintf('Percent Missing: %.2f',pmis))
    XL=xlim; YL=ylim;
    % Change units from hours to seconds as needed
    text(tpx*XL(2),tpy*YL(2),...
         sprintf('T=%.2f, mu=%.2f,\nmin=%.2f, max=%.2f,\ndt=%.2f s, N=%.f, G=%.f',...
                 T,mu,M(1),M(2),dt,Ns,Ng),'HorizontalAlignment','center','FontSize',9);

  case 1
    % Do not create a plot
end

%--------------------------------------------------------------
% Optional output
varns={Ns, T, M, mu};
varargout=varns(1:nargout);

end

