


imslice = abs(imDataParams.images(:,:,20,1,:));
sliceSum = sum(imslice,5);

imax = max(sliceSum,[],'all')

lastslice=imslice(:,:,1,1,6);
fracture = sliceSum - lastslice;

figure, subplot(2,3,1), imshow(sliceSum,[0 imax]) 
title('Sum over echoes')
subplot(2,3,2), imshow(lastslice,[0 imax]) 
title('Last echo')
subplot(2,3,3), imshow(fracture,[])
title('Sum - last echo')
subplot(2,3,4), imshow(-fracture,[])
title('Last echo - sum')
colorbar
subplot(2,3,5), imshow(-sliceSum,[])
title('Negated slice sum')
colorbar
subplot(2,3,6), imshow(-fracture+sliceSum,[])
title('Difference between fracture and negated slice sum')
colorbar