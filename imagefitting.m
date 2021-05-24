%Phantom Fitting master

function images=imagefitting(imDataAll,fwmc_ff,fwmc_r2star,sig)

%Takes data from Hernando data repository and fits MAGO
%Need to modify to account for variation in field strength - initially set
%up for 3T


%3 slices of phantom scans included

%problem if some datapoints are 0 - may  need to exclude these
%Initially seems to work for site 2 3T (p1), site 3 3T (p1), site 5 3T (p1) using sig=5

%Pick central slice
slice=round(size(imDataAll.images,3)/2); 

%Convert TE to ms
TE=1000*imDataAll.TE;

%Reshape
TE=reshape(TE,1,6);

%Get magnitude images for the chosen slice
for echoN=1:6  
M(:,:,echoN)=abs(imDataAll.images(:,:,slice,1,echoN));
end

% %Get noise measurement based on ROI
% sig=5;

%Prefill
FFrician=zeros(size(fwmc_ff,1),size(fwmc_ff,2));
FFstandard=zeros(size(fwmc_ff,1),size(fwmc_ff,2));
FFcomplex=zeros(size(fwmc_ff,1),size(fwmc_ff,2));
R2rician=zeros(size(fwmc_ff,1),size(fwmc_ff,2));
R2standard=zeros(size(fwmc_ff,1),size(fwmc_ff,2));
R2complex=zeros(size(fwmc_ff,1),size(fwmc_ff,2));

%Specify indent to cut down processing time
indent=100;

for posX=(1+indent):(size(M,2)-indent)     %Describes location of chosen pixel
parfor posY=(1+indent):(size(M,1)-indent)
    
%Get pixel data for single pixel
Mag=M(posY,posX,:);
Mag=reshape(Mag,1,6);

%Implement fitting
try
    
outparams = R2fitting(TE, imDataAll.FieldStrength, Mag, sig); %echotimes, fieldstrength, measured signal, measured sigma

FFrician(posY,posX)=outparams.Rician.F/(outparams.Rician.F+outparams.Rician.W);
FFstandard(posY,posX)=outparams.standard.F/(outparams.standard.F+outparams.standard.W);
FFcomplex(posY,posX)=outparams.complex.F/(outparams.complex.F+outparams.complex.W);

R2rician(posY,posX)=outparams.Rician.R2;
R2standard(posY,posX)=outparams.standard.R2;
R2complex(posY,posX)=outparams.complex.R2;

catch
end

posX
end

end

%Add maps to images structure
images.FFrician=FFrician;
images.FFstandard=FFstandard;
images.FFcomplex=FFcomplex;
images.R2rician=R2rician;
images.R2standard=R2standard;
images.R2complex=R2complex;

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

subplot(1,4,4)
imshow(fwmc_ff(:,:,slice),[0 100])
title('Fat fraction, Hernando')
colorbar

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

subplot(1,4,4)
imshow(fwmc_r2star(:,:,slice),[0 10])
title('R2*, Hernando')

end

