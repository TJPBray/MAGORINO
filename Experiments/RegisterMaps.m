function [registeredff2,tform]=RegisterMaps(ff1,ff2);
%function [RegisteredVolume, Response]=RegisterFF(FFPRE,FFPOST);
%2D registration of a pair of FF slices to generate RegisteredVolume (ff2 is
%registered to fit ff1)

%Written by T Bray Jan 2022
%t.bray@ucl.ac.uk

%Follows the outline given on https://uk.mathworks.com/help/images/registering-multimodal-3-d-medical-images.html

% Select optimiser and metric to use with imregister
[optimiser, metric]=imregconfig('monomodal');

%Adjust parameters to improve performance
optimiser.MaximumIterations=100; %100 is default
optimiser.RelaxationFactor=0.5; %0.5 is default

% Provide spatial referencing information

Ref1=imref2d(size(ff1),2,2); %hard code pixel dimensions at 2mm for now
Ref2=imref2d(size(ff2),2,2);

% Replace any NaNs with 0 or with values from other scan 
FFPRE(isnan(ff1))=0;

%% 2 Register

%2.1 One option is to use imregister which generates the registered volume
%directly: 

%registeredff2 = imregister(ff2,ff1,'affine', optimiser, metric);

%Spatial referencing information can be given to improve registration:

%registeredff2 = imregister(ff2,Ref2,ff1,Ref1,'affine', optimiser, metric);

%2.2 Alternatively, first get the geometric transformation and then apply:

%Get geometric transformation
tform=imregtform(ff2,ff1,'affine', optimiser, metric);

% To apply the transform, useimwarp as follows:
registeredff2 =imwarp(ff2,tform,'OutputView',imref2d(size(ff1)));

%2.3 Show registered volumes

figure
subplot(2,2,1)
imshow(ff1,[0 1])
title('Fat fraction 1')
colorbar

subplot(2,2,2)
imshow(ff2,[0 1])
title('Fat fraction 2')
colorbar

subplot(2,2,3)
imshow(registeredff2,[0 1])
title('REGISTERED Fat fraction maps')
colorbar

subplot(2,2,4)
imshow(registeredff2-ff1,[0 1])
title('Difference map')
colorbar

end

