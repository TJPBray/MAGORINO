
%% Phantom fitting 
% Import raw multiecho data from Hernando dataset and ROIs for Rician fitting

% Author:
% Tim Bray, t.bray@ucl.ac.uk
% January 2022

%% 1. Import multiecho data and ROIs

%1.1 Define folders for import of multiecho data and ROIs
imagefolder='/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data';
ROIfolder='/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data';

%1.2 Define filenames for multiecho data and ROIs
dataFileName = 'FWBphantom_bipolar.mat';
roiFileName = 'FWBphantom_bipolar_ROIs.nii.gz';

%1.3 Import multiecho data and ROI
load(fullfile(imagefolder,dataFileName));
phantomROIs = niftiread(fullfile(ROIfolder,roiFileName));
    % phantomImage = niftiread(fullfile(folder,dataFileName));

% Specify slice (use 1 if only 1 slice)
sl=12;

%1.4 Show check image for alignment
figure
subplot(1,3,1)
imshow(phantomROIs(:,:,1),[])
title('ROIs')

subplot(1,3,2)
imshow(abs(imDataParams.images(:,:,sl,1,1)),[])
title('Magnitude image of phantom (first echo)')

% subplot(1,3,3)
% imshow(fwmc_ff(:,:,2),[0 100])
% title('PDFF map of phantom')

%% 2. Specify reference values
% Vreate grid of reference values based on phantom structure
ReferenceValues.FF = repelem([0, 0.2, 0.4, 0.5, 0.6],4,1);
ReferenceValues.R2 = repelem([150; 100; 50; 0],1,5);

%% 3. Perform fitting of multiecho data, using sigma estimate from phantom ROIs

%3.1 Specify indent (to avoid fitting dead space at edge of phantom)
indent=20;

%3.2 Perform image fitting
[maps,noisestats] = FitImage(imDataParams.images,sl,phantomROIs(:,:,sl),indent)

% %3.3 Visualise fitted results and reference FF maps
% Createfig_maps(maps) %Createfig_maps(maps,referenceFF)

%% 5. Perform statistical analysis of agreement between measured FF values and reference values

PhantomRoiAnalysis(maps,phantomROIs,ReferenceValues)