
function [maps,noisestats] = FitImage(imData,slice,sigma)
% function [maps,noisestats] = FitImage(imData,slice,sigma)
    
%Takes data in imData structure and generates maps

%Inputs

%1. imData

    %imData.images is a 5-D array of size (nx,ny,nz,ncoils,nTE)
    %imData.TE is 1-by-n vector of echotime values
    %imData.FieldStrength is field strength in Tesla
    %imData.fittingIndent is indent for fitting

%2. slice is specified by user (integer value)
    
%3. sigmaMap is estimate of sigma determined a priori

%Outputs
% Maps structure containing FF and R2* maps for standard, Rician and
% complex fitting

% Noisestats structure giving estimated sigma, mean S and SNR

%% 1. Reformat data where needed

%Convert TE to ms
TE=1000*imData.TE;

TE=reshape(TE,6,1);

indent=imData.fittingIndent;

%% 2. Get images for the chosen slice
for echoN=1:numel(TE)  
Scomplex_slice(:,:,echoN)=imData.images(:,:,slice,1,echoN);
end

Smag_slice=abs(Scomplex_slice);

%% Get noise measurement based on ROI (not currently used as sigma is estimated from prior fitting step)
% 
% %Get image intensities from first echotime
% Scomplex_slice_TE1=Scomplex_slice(:,:,1);
% 
% %Get elements from first echotime image present in ROI
% Scomplex_ROI=Scomplex_slice_TE1(ROI==1);
% 
% %Take SD of ROI in real and imaginary channels
% sig_real=std(real(Scomplex_ROI));
% sig_imag=std(imag(Scomplex_ROI));
% 
% %Average real and imaginary sigs to create estimate for fitting
% sig=(sig_real + sig_imag)/2;
% 
% %Add to noisestats structure
% noisestats.sigma=sig;
% 
% %Get mean from ROI
% noisestats.meanS=mean(abs(Scomplex_ROI));
% 
% noisestats.SNR=noisestats.meanS/sig;

%% 3. Prefill arrays prior to fitting
FFrician=zeros(size(Smag_slice,1),size(Smag_slice,2));
FFstandard=zeros(size(Smag_slice,1),size(Smag_slice,2));
FFcomplex=zeros(size(Smag_slice,1),size(Smag_slice,2));
R2rician=zeros(size(Smag_slice,1),size(Smag_slice,2));
R2standard=zeros(size(Smag_slice,1),size(Smag_slice,2));
R2complex=zeros(size(Smag_slice,1),size(Smag_slice,2));
S0rician=zeros(size(Smag_slice,1),size(Smag_slice,2));
S0standard=zeros(size(Smag_slice,1),size(Smag_slice,2));
S0complex=zeros(size(Smag_slice,1),size(Smag_slice,2));


%% Set ground truth values to 0
GT.p=[0 0 0 0];
GT.S=[0 0 0 0 0 0];

%% 4. Loop over voxels in image and fit each one 

for posX=(1+indent):(size(Smag_slice,2)-indent)     %Describes location of chosen pixel
parfor posY=(1+indent):(size(Smag_slice,1)-indent)
    
%4.1 Get pixel data for specified pixel
Smag=Smag_slice(posY,posX,:);
Smag=reshape(Smag,1,6);


%% 5. Implement fitting

%5.1 Only perform fitting for voxels where all signal values are nonzero (otherwise skip voxel) - Rician
%likelihood function returns an error otherwise

if prod(Smag)>0

%5.2 Perform fitting
outparams = FittingWrapper(TE, imData.FieldStrength, Smag, sigma, GT); %echotimes, fieldstrength, measured signal, measured sigma

%5.3 Add values to parameter maps 
FFrician(posY,posX)=outparams.Rician.F/(outparams.Rician.F+outparams.Rician.W);
FFstandard(posY,posX)=outparams.standard.F/(outparams.standard.F+outparams.standard.W);
FFcomplex(posY,posX)=outparams.complex.F/(outparams.complex.F+outparams.complex.W);

R2rician(posY,posX)=outparams.Rician.R2;
R2standard(posY,posX)=outparams.standard.R2;
R2complex(posY,posX)=outparams.complex.R2;

S0rician(posY,posX)=outparams.Rician.F + outparams.Rician.W;
S0standard(posY,posX)=outparams.standard.F + outparams.standard.W;
R2complex(posY,posX)=outparams.complex.F + outparams.complex.W;

posX

else;
end

end

end

%Add maps to images structure
maps.FFrician=FFrician;
maps.FFstandard=FFstandard;
maps.FFcomplex=FFcomplex;
maps.R2rician=R2rician;
maps.R2standard=R2standard;
maps.R2complex=R2complex;
maps.S0rician=S0rician;
maps.S0standard=S0standard;
maps.S0complex=S0complex;

%% Create figures
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
imshow(maps.FFrician - maps.FFstandard,[-0.1 0.1])
title('PDFF Rician - PDFF Gaussian')
colorbar 

subplot(3,3,4)
imshow(1000*maps.R2standard,[0 250])
title('R2* Gaussian')
colorbar 

subplot(3,3,5)
imshow(1000*maps.R2rician,[0 250])
title('R2* Rician')
colorbar 

subplot(3,3,6)
imshow(1000*maps.R2rician - 1000*maps.R2standard,[-50 50])
title('R2* Rician - R2* Gaussian')
colorbar 

subplot(3,3,7)
imshow(maps.S0standard,[0 0.01*max(maps.S0standard,[],'all')])
title('S0 Gaussian')
colorbar 

subplot(3,3,8)
imshow(maps.S0rician,[0 0.01*max(maps.S0standard,[],'all')])
title('S0 Rician')
colorbar 

subplot(3,3,9)
imshow(maps.S0rician - maps.S0standard,[-0.01*max(maps.S0standard,[],'all') 0.01*max(maps.S0standard,[],'all')])
title('S0 Rician - S0 Gaussian')
colorbar 


end

