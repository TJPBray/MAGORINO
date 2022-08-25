%% FW-MRI forward model demo

%% 1. Generate the noise-free forward model

% 1.1 set the tissue parameters
% [Sf(au),  Sw(au), R2*(kHz), fB(kHz)]

%Define S0
    S0=100;

    %1. Pure water, low R2*
    params(1,:) =    [0, S0, 0, 0];
    %2. Low FF, low R2*
    params(2,:  )=   [0.2*S0, 0.8*S0, 0, 0];
    %3. Middle FF, low R2*
    params(3,:)  =   [0.4*S0, 0.4*S0, 0, 0];
    %4. Pure fat, 0 R2*
    params(4,:)  =   [1*S0, 0*S0, 0, 0];
    %5. Zero FF, high R2*
    params(5,:)  =   [0*S0, 1*S0, 0.5, 0];
    %6. Low FF, high R2*
    params(6,:)  =   [0.2*S0, 0.8*S0, 0.5, 0];
    %7. Middle FF, high R2*
    params(7,:)  =   [0.5*S0, 0.5*S0, 0.5, 0];
    %8. Pure fat, high R2*
    params(8,:)   =  [0.9*S0, 0.1*S0, 0.5, 0];
    %9. Pure noise (background voxel mimic)
    params(9,:)   =  [0, 0, 0, 0];

    %Pick tissue type
    tissue=9;
    
    %Define parameter vector
    p=params(tissue,:)';
    
    %Add ground truth parameters to GT structure to provide to fitting
    GT.p=p;
    

% 1.2 set the acquisition parameters

% scanner field strength (Tesla)
fieldStrength = 3;

% echo times (ms) - densely sampled here for visualisation purposes
denseEchoTimes = (0:0.1:11)';

%Sampling scheme
sampling=[12:11:111];

% Sampled echo times
echoTimes = denseEchoTimes(sampling);

% number of measurements
numOfMeas = length(echoTimes);

% 1.3 generate the noise-free measured signal with Fatfunction
signalNoiseFreeDense = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, p(1), p(2), p(3), p(4));

signalNoiseFree = MultiPeakFatSingleR2(echoTimes, fieldStrength, p(1), p(2), p(3), p(4));

% add noise-free signal to ground truth structure 
GT.S=signalNoiseFree;

% 1.4 visualise the signal
figure;
h1 = subplot(2, 2, 1);
hold on;
plot(denseEchoTimes, real(signalNoiseFreeDense), 'r-');
plot(denseEchoTimes, imag(signalNoiseFreeDense), 'b-');
xlabel('echo time (ms)');
ylabel('signal');
legend('noise-free real', 'noise-free imag');

% 1.5 convert to magnitude and phase
signalMagnNoiseFree = abs(signalNoiseFreeDense);
h3 = subplot(2, 2, 3);
hold on;
plot(denseEchoTimes, signalMagnNoiseFree, 'r-');
xlabel('echo time (ms)');
ylabel('signal');
legend('noise-free magnitude');

signalPhaseNoiseFree = angle(signalNoiseFree);

%% 2. Simulate noisy measured signal from noise free data

rng(2);

for k = 1:100

% 2.1 fix the random seed

% 2.2 set the standard deviation of the Gaussian noise

% set the SNR (SNR = S0/sigma)
SNR = 40;

% set the sigma
sigma = S0/SNR;

%Fix the random seed


% 2.3 generate the real and imaginary noises
noiseReal = (sigma*randn(numOfMeas, 1))';
noiseImag = (sigma*randn(numOfMeas, 1))';
noise = noiseReal + 1i*noiseImag;

% 2.4 visualise the noises
h2 = subplot(2, 2, 2);
histogram(noiseReal, 10);
hold on;
histogram(noiseImag, 10);
xlabel('noise');
ylabel('count');
legend('real', 'imag');

% 2.5 add noise to the noise-free signals
signalNoisy = signalNoiseFree + noise;
signalMagnNoisy = abs(signalNoisy);

% % 2.6 visualise the noisy signals
% plot(h1, echoTimes, real(signalNoisy), 'r*');
% hold on;
% plot(h1, echoTimes, imag(signalNoisy), 'b*');
% xlabel(h1, 'echo time (ms)');
% ylabel(h1, 'noisy signal');
% legend(h1, 'noise-free real', 'noise-free imag', 'noisy real', 'noisy imag');
% plot(h3, echoTimes, signalMagnNoisy, 'r*');
% legend(h3, 'noise-free magnitude', 'noisy magnitude');
% 
% % 2.7 rotate the complex noise by the phase angle of the corresponding
% % measurements - to check Rician assumption
% noiseRotated = noise.*exp(-1i*signalPhaseNoiseFree);
% h4 = subplot(2, 2, 4);
% histogram(real(noiseRotated));
% hold on;
% histogram(imag(noiseRotated));
% xlabel('noise (rotated)');
% ylabel('count');
% legend('real', 'imag');



