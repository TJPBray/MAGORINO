function [maps] = MultistepFitImage(imData,slice,indent)
%function [maps] = MultistepFitImage(imData,slice,indent)
    
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

%Outputs
% Maps structure containing FF, R2* and sigma maps from different stages

indent=80;
slice=20;
matSize=size(imData.images,1);

%% 1. Estimate sigma for image
mapsWithSigma = FitImageSigma(imData,slice,indent)

%% 2. Median filter sigma to 'smooth' sigma estimates
filteredSigma=medfilt2(mapsWithSigma.sigma,[25 25]);
imshow(filteredSigma,[0 100])

%% 3. Used filtered sigma map to initialise fitting with fixed sigma
maps = FitImage(imData,slice,filteredSigma,indent)

%% 4. Show Step1 and Step2 maps for comparison
figure
subplot(3,4,1)
imshow(mapsWithSigma.FFrician(indent:matSize-indent,indent:matSize-indent),[0 1])
title('PDFF with floating sigma')
colorbar 

subplot(3,4,2)
imshow(mapsWithSigma.R2rician(indent:matSize-indent,indent:matSize-indent),[0 0.25])
title('R2* with floating sigma')
colorbar 

subplot(3,4,3)
imshow(mapsWithSigma.sigma(indent:matSize-indent,indent:matSize-indent),[0 100])
title('Sigma estimate')
colorbar 

subplot(3,4,4)
imshow(filteredSigma(indent:matSize-indent,indent:matSize-indent),[0 100])
title('Filtered sigma')
colorbar 

subplot(3,4,5)
imshow(maps.FFrician(indent:matSize-indent,indent:matSize-indent),[0 1])
title('PDFF using sigma fixed from previous step')
colorbar 

subplot(3,4,6)
imshow(maps.R2rician(indent:matSize-indent,indent:matSize-indent),[0 0.25])
title('R2* using sigma fixed from previous step')
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
imshow(maps.FFstandard,[0 1])
title('PDFF Gaussian')
colorbar 

subplot(2,3,2)
imshow(maps.FFrician,[0 1])
title('PDFF Rician')
colorbar 

subplot(2,3,3)
imshow(maps.FFrician - maps.FFstandard,[-0.1 0.1])
title('PDFF Rician - PDFF Gaussian')
colorbar 

subplot(2,3,4)
imshow(maps.R2standard(indent:matSize-indent,indent:matSize-indent),[0 0.25])
title('R2* Rician')
colorbar 

subplot(2,3,5)
imshow(maps.R2rician(indent:matSize-indent,indent:matSize-indent),[0 0.25])
title('R2* Rician')
colorbar 

subplot(2,3,6)
imshow(maps.R2rician(indent:matSize-indent,indent:matSize-indent) - maps.R2standard(indent:matSize-indent,indent:matSize-indent),[-0.05 0.05])
title('R2* Rician - R2* Gaussian')
colorbar 









