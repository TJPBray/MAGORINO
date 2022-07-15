
function [maps,sigmaFromRoi,sigmaFromFit] = FitImageSigma(imData,roi)
% function [maps,sigmaFromRoi,sigmaFromFit] = FitImage(imData,slice)
    
%Takes data in imData structure and generates maps
%Differs from FitImage in that sigma is estimated through fitting in each voxel prior
%to definitive fitting with fixed sigma. Uses Rician fitting only. 

%Inputs

%1. imData

    %imData.images is a 5-D array of size (nx,ny,nz,ncoils,nTE)
    %imData.TE is 1-by-n vector of echotime values
    %imData.FieldStrength is field strength in Tesla

%2. slice is specified by user (integer value)
    
%3. ROI is a logical array of dimension nx-by-ny 
%(matching the size of the images in imData.images)
% This is applied to the specified slice to obtain sigma for Rician fitting)

%4. fieldStrength is used to initialise sigma

%5. Specify indent (integer value) to cut down processing time
%e.g indent=100;

%Outputs
% Maps structure containing FF, R2* and sigma maps for Rician fitting


%% 1. Reformat data where needed / preliminary steps 

%1.1 Convert TE to ms
TE=1000*imData.TE;

TE=reshape(TE,6,1);

%1.2 Get indent
indent = imData.fittingIndent;
slice = roi.slice;


%% 2. Get image data for the chosen slice
for echoN=1:numel(TE)  
Scomplex_slice(:,:,echoN)=imData.images(:,:,slice,1,echoN);
end

Smag_slice=abs(Scomplex_slice);

%% 3. Prefill arrays prior to fitting
FFrician=zeros(size(Smag_slice,1),size(Smag_slice,2));
% FFstandard=zeros(size(Smag_slice,1),size(Smag_slice,2));
% FFcomplex=zeros(size(Smag_slice,1),size(Smag_slice,2));
R2rician=zeros(size(Smag_slice,1),size(Smag_slice,2));
% R2standard=zeros(size(Smag_slice,1),size(Smag_slice,2));
% R2complex=zeros(size(Smag_slice,1),size(Smag_slice,2));
sigmaEstimates=zeros(size(Smag_slice,1),size(Smag_slice,2));
s0Estimates=zeros(size(Smag_slice,1),size(Smag_slice,2));

% Set ground truth values to 0
GT.p=[0 0 0 0];
GT.S=[0 0 0 0 0 0];

%% 4. Determine sigma value from raw signal intensities in the ROI (use the data from the echo time closest to in phase)

%4.1 Get sigma estimates for each TE

for k=1:6
Smag_slice_oneEcho = Smag_slice(:,:,k);
maskedImageVals = Smag_slice_oneEcho(roi.mask==1); %For the multisite phantom data, this selects the pure water vial 
stdMaskedIm(k) = std(maskedImageVals);
end

%4.2 Choose TE closest to in phase
[~,TEindex] = min(abs(imData.TE - 0.0023));

sigmaFromRoi = stdMaskedIm(TEindex);

%% 5. Loop over voxels in image and fit each one 

%5.1 Find indices of mask elements
[y,x]=find(roi.mask==1);

%5.2 Loop through each of the mask elements 
for k = 1:numel(x) %numel x is number of pixels in mask

    posX=x(k);
    posY=y(k);
    
    
%5.4 Get pixel data for single pixel
Smag=Smag_slice(posY,posX,:);
Smag=reshape(Smag,1,6);

%5.5 Specify initialisation values and bounds 
algoparams = setAlgoparams(Smag,sigmaFromRoi,2); %opt=2 specifies inclusion of bounds for sigma in algoParams

%% 6. Implement fitting

%6.1 Check all signal values are nonzero (otherwise skip voxel) - Rician
%likelihood function returns an error otherwise

if prod(Smag)>0

%6.2 Run Rician fitting with sigma included as a parameter to estimate the value of sigma
outparams = RicianMagnitudeFitting_WithSigma(TE, imData.FieldStrength, Smag, algoparams.sigEst, GT, algoparams); %echotimes, fieldstrength, measured signal, initial estimate of sigma, ground truth initialisation, algoparams

%6.3 Add values to parameter maps 
FFrician(posY,posX)=outparams.F/(outparams.F+outparams.W);
% FFstandard(posY,posX)=outparams.standard.F/(outparams.standard.F+outparams.standard.W);
% FFcomplex(posY,posX)=outparams.complex.F/(outparams.complex.F+outparams.complex.W);

R2rician(posY,posX)=outparams.R2;
% R2standard(posY,posX)=outparams.standard.R2;
% R2complex(posY,posX)=outparams.complex.R2;

sigmaEstimates(posY,posX)=outparams.sig;

s0Estimates(posY,posX)=outparams.F+outparams.W;

else ;
end

k/numel(x)

end


%Add maps to images structure
maps.FFrician=FFrician;
% maps.FFstandard=FFstandard;
% maps.FFcomplex=FFcomplex;
maps.R2rician=R2rician;
% maps.R2standard=R2standard;
% maps.R2complex=R2complex;
maps.sigma=sigmaEstimates;

maps.S0=s0Estimates;
maps.SNR = s0Estimates./sigmaEstimates;

figure
subplot(1,3,1)
imshow(maps.FFrician,[0 1])
colorbar
colormap('parula')
title('PDFF')

subplot(1,3,2)
imshow(maps.R2rician,[0 0.3])
colorbar
title('R2*')

subplot(1,3,3)
imshow(maps.sigma,[])
colorbar
title('Sigma')

sigmaFromFit = median(maps.sigma(maps.sigma>0));

end

