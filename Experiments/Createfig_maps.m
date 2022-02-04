function Createfig_maps(maps,referenceFF,referenceR2)
% Createfig(FFmaps,errormaps,sdmaps,residuals)

% Input: maps

% This function takes the outputs from image_fitting and generates figures
% showing and comparing maps

% Author:
% Tim Bray, t.bray@ucl.ac.uk

%% FF plot
figure
subplot(2,3,1)
imshow(maps.FFrician,[0 1])
title('Fat fraction, MAGORINO')
colorbar

subplot(2,3,2)
imshow(maps.FFstandard,[0 1])
title('Fat fraction, Gaussian fitting (MAGO)')
colorbar

subplot(2,3,3)
imshow(referenceFF,[0 100])
title('Fat fraction, complex (vendor)')
colorbar



%% R2* plot
figure
subplot(2,4,1)
imshow(maps.R2rician,[0 0.3])
title('R2*, Rician MAGO')
colorbar

subplot(2,4,2)
imshow(maps.R2standard,[0 0.3])
title('R2*, standard MAGO')
colorbar

subplot(2,4,3)
imshow(maps.R2complex,[0 0.3])
title('R2*, complex MAGO')
colorbar

subplot(2,4,4)
imshow(referenceR2,[0 0.3])
title('R2*, vendor complex')
colorbar

subplot(2,4,5)
imshow(maps.R2rician-maps.R2standard,[-0.05 0.05])
title('R2*, rician - standardMAGO')
colorbar

subplot(2,4,6)
imshow(maps.R2rician-maps.R2complex,[-0.05 0.05])
title('R2*, rician - complex')
colorbar

subplot(2,4,7)
imshow(maps.R2standard-maps.R2complex,[-0.05 0.05])
title('R2*, standard - complex')
colorbar

% subplot(1,4,4)
% scatter(reshape(maps.R2standard,1,[]),reshape(maps.R2rician,1,[]))
% title('R2*, scatterplot Rician against standard')

end


