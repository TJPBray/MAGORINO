function [maps] = MultistepFitImage(imData,roi)
%function [maps] = MultistepFitImage(imData,indent,roi)
    
% Multistep fitting consists of: 
% (a) Generation of sigma maps using FitImageSigma
% (b) Smoothing of sigma map using median filter
% (c) Generation of final parameter maps using fixed sigma from (b)

%Inputs

%1. imData

    %imData.images is a 5-D array of size (nx,ny,nz,ncoils,nTE)
    %imData.TE is 1-by-n vector of echotime values
    %imData.FieldStrength is field strength in Tesla
    
%3. ROI is a structure containing 
% (i) a logical array of dimension nx-by-ny (matching the size of the images in imData.images)
% The slice number 
% The size of the array (matching the size of the images)

%4. Specify indent (integer value) to cut down processing time
%e.g indent=100;

%5. Specify filter size for median filtering operation

%Outputs
% Maps structure containing FF, R2* and sigma maps from different stages


matSize=size(imData.images,1);
indent = imData.fittingIndent;


%% 1. Estimate sigma for roi
[mapsWithSigma,sigmaFromRoi,sigmaFromFit] = FitImageSigma(imData,roi); %Reduce indent by filtersize for first step to avoid introducing 0s with median filter

%% 2. Median filter sigma to 'smooth' sigma estimates
% filteredSigma=medfilt2(mapsWithSigma.sigma,[filterSize filterSize]);
% 
% smoothSNR=mapsWithSigma.S0./filteredSigma;

%% 3. Used sigma estimate to fit with fixed sigma

%Decide whether to use both sigma 
sigmaBoth = 0;

%3.1 Using sigma from fit
mapsFittedSigma = FitImage(imData,roi.slice,sigmaFromFit);

if sigmaBoth == 1 

%3.1 Using sigma from ROI
mapsRoiSigma = FitImage(imData,roi.slice,sigmaFromRoi);


% %% 4. Show Step1 and Step2 maps for comparison
% 
% indent=imDataParams.fittingIndent;
% 
% figure
% subplot(2,4,1)
% imshow(mapsWithSigma.FFrician(indent:matSize-indent,indent:matSize-indent),[0 1])
% title('PDFF with floating sigma')
% colormap('parula') 
% 
% subplot(2,4,2)
% imshow(mapsWithSigma.R2rician(indent:matSize-indent,indent:matSize-indent),[0 0.25])
% title('R2* with floating sigma')
% 
% subplot(2,4,3)
% imshow(mapsWithSigma.sigma(indent:matSize-indent,indent:matSize-indent),[0 100])
% title('Sigma estimate')

% %% 4. Show effect of different sigma estimation methods
% indent = 110;
% 
% figure
% subplot(4,3,1)
% imshow(mapsRoiSigma.FFstandard(indent:matSize-indent,indent:matSize-indent),[0 1])
% title('PDFF Gaussian')
% colormap('parula')
% colorbar
% 
% subplot(4,3,2)
% imshow(mapsRoiSigma.FFrician(indent:matSize-indent,indent:matSize-indent),[0 1])
% title('PDFF Rician with ROI-based sigma')
% colormap('parula')
% colorbar
% 
% subplot(4,3,3)
% imshow(mapsFittedSigma.FFrician(indent:matSize-indent,indent:matSize-indent),[0 1])
% title('PDFF Rician with fitting-based sigma')
% colormap('parula')
% colorbar
% 
% subplot(4,3,4)
% imshow(mapsRoiSigma.R2standard(indent:matSize-indent,indent:matSize-indent),[0 0.3])
% title('R2* Gaussian')
% colorbar
% 
% subplot(4,3,5)
% imshow(mapsRoiSigma.R2rician(indent:matSize-indent,indent:matSize-indent),[0 0.3])
% title('R2* Rician with ROI-based sigma')
% colorbar
% 
% subplot(4,3,6)
% imshow(mapsFittedSigma.R2rician(indent:matSize-indent,indent:matSize-indent),[0 0.3])
% title('R2* Rician with fitting-based sigma')
% colorbar
% 
% subplot(4,3,8)
% imshow(mapsRoiSigma.R2rician(indent:matSize-indent,indent:matSize-indent) - mapsRoiSigma.R2standard(indent:matSize-indent,indent:matSize-indent),[-0.02 0.02])
% title('R2* Rician with ROI-based sigma - Gaussian')
% colorbar
% 
% subplot(4,3,9)
% imshow(mapsFittedSigma.R2rician(indent:matSize-indent,indent:matSize-indent) - mapsFittedSigma.R2standard(indent:matSize-indent,indent:matSize-indent),[-0.02 0.02])
% title('R2* Rician with fitting-based sigma - Gaussian')
% colorbar
% 
% subplot(4,3,12)
% imshow(mapsRoiSigma.R2rician(indent:matSize-indent,indent:matSize-indent) - mapsFittedSigma.R2rician(indent:matSize-indent,indent:matSize-indent), [-0.02 0.02])
% title('R2* Rician with fitting-based sigma - R2* Rician with ROI-based sigma')
% colorbar


