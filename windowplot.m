function varargout=windowplot(seisdata,tim,winopt,p,r)
% [w]=WINDOWPLOT(seisdata,tim,winopt,p,r)
%
% Plots the window used and the time series with window applied
%
% Input:
%
% seisdata              Seismic Data (1-D)
% p                     1 use wvtool (to visualize time and frequency domain of the window chosen)
%                       0 does not use the wvtool 
% winopt                Window type (Hann, Hamming, Tukey)
% r                     Cosine fraction, needed for Tukey Window only
%
% Output:
%
% w                    Window as a vector
%
% Note:
%
% Requires repository slepian_oscar. See PCHAVE.
%
% Last modified by pdabney@princeton.edu, 6/24/21


L = length(seisdata);

% Choose window type
switch nargin
  case 5
   if strcmp(winopt,'Tukey') == 1
       w = tukeywin(L,r);
       if p == 1
           wvtool(tukeywin(L))
       end
   else
       error('Choose a different window');
   end
     case 4    
    if strcmp(winopt,'Hamming') == 1
        w = hamming(L);
        if p == 1
            wvtool(hamming(L))
        end
    elseif strcmp(winopt,'Hann') == 1;
        w = hann(L);
        if p == 1
            wvtool(hann(L))
        end
    end    
end

    
% Plot figure
f = figure('Units', 'centimeters', 'Position', [0.1, 2.2, 20 , 9], 'PaperPositionMode','Auto');
set(gca, 'LineWidth', 1.25, 'FontSize', 8);
hx1= subplot(121);
set(hx1,'Position',[0.07, .2, .3, .7]);
ax1=gca;
plot(tim,w); grid on;
ylim([0 1.1]); xlim([0.0002 0.001]); 
box on; xlim([min(tim) max(tim)]);
xlabel('Samples'); ylabel('Amplitude');
title(sprintf('%s Window',winopt));
hx2=subplot(122); 
set(hx2,'Position',[0.48, .2, .5, .7]);
plot(tim,seisdata.*w)
grid on; box on; axis tight;
xlabel('Time (s)'); ylabel('Velocity (m/s)');
title('Data');


% Optional Output
vars={w};
varargout=vars(1:nargout);

end

