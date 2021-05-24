%
figure
subplot(1,4,1)
imshow(images.FFrician,[0 1])
title('Fat fraction, Rician MAGO')
colorbar

subplot(1,4,2)
imshow(images.FFstandard,[0 1])
title('Fat fraction, standard MAGO')
colorbar

subplot(1,4,3)
imshow(images.FFrician-images.FFstandard,[0 0.1])
title('Fat fraction difference')
colorbar

subplot(1,4,4)
imshow(FF(:,:,20),[0 100])
title('Fat fraction, Hernando')
colorbar

scatter(reshape(images.FFrician,1,[]),reshape(images.FFstandard,1,[]))

scatter(reshape(FF(:,:,20),1,[]),reshape(images.FFrician,1,[]))

figure, scatter(reshape(FF(:,:,20),1,[]),reshape(images.FFstandard,1,[]))

scatter(reshape(images.R2rician,1,[]),reshape(images.R2standard,1,[]))

scatter(reshape(R2star(:,:,20),1,[]),reshape(images.R2rician,1,[]))

figure, scatter(reshape(R2star(:,:,20),1,[]),reshape(images.R2standard,1,[]))