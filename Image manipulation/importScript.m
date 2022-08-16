

%% 1. Import 

%1.1 Select folder
foldername= '/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data/Subjects';

%1.2 Get folder info 
folderinfo=dir(foldername);
n=numel(folderinfo)-2;

%1.3 Get filename
filename='LegsSwapData.dcm';

%1.3 Import dicom file
file = dicomread(filename);

stack = dicomread(fullfile(foldername, filename));

size(stack)

newanal2(stack(:,:,1,:))

%1.4 Get Dicom info
info=dicominfo(fullfile(foldername, filename));

echotimes = info.Private_2001_1025

%% 2. Select raw data elements

%2.1
rawDataStack = stack(:,:,1,1:300);

%2.2 Loop through elements (6 slices for single slice, then next slice; 50
%slices in total)

slices = 50;
echoNum=6;

for sl = 1:slices

    for echo = 1:echoNum
        
        index = 6*(sl - 1) + echo;


        imageData(:,:,sl,1,echo) = rawDataStack(:,:,index);

    end
end

size(imageData)

%2.3 Check consistency of appearance of one echo throughout volume
newanal2(imageData(:,:,:,1,1))

%2.4 Check evolution of india ink pattern for one slice through echo times
newanal2(imageData(:,:,slices/2,1,:))

%% 3. Create imData structure for fitting

%3.1 Create imDataParams.images
imDataParams.images = double(imageData);

%3.2 Create imDataParams.TE
imDataParams.TE = (1.26:0.97:6.11)/1000;

%3.2 Create imDataParams.fieldstrength
imDataParams.FieldStrength = 3;

newanal2(imDataParams.images(:,:,:,1,3))

