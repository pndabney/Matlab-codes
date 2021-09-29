function varargout=fitgauss(y,x,freq,wlen,thresh,gtype)
% [X,Y,bnds,cfit,e,res]=fitgauss(y,x,freq,wlen,thresh)
%
% Fit gaussian distribution curve to single peak of interest.
% Note: Only works if there is a single peak, need to look into a 
% new method for multiple peaks (such as mode splitting).
%
% Input:
% 
% y              Data (1-D)
% x              Corresponding x-axis data (1-D)
% freq           Single frequencies of interest
% wlen           Length of window
% thresh         Minimum Peak height 
% gtype          IF there are multiple peaks found, 
%                0 - obtain average gaussian 
%                1 -  obtain gassian for each peak
%
% Output:
%
% Y              Data in specifed frequency range of interest (1-D)             
% X              Corresponding x-axis data (1-D)
% bnds           Vector containing the upper and lower bound indexes for range of interest
% cfit           Gaussian curve fit result, use for plotting
% e              Root mean squared error
% res            Residuals, as vector
%
% Last modified by pdabney@princeton.edu, 9/29/21

% Take half the window 
halfwin = wlen/2;
% Obtain a frequency range of interest
xrange = [freq-halfwin freq+halfwin];

% Obtains data arrays only within range of interest
[X,Y,bnds] = inrange(x,y,xrange);

% Need to obtain the full width at half maximum 
[pks,locs,wdt,~]=findpeaks(Y,X,'MinPeakHeight',thresh,'WidthReference','halfheight');

N = length(pks);
% Choose fittype to be a gaussian
gmodel = fittype('a1*exp(-((x-b1)/c1)^2)');


% If there is only one peak
if N == 1
    % Choose starting points for fit
    [i,j]=max(Y);
    % Creates a curve fitting object used to plot and evaluate the fit
    [cfit,gof,output] = fit(X,Y,gmodel,'StartPoint',[i X(j) wdt]);

    % Residuals
    res = output.residuals;
    % Root mean square error
    e = gof.rmse;

% If there is more than one peak
elseif N > 1
    
    % Take the average of the peaks
    if gtype == 0
        % Choose starting points for fit
        w = sum(wdt)/N;
        l = sum(locs)/N;
        p = sum(pks)/N;
        % Creates a curve fitting object used to plot and evaluate the fit
        [cfit,gof,output] = fit(X,Y,gmodel,'StartPoint',[p l w]);
        
        % Residuals
        res = output.residuals;
        % Root mean square error
        e = gof.rmse;
       
    % Fit a gaussian curve to each peak
    elseif gtype == 1
        for k = 1:N
            [cfit_i,gof,output] = fit(X,Y,gmodel,'StartPoint',[pks(k) locs(k) wdt(k)]);
            cfit{k} = cfit_i;
           
            % Residuals
            res{k} = output.residuals;
            % Root mean square error
            e{k} = gof.rmse;
        end
    end
    
end

% Optional Output
vars={X,Y,bnds,cfit,e,res};
varargout=vars(1:nargout);

end