% figure
% subplot(1,3,1)
% scatter(mapsRoiSigma.R2rician(indent:matSize-indent,indent:matSize-indent),mapsRoiSigma.R2standard(indent:matSize-indent,indent:matSize-indent))
% xlim([0 1])
% ylim([0 1])
% xlabel('R2* with ROI-based sigma')
% ylabel('R2* Gaussian')
% 
% subplot(1,3,2)
% scatter(mapsFittedSigma.R2rician(indent:matSize-indent,indent:matSize-indent),mapsRoiSigma.R2standard(indent:matSize-indent,indent:matSize-indent))
% xlim([0 1])
% ylim([0 1])
% xlabel('R2* with Fitting-based sigma')
% ylabel('R2* Gaussian')
% 
% subplot(1,3,3)
% scatter(mapsRoiSigma.R2rician(indent:matSize-indent,indent:matSize-indent),mapsFittedSigma.R2rician(indent:matSize-indent,indent:matSize-indent))
% xlim([0 1])
% ylim([0 1])
% xlabel('R2* with ROI-based sigma')
% ylabel('R2* fitting-based sigma')

else; 
end

% Assign chosen method to maps structure to enable illustration
maps = mapsFittedSigma; 

%% 5. Show MAGORINO vs MAGO

%Visualisation of distribution and mask derivation
figure
subplot(1,2,1)
hist(reshape(maps.S0rician,1,[]),20)
hold on
%Get 95the percentile
p=prctile(reshape(maps.S0rician,1,[]),50)

plot([p p],ylim)
hold off

%Calculate mask
mask = maps.S0rician>p;

mask = double(mask);

%Create NaNs for zero values
mask(mask==0) = NaN;

%Show mask
subplot(1,2,2)
imshow(mask,[])

figure
subplot(3,3,1)
imshow(maps.FFstandard,[0 1])
title('PDFF Gaussian')
colormap('parula')
colorbar

subplot(3,3,2)
imshow(maps.FFrician,[0 1])
title('PDFF Rician')
colormap('parula')
colorbar

subplot(3,3,3)
imshow((maps.FFrician - maps.FFstandard),[-0.1 0.1])
title('PDFF Rician - PDFF Gaussian')
colorbar 

subplot(3,3,4)
imshow((1000*maps.R2standard),[0 250])
title('R2* Gaussian')
colorbar 

subplot(3,3,5)
imshow((1000*maps.R2rician),[0 250])
title('R2* Rician')
colorbar 

subplot(3,3,6)
imshow(mask.*(1000*maps.R2rician - 1000*maps.R2standard),[-50 50])
title('R2* Rician - R2* Gaussian')
colorbar 

subplot(3,3,7)
imshow(maps.S0standard,[0 max(maps.S0standard,[],'all')])
title('S0 Gaussian')
colorbar 

subplot(3,3,8)
imshow(maps.S0rician,[0 max(maps.S0standard,[],'all')])
title('S0 Rician')
colorbar 

subplot(3,3,9)
imshow((maps.S0rician - maps.S0standard),[-0.01*max(maps.S0standard,[],'all') 0.01*max(maps.S0standard,[],'all')])
title('S0 Rician - S0 Gaussian')
colorbar 














