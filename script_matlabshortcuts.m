%% All my shortcuts
%% BLACK JET
% part of: COLOUR
jet2 = cat(1,[0 0 0],jet);
colormap(jet2);
%% COLD
% part of: COLOUR
colormap(1-hot);
%% BLACK PARULA
% part of: COLOUR
parula2 = cat(1,[0 0 0],parula);
colormap(parula2);
%% BONE
% part of: COLOUR
colormap bone;
%% HOT
% part of: COLOUR
colormap hot;
%% INVERSE BONE
% part of: COLOUR
ibone = 1-bone;
colormap(ibone);
clear ibone;
%% RANDOM 
% part of: COLOUR
if ~exist('auxcmap', 'var')
    axucmap = rand(255,3);
    axucmap(:,1) = sort(axucmap(:,1));
    axucmap = [[0 0 0]; axucmap];
end
colormap(axucmap);
%% BACK2GREY
% part of: COLOUR
cmap = 0.75.*[sort(rand(254,1)) sort(rand(254,1)) sort(rand(254,1))];
cmap = [0 0 0; cmap];
colormap(cmap);

clear cmap;
%% CLOSE
% part of: UTILS
close all
%% REMOVE BORDERS
% part of: UTILS
currAxPos = get(gca,'position');
if currAxPos(end) ==1
    set(gca,'position',[  0.1300    0.1100    0.7750    0.8150 ]);axis on
else
    set(gca,'position',[0 0 1 1 ]);axis off
end
clear currAxPos

%% TIGHT SUBPLOTS
% part of: UTILS
tightfig
%% CLOUD STORAGE
%part of: UTILS
% GET a specific directory and save it into FOLDERNAME
switch chooseplatform
    case 'win'
        CLOUDFOLDER = 'C:\Users\jsolisl\Dropbox';
    otherwise 
        CLOUDFOLDER = '~/Dropbox';
end 
CLOUDFOLDER= strcat(CLOUDFOLDER, filesep,...
    'CityUniversity-Dropbox', filesep, 'images');
CLOUDFOLDER = uigetdir(CLOUDFOLDER);
%% EPS
% part of: SAVE FIGURE
gcf;
filename=input('FILENAME? [testFigure]:','s');
if isempty(filename)
    filename = 'testFigure.eps';
end
set(gcf,'color','w')
set(gcf,'PaperPositionMode','auto')
set(gcf,'InvertHardcopy','off')
print('-depsc','-r300',filename)
%% JPEG
% part of: SAVE FIGURE
gcf;
filename=input('FILENAME? [testFigure]:','s');
if isempty(filename)
    filename = 'testFigure.tif';
end
set(gcf,'color','w')
set(gcf,'PaperPositionMode','auto')
set(gcf,'InvertHardcopy','off')
print('-djpeg','-r300',filename)
%% PNG
% part of: SAVE FIGURE
gcf;
filename=input('FILENAME? [testFigure]:','s');
if isempty(filename)
    filename = 'testFigure.tif';
end
set(gcf,'color','w')
set(gcf,'PaperPositionMode','auto')
set(gcf,'InvertHardcopy','off')
print('-dpng','-r300',filename)
%% TIFF
% part of: SAVE FIGURE
gcf;

filename=input('FILENAME? [testFigure]:','s');
if isempty(filename)
    filename = 'testFigure.tif';
end
set(gcf,'color','w')
set(gcf,'PaperPositionMode','auto')
set(gcf,'InvertHardcopy','off')
print('-dtiff','-r300',filename)
%% PDF
% part of: SAVE FIGURE
gcf;
filename=input('FILENAME? [testFigure]:','s');
if isempty(filename)
    filename = 'testFigure.pdf';
end
set(gcf,'color','w')
set(gcf,'PaperPositionMode','auto')
set(gcf,'InvertHardcopy','off')
print('-pdf','-r300',filename)
%% EPS+PNG+FIG
% part of: SAVE FIGURE
gcf;
filename=input('FILENAME? [testFigure]:','s');
if isempty(filename)
    filename1 = 'testFigure.eps';
    filename2 = 'testFigure.png';
    filename3 = 'testFigure.fig';
else
    filename1 = strcat(filename,'.eps');
    filename2 = strcat(filename,'.png');
    filename3 = strcat(filename,'.fig');
end
set(gcf,'color','w')
set(gcf,'PaperPositionMode','auto')
set(gcf,'InvertHardcopy','off')

print('-depsc','-r300',filename1);
print('-dpng','-r300',filename2);
savefig(filename3);