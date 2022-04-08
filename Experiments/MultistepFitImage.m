function [mapsWithSigma,filteredSigma,maps] = MultistepFitImage(imData,slice,indent,filterSize)
%function [mapsWithSigma,filteredSigma,maps] = MultistepFitImage(imData,slice,indent,filterSize)
    
% Multistep fitting consists of: 
% (a) Generation of sigma maps using FitImageSigma
% (b) Smoothing of sigma map using median filter
% (c) Generation of final parameter maps using fixed sigma from (b)

%Inputs

%1. imData

    %imData.images is a 5-D array of size (nx,ny,nz,ncoils,nTE)
    %imData.TE is 1-by-n vector of echotime values
    %imData.FieldStrength is field strength in Tesla

%2. slice is specified by user (integer value)
    
%3. ROI is a logical array of dimension nx-by-ny 
%(matching the size of the images in imData.images)
% This is applied to the specified slice to obtain sigma for Rician fitting)

%4. Specify indent (integer value) to cut down processing time
%e.g indent=100;

%5. Specify filter size for median filtering operation

%Outputs
% Maps structure containing FF, R2* and sigma maps from different stages


matSize=size(imData.images,1);

%% 1. Estimate sigma for image
mapsWithSigma = FitImageSigma(imData,slice,indent)

%% 2. Median filter sigma to 'smooth' sigma estimates
filteredSigma=medfilt2(mapsWithSigma.sigma,[filterSize filterSize]);
imshow(filteredSigma,[0 100])

%% 3. Used filtered sigma map to initialise fitting with fixed sigma
maps = FitImage(imData,slice,filteredSigma,indent)

%% 4. Show Step1 and Step2 maps for comparison
figure
subplot(2,4,1)
imshow(mapsWithSigma.FFrician(indent:matSize-indent,indent:matSize-indent),[0 1])
title('PDFF with floating sigma')
colormap('parula') 

subplot(2,4,2)
imshow(mapsWithSigma.R2rician(indent:matSize-indent,indent:matSize-indent),[0 0.25])
title('R2* with floating sigma')

subplot(2,4,3)
imshow(mapsWithSigma.sigma(indent:matSize-indent,indent:matSize-indent),[0 100])
title('Sigma estimate')

subplot(2,4,4)
imshow(filteredSigma(indent:matSize-indent,indent:matSize-indent),[0 100])
title('Filtered sigma estimate')

subplot(2,4,7)
hist(reshape(mapsWithSigma.sigma(indent:matSize-indent,indent:matSize-indent),1,[]),[0:2.5:150])
xlabel('Sigma^2')
ylabel('Voxels')
title('Sigma histogram')

subplot(2,4,8)
hist(reshape(filteredSigma(indent:matSize-indent,indent:matSize-indent),1,[]),[0:2.5:150])
xlabel('Sigma^2')
ylabel('Voxels')
title('Filtered sigma histogram')

%% 5. Show Step1 and Step2 maps for comparison

figure
subplot(3,4,5)
imshow(maps.FFrician(indent:matSize-indent,indent:matSize-indent),[0 1])
title('PDFF using fixed sigma')
colormap('parula')
colorbar

subplot(3,4,6)
imshow(maps.R2rician(indent:matSize-indent,indent:matSize-indent),[0 0.25])
title('R2* using fixed sigma')
colorbar 

subplot(3,4,9)
imshow(maps.FFrician(indent:matSize-indent,indent:matSize-indent)-mapsWithSigma.FFrician(indent:matSize-indent,indent:matSize-indent),[-0.1 0.1])
title('PDFF difference (step2 - step1)')
colorbar 

subplot(3,4,10)
imshow(maps.R2rician(indent:matSize-indent,indent:matSize-indent)-mapsWithSigma.R2rician(indent:matSize-indent,indent:matSize-indent),[-0.05 0.05])
title('R2* difference (step2 - step1)')
colorbar 

%% 4. Show MAGORINO vs MAGO
figure
subplot(2,3,1)
imshow(maps.FFstandard(indent:matSize-indent,indent:matSize-indent),[0 1])
title('PDFF Gaussian')
colormap('parula')
colorbar

subplot(2,3,2)
imshow(maps.FFrician(indent:matSize-indent,indent:matSize-indent),[0 1])
title('PDFF Rician')
colormap('parula')
colorbar

subplot(2,3,3)
imshow(maps.FFrician(indent:matSize-indent,indent:matSize-indent) - maps.FFstandard(indent:matSize-indent,indent:matSize-indent),[-0.1 0.1])
title('PDFF Rician - PDFF Gaussian')
colorbar 

subplot(2,3,4)
imshow(maps.R2standard(indent:matSize-indent,indent:matSize-indent),[0 0.25])
title('R2* Gaussian')
colorbar 

subplot(2,3,5)
imshow(maps.R2rician(indent:matSize-indent,indent:matSize-indent),[0 0.25])
title('R2* Rician')
colorbar 

subplot(2,3,6)
imshow(maps.R2rician(indent:matSize-indent,indent:matSize-indent) - maps.R2standard(indent:matSize-indent,indent:matSize-indent),[-0.05 0.05])
title('R2* Rician - R2* Gaussian')
colorbar 









