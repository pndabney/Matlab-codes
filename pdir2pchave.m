function pdir2pchave(direc)
% PDIR2PCHAVE(direc)
%
%
% Reads SAC files from the parent directory of the data directory and 
% runs through pchave to obtain spectral density estimation plots
%
%
% INPUT:
%
% direc       String of the parent directory name where the data is stored
%
%
% NOTES:
%
% Requires repository slepian_oscar and slepian_alpha
%
% See PCHAVE, READSAC and LS2CELL
%
%
% Example:
%
% pdir2pchave(getenv('MARS'))
%
%
% Last modified by pdabney@princeton.edu 12/29/2020


% Where to put the plots
dirp='~/Documents/MATLAB/PDFs';


% Where the data is kept
c = ls2cell(direc,1); % gives as full file path output
dirname = fullfile(c{1,5},'*_sac'); % c{1,5} refers to the folder common_events
folderlist = dir(dirname); 
flist = (struct2cell(folderlist))';
[filepath,name,ext] = fileparts(c{1,5});
mdirname = name;


% To Read through all the files in all the folders in the directory
for index = 1:length(flist)
    fnames = fullfile(flist(index,2),flist(index,1));
    pfiles = dir(fnames{1,1});
    foldnames = extractBefore(flist{index,1},'_'); 
   
    for k = 3:length(pfiles) % ignore first 2 items in the struct
        % read in SAC files
        plotornot=0; % does not plot the data through readsac
        [SeisData,HrData,tnu,pobj,tims]=readsac(fullfile(pfiles(k).folder,...
            pfiles(k).name),plotornot,'l',0);

        % Calculate a power spectral density estimate using pchave
        lwin=256; olap=70; nfft=256;
        dval='MAD'; winfun='hamming';
        fs = mean(diff(tims));
        [SD,F]=pchave(SeisData,lwin,olap,nfft,fs,dval,winfun);

        % Plot figures
        figure()
        plot(tims,SeisData);
        axis tight; grid on
        xlabel('Time (s)');
        title({sprintf(foldnames); sprintf(pfiles(k).name)})

        % save and store plot
        saveas(gcf, fullfile(dirp, sprintf('%s:%s-SeisPlot%d.pdf',mdirname, foldnames, k)));
        
        figure()
        subplot(2,1,1);
        plot(F,SD,'b-','LineW',1);
        axis tight; grid on
        xlabel('Frequency (Hz)'); ylabel('Spectral Density (Energy/Hz)');
        title(sprintf(pfiles(k).name))

        subplot(2,1,2);
        plot(F,10*log10(SD),'b-','LineW',1);
        axis tight; grid on; fig2print(gcf,'landscape')
        xlabel('Frequency (Hz)'); ylabel('Spectral Density (Energy/Hz)');
        suptitle('Power Spectral Density Estimate')

        % Save and store plot
        saveas(gcf, fullfile(dirp, sprintf('%s:%s-PSDplot%d.pdf',mdirname,foldnames, k)))


        % Pause
        pause(0.2)

    end

end
