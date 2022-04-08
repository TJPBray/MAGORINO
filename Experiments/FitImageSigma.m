
function [maps] = FitImageSigma(imData,slice,indent)
% function [maps] = FitImage(imData,slice)
    
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

%4. Specify indent (integer value) to cut down processing time
%e.g indent=100;

%Outputs
% Maps structure containing FF, R2* and sigma maps for Rician fitting

%% 1. Reformat data where needed

%Convert TE to ms
TE=1000*imData.TE;

TE=reshape(TE,6,1);

%% 2. Get images for the chosen slice
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

% Set ground truth values to 0
GT.p=[0 0 0 0];
GT.S=[0 0 0 0 0 0];

%% 4. Loop over voxels in image and fit each one 

for posX=(1+indent):(size(Smag_slice,2)-indent)     %Describes location of chosen pixel
parfor posY=(1+indent):(size(Smag_slice,1)-indent)
    
%4.1 Get pixel data for single pixel
Smag=Smag_slice(posY,posX,:);
Smag=reshape(Smag,1,6);

%% 5. Implement fitting

%5.1 Determine sigma initialisation value depending on SNR
if imData.FieldStrength==3;
SNRest=60;
elseif imData.FieldStrength==1.5;
SNRest=30;
else error('Field Strength not recognised - sigma initialisation failed')
end

%5.2 Specify initialisation values and bounds 
algoparams = setAlgoparams(Smag,SNRest,2) %opt=2 specifies inclusion of bounds for sigma in algoParams

%5.3 Check all signal values are nonzero (otherwise skip voxel) - Rician
%likelihood function returns an error otherwise

if prod(Smag)>0

%5.4 Run Rician fitting with sigma included as a parameter to estimate the value of sigma
outparams = RicianMagnitudeFitting_WithSigma(TE, imData.FieldStrength, Smag, algoparams.sigEst, GT, algoparams); %echotimes, fieldstrength, measured signal, initial estimate of sigma, ground truth initialisation, algoparams

%5.5 Add values to parameter maps 
FFrician(posY,posX)=outparams.F/(outparams.F+outparams.W);
% FFstandard(posY,posX)=outparams.standard.F/(outparams.standard.F+outparams.standard.W);
% FFcomplex(posY,posX)=outparams.complex.F/(outparams.complex.F+outparams.complex.W);

R2rician(posY,posX)=outparams.R2;
% R2standard(posY,posX)=outparams.standard.R2;
% R2complex(posY,posX)=outparams.complex.R2;

sigmaEstimates(posY,posX)=outparams.sig;

else ;
end


posX

end

end

%Add maps to images structure
maps.FFrician=FFrician;
% maps.FFstandard=FFstandard;
% maps.FFcomplex=FFcomplex;
maps.R2rician=R2rician;
% maps.R2standard=R2standard;
% maps.R2complex=R2complex;
maps.sigma=sigmaEstimates;

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
imshow(maps.sigma,[0 100])
colorbar
title('Sigma')

end

