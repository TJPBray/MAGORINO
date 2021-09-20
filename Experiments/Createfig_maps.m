function Createfig_maps(maps)
% Createfig(FFmaps,errormaps,sdmaps,residuals)

% Input: maps

% This function takes the outputs from image_fitting and generates figures
% showing and comparing maps

% Author:
% Tim Bray, t.bray@ucl.ac.uk


figure
subplot(1,4,1)
imshow(maps.FFrician,[0 1])
title('Fat fraction, Rician MAGO')
colorbar

subplot(1,4,2)
imshow(maps.FFstandard,[0 1])
title('Fat fraction, standard MAGO')
colorbar

subplot(1,4,3)
imshow(maps.FFrician-maps.FFstandard,[-0.1 0.1])
title('Fat fraction Rician - standard')
colorbar

% subplot(1,4,4)
% imshow(fwmc_ff(:,:,slice),[0 100])
% title('Fat fraction, Hernando')
% colorbar

figure
subplot(1,4,1)
imshow(maps.R2rician,[0 0.2])
title('R2*, Rician MAGO')
colorbar

subplot(1,4,2)
imshow(maps.R2standard,[0 0.2])
title('R2*, standard MAGO')
colorbar

subplot(1,4,3)
imshow(maps.R2rician-maps.R2standard,[-0.05 0.05])
title('R2*, Rician - standardMAGO')
colorbar

subplot(1,4,4)
scatter(reshape(maps.R2standard,1,[]),reshape(maps.R2rician,1,[]))
title('R2*, scatterplot Rician against standard')

end