%% Visualise likelihood for each parameter


%% 3. Fit the model to the data

estimatedParas = FittingWrapper(echoTimes, fieldStrength, signalNoisy, sigma, GT)

S0standard(k) = estimatedParas.standard.F + estimatedParas.standard.W;
S0rician(k) = estimatedParas.Rician.F + estimatedParas.Rician.W;

R2standard(k) = estimatedParas.standard.R2;
R2rician(k) = estimatedParas.Rician.R2;

FFstandard(k) = estimatedParas.standard.F / (estimatedParas.standard.F+ estimatedParas.standard.W);
FFrician(k) = estimatedParas.Rician.F / (estimatedParas.Rician.F+ estimatedParas.Rician.W);

%% 4. Generate likelihood plot


S0 = 1;

% Create grid of parameter combinations
FFgrid=repelem([0:0.01:1]',1,101);

Fgrid=S0*FFgrid;

Wgrid=S0-Fgrid;

vgrid=repelem(0:0.01:1,101,1); %1ms-1 upper limit chosen to reflect Hernando et al. (went up to 1.2)


%Loop through combinations

for y=1:size(Fgrid,1)
    for x=1:size(Fgrid,2)
        
        %pval refers to value of parameter vector for specified point on the grid
        pval(1)=Fgrid(y,x); 
        pval(2)=Wgrid(y,x);
        pval(3)=vgrid(y,x);
        pval(4)=0;
        
        loglikMag(y,x)= R2Obj(pval,echoTimes,3,signalMagnNoisy,sigma);
        loglikRic(y,x) = R2RicianObj(pval,echoTimes,3,signalMagnNoisy,sigma);
        
    end
end

figure
subplot(1,3,1)
imshow(loglikMag,[-1.1*abs(max(loglikMag,[],'all')) max(loglikMag,[],'all')])
axis on
xticks([1 21 41 61 81 101]);
xticklabels({'0','200', '400', '600', '800', '1000'});
xlabel('R2* (s^-^1)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
ylabel('PDFF','FontSize',12)
title(strcat('Gaussian: True PDFF =  ',num2str(GT.p(1)),' & R2^* =  ', num2str(1000*GT.p(3))))
colorbar
hold on
colormap('parula')

subplot(1,3,2)
imshow(loglikRic,[-1.1*abs(max(loglikRic,[],'all')) max(loglikRic,[],'all')])
axis on
xticks([1 21 41 61 81 101]);
xticklabels({'0','200', '400', '600', '800', '1000'});
xlabel('R2* (s^-^1)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
ylabel('PDFF','FontSize',12)
title(strcat('Gaussian: True PDFF =  ',num2str(GT.p(1)),' & R2^* =  ', num2str(1000*GT.p(3))))
colorbar
hold on
colormap('parula')


end



%% Visualise distribution 
figure
subplot(1,3,1)
scatter(S0standard,S0rician)
ylabel('S0rician')
xlabel('S0standard')

subplot(1,3,2)
scatter(FFstandard,FFrician)
ylabel('FF rician')
xlabel('FF standard')
xlim([0 1])
ylim([0 1])

subplot(1,3,3)
scatter(1000*R2standard,1000*R2rician)
ylabel('R2* rician')
xlabel('R2* standard')
xlim([0 1000])
ylim([0 1000])

%Visualise relationship between S0 rician, FF rician and R2* rician
figure, scatter3(S0rician, FFrician, R2rician)
xlabel('S0')
ylabel('FF')
zlabel('R2*')

%% Visualise predicted signal relative to ground truth and noisy measured signal 
% figure
% subplot(2,2,1)
% 
% hold on
% 
% %Noise-free signal
% plot(denseEchoTimes, abs(signalNoiseFreeDense), 'k-','Linewidth',2);
% 
% %Noisy sampled signal
% plot(echoTimes, abs(signalNoisy), 'k.','MarkerSize',20,'Linewidth',4);
% 
% %Gaussian fitted signal
% gaussianPredictedSignal = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, estimatedParas.standard.F, estimatedParas.standard.W, estimatedParas.standard.R2, 0);
% plot(denseEchoTimes, abs(gaussianPredictedSignal), 'r--','Linewidth',2)
% 
% %Rician fitted signal
% ricianPredictedSignal = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, estimatedParas.Rician.F, estimatedParas.Rician.W, estimatedParas.Rician.R2, 0);
% plot(denseEchoTimes, abs(ricianPredictedSignal), 'b--','Linewidth',2)
% 
% %Complex fitted signal
% complexPredictedSignal = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, estimatedParas.complex.F, estimatedParas.complex.W, estimatedParas.complex.R2, 0);
% plot(denseEchoTimes, abs(complexPredictedSignal), 'g--','Linewidth',2)
% 
% hold off 
% 
% legend('Noise-free signal','Noisy sampled signal', 'Gaussian fit','Rician fit', 'Complex fit')