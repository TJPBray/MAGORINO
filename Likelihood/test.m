


%% Gaussian


sigma = 1;

mu = 0;

x = -10:0.1:10

gaussF = (1/(sigma*sqrt(2*pi)))*exp(-0.5*((x-mu).^2/(sigma^2)));

sumPdf = sum(gaussF)*0.1

figure
subplot(1,2,1)
title('PDF')
scatter(x,gaussF)
xlabel('x')

x = 1;
mu = -10:0.1:10;

gaussF = (1/(sigma*sqrt(2*pi)))*exp(-0.5*((x-mu).^2/(sigma^2)));

subplot(1,2,2)
title('Likelihood F')
scatter(mu,gaussF)
xlabel('Mu')

sumLik= sum(gaussF)*0.1

x = 1;
mu = -10:0.1:10;

gaussF = (1/(sigma*sqrt(2*pi)))*exp(-0.5*((x-mu).^2/(sigma^2)));

subplot(1,2,2)
title('Likelihood F')
scatter(mu,gaussF)
xlabel('Mu')

sumLik= sum(gaussF)*0.1

