


%% 1. Zero mean complex noise

% 1.1 Create synthetic data (random noise with zero mean)
rng(1)
data = randn(10,1) + randn(10,1)*i;
magData = abs(data);
measurements = magData;

%1.2 Define sigma and mu values for likelihood visualisation
sigmaValues = [0.1:0.01:1.1];
muValues = 0:0.01:2;

%1.3 Loop through possibilities
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

%% 2. Monoexponential decay complex noise

% 1.1 Create synthetic data
%Signal model S = exp(-tR2)
trueR2=0.5;

trueSigma = 0.05;

%Noise-free data
t=[0:1:10]';
Snoisefree = exp(-t*trueR2);

%Noise
% rng(1)
noise = trueSigma*(randn(11,1) + randn(11,1)*i);

%Noisy data
Snoisy = Snoisefree + noise;

%Magnitude of noisy data
Smag = abs(Snoisy);
measurements = Smag;

figure
plot(t,Smag)
ylim([0 1])

%1.2 Define sigma and mu values for likelihood visualisation
sigmaValues = [0.001:0.001:0.5];
r2Values = 0.01:0.01:1;

%1.3 Loop through possibilities
for k = 1:numel(sigmaValues)

    sigma = sigmaValues(k);

    for m = 1:numel(r2Values)

        r2 = r2Values(m);

        predictions = exp(-t*r2);

        loglikValues(k,m) = RicianLogLik(measurements, predictions,sigma);
    end

end

% figure, scatter(sigmaValues,loglikValues)

figure, imagesc(loglikValues)
axis xy
colorbar
caxis([(max(loglikValues,[],'all')-abs(max(loglikValues,[],'all'))) max(loglikValues,[],'all')])
% caxis([1.01*max(loglikValues,[],'all') max(loglikValues,[],'all')])
xlabel('R2')
ylabel('Sigma')
xticklabels(r2Values(xticks))
yticklabels(sigmaValues(yticks))

hold on

% Find coordinates of global optimum by grid search and add this to plot 
[max1,ind1] = max(loglikValues,[],'all','linear');
[X,Y]=ind2sub(size(loglikValues),ind1);
plot(Y,X,'kd','MarkerFaceColor','black','MarkerSize',8,'LineWidth',2)

%Add reference lines for ground truth
indexOfTrueSigma = find(sigmaValues==trueSigma);
indexOfTrueR2 = find(r2Values==trueR2);

plot([0 size(loglikValues,2)],[indexOfTrueSigma indexOfTrueSigma],'LineWidth',2,'color','red','Linestyle','-') %..add ground truth as line
plot([indexOfTrueR2 indexOfTrueR2],[0 size(loglikValues,1)],'LineWidth',2,'color','red','Linestyle','-') %..add ground truth as line


hold off




% %Calculate SSE
% sse = data'*data;
% 
% %Gaussian
% sseGaussian = (measurements - mean(measurements)).^2;
% sseGaussian = sum(sseGaussian);
% sigmaGaussian = sqrt(sseGaussian/10);
% 
% meanGaussian = mean(measurements);
% 
% %Rician free
% [maxLik,I] = max(loglikValues,[],'all');
% [ind1, ind2] = ind2sub(size(loglikValues),I);
% 
% sigmaRicianFree = sigmaValues(ind1);
% meanRicianFree = r2Values(ind2);
% % 
% % sseRicianFreeParams = (measurements - maxMu).^2;
% % sseRicianFreeParams = sum(sseRicianFreeParams);
% % sigmaRicianFreeParams = sqrt(sseRicianFreeParams/10);
% 
% %Rician fixed
% sseRician = (measurements - 0.39).^2;
% sseRician = sum(sseRician);

