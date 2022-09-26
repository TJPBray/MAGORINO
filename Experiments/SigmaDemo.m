%% Create synthetic data (random noise with zero mean)
rng(1)
data = randn(10,1) + randn(10,1)*i;
magData = abs(data);
measurements = magData;

%Define sigma and mu values
sigmaValues = [0.1:0.01:1.1];
muValues = 0:0.01:2;

%Loop through possibilities
for k = 1:numel(sigmaValues)

    sigma = sigmaValues(k);

    for m = 1:numel(muValues)

        mu = muValues(m);

        predictions = zeros(size(measurements)) + mu;

        loglikValues(k,m) = RicianLogLik(measurements, predictions,sigma);

    end

end

% figure, scatter(sigmaValues,loglikValues)

figure, imagesc(loglikValues)
axis xy
colorbar
caxis([-8 -6])
% caxis([1.01*max(loglikValues,[],'all') max(loglikValues,[],'all')])
xlabel('Mu')
ylabel('Sigma')
xticklabels(muValues(xticks))
yticklabels(sigmaValues(yticks))

max(loglikValues,[],'all')

%Calculate SSE
sse = data'*data;

%Gaussian
sseGaussian = (measurements - mean(measurements)).^2;
sseGaussian = sum(sseGaussian);
sigmaGaussian = sqrt(sseGaussian/10);

meanGaussian = mean(measurements);

%Rician free
[maxLik,I] = max(loglikValues,[],'all');
[ind1, ind2] = ind2sub(size(loglikValues),I);

sigmaRicianFree = sigmaValues(ind1);
meanRicianFree = muValues(ind2);
% 
% sseRicianFreeParams = (measurements - maxMu).^2;
% sseRicianFreeParams = sum(sseRicianFreeParams);
% sigmaRicianFreeParams = sqrt(sseRicianFreeParams/10);

%Rician fixed
sseRician = (measurements - 0.39).^2;
sseRician = sum(sseRician);

