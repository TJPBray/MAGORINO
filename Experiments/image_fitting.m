
function maps = image_fitting(imData,slice,ROI)
% function maps = image_fitting(imData,slice,ROI)
    
%Takes data in imData structure and generates maps

%Inputs

%1. imData

    %imData.images is a 5-D array of size (nx,ny,nz,ncoils,nTE)
    %imData.TE is 1-by-n vector of echotime values
    %imData.FieldStrength is field strength in Tesla

%2. slice is specified by user (integer value)
    
%3. ROI is a logical array of dimension nx-by-ny (matching the size of the
%images in imData.images)
% This applied to the specified slice to obtain sigma for Rician fitting)

%Outputs
% Maps structure containing FF and R2* maps for standard, Rician and
% complex fitting

%% Reformat data where needed

%Convert TE to ms
TE=1000*imData.TE;

%Reshape
TE=TE';

%% Get images for the chosen slice
for echoN=1:numel(TE)  
Scomplex_slice(:,:,echoN)=imData.images(:,:,slice,1,echoN);
end

Smag_slice=abs(Scomplex_slice);

%% Get noise measurement based on ROI

%Get image intensities from first echotime
Scomplex_slice_TE1=Scomplex_slice(:,:,1);

%Get elements from first echotime image present in ROI
Scomplex_ROI=Scomplex_slice_TE1(ROI==1);

%Take SD of ROI in real and imaginary channels
sig_real=std(real(Scomplex_ROI));
sig_imag=std(imag(Scomplex_ROI));

%Average real and imaginary sigs to create estimate for fitting
sig=(sig_real + sig_imag)/2;

%% Prefill arrays prior to fitting
FFrician=zeros(size(Smag_slice,1),size(Smag_slice,2));
FFstandard=zeros(size(Smag_slice,1),size(Smag_slice,2));
FFcomplex=zeros(size(Smag_slice,1),size(Smag_slice,2));
R2rician=zeros(size(Smag_slice,1),size(Smag_slice,2));
R2standard=zeros(size(Smag_slice,1),size(Smag_slice,2));
R2complex=zeros(size(Smag_slice,1),size(Smag_slice,2));

%Specify indent to cut down processing time
indent=100;

%% Loop over voxels in image and fit each one 

for posX=(1+indent):(size(Smag_slice,2)-indent)     %Describes location of chosen pixel
for posY=(1+indent):(size(Smag_slice,1)-indent)
    
%Get pixel data for single pixel
Smag=Smag_slice(posY,posX,:);
Smag=reshape(Smag,6,1);

%% Implement fitting

outparams = R2fitting(TE, imData.FieldStrength, Smag, sig); %echotimes, fieldstrength, measured signal, measured sigma

FFrician(posY,posX)=outparams.Rician.F/(outparams.Rician.F+outparams.Rician.W);
FFstandard(posY,posX)=outparams.standard.F/(outparams.standard.F+outparams.standard.W);
FFcomplex(posY,posX)=outparams.complex.F/(outparams.complex.F+outparams.complex.W);

R2rician(posY,posX)=outparams.Rician.R2;
R2standard(posY,posX)=outparams.standard.R2;
R2complex(posY,posX)=outparams.complex.R2;

posX

end

end

%Add maps to images structure
maps.FFrician=FFrician;
maps.FFstandard=FFstandard;
maps.FFcomplex=FFcomplex;
maps.R2rician=R2rician;
maps.R2standard=R2standard;
maps.R2complex=R2complex;

%
figure
subplot(1,4,1)
imshow(FFrician,[0 1])
title('Fat fraction, Rician MAGO')
colorbar

subplot(1,4,2)
imshow(FFstandard,[0 1])
title('Fat fraction, standard MAGO')
colorbar

subplot(1,4,3)
imshow(FFrician-FFstandard,[0 0.1])
title('Fat fraction difference')
colorbar

% subplot(1,4,4)
% imshow(fwmc_ff(:,:,slice),[0 100])
% title('Fat fraction, Hernando')
% colorbar

figure
subplot(1,4,1)
imshow(R2rician,[0 0.2])
title('R2*, Rician MAGO')
colorbar
subplot(1,4,2)
imshow(R2standard,[0 0.2])
title('R2*, standard MAGO')
colorbar

subplot(1,4,3)
imshow(R2rician-R2standard,[0 0.05])
title('R2*, standard MAGO')
colorbar

% subplot(1,4,4)
% imshow(fwmc_r2star(:,:,slice),[0 10])
% title('R2*, Hernando')

end

