%% FW-MRI forward model demo

%% 1. Generate the noise-free forward model

% 1.1 set the tissue parameters
% [Sf(au),  Sw(au), R2*(kHz), fB(kHz)]

%Define S0
    S0=100;

    %1. Zero FF, low R2*
    params(1,:) =    [0, S0, 0, 0];
    %2. Low FF, low R2*
    params(2,:  )=   [0.2*S0, 0.8*S0, 0, 0];
    %3. Middle FF, low R2*
    params(3,:)  =   [0.4*S0, 0.4*S0, 0, 0];
    %4. High FF, low R2*
    params(4,:)  =   [0.8*S0, 0.2*S0, 0, 0];
    %5. Zero FF, high R2*
    params(5,:)  =   [0*S0, 1*S0, 0.5, 0];
    %6. Low FF, high R2*
    params(6,:)  =   [0.2*S0, 0.8*S0, 0.5, 0];
    %7. Middle FF, high R2*
    params(7,:)  =   [0.5*S0, 0.5*S0, 0.5, 0];
    %8. High FF, high R2*
    params(8,:)   =  [0.9*S0, 0.1*S0, 0.5, 0];

    %Pick tissue type
    tissue=4;
    
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

% 2.1 fix the random seed

% 2.2 set the standard deviation of the Gaussian noise

% set the SNR (SNR = S0/sigma)
SNR = 40;

% set the sigma
sigma = S0/SNR;

%Fix the random seed
rng(2);

% 2.3 generate the real and imaginary noises
noiseReal = sigma*randn(numOfMeas, 1);
noiseImag = sigma*randn(numOfMeas, 1);
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

% 2.6 visualise the noisy signals
plot(h1, echoTimes, real(signalNoisy), 'r*');
hold on;
plot(h1, echoTimes, imag(signalNoisy), 'b*');
xlabel(h1, 'echo time (ms)');
ylabel(h1, 'noisy signal');
legend(h1, 'noise-free real', 'noise-free imag', 'noisy real', 'noisy imag');
plot(h3, echoTimes, signalMagnNoisy, 'r*');
legend(h3, 'noise-free magnitude', 'noisy magnitude');

% 2.7 rotate the complex noise by the phase angle of the corresponding
% measurements - to check Rician assumption
noiseRotated = noise.*exp(-1i*signalPhaseNoiseFree);
h4 = subplot(2, 2, 4);
histogram(real(noiseRotated));
hold on;
histogram(imag(noiseRotated));
xlabel('noise (rotated)');
ylabel('count');
legend('real', 'imag');



%% Visualise likelihood for each parameter


%% 3. Fit the model to the data

estimatedParas = R2fitting(echoTimes, fieldStrength, signalNoisy, sigma, GT);

%% Visualise predicted signal relative to ground truth and noisy measured signal 
figure
subplot(2,2,1)

hold on

%Noise-free signal
plot(denseEchoTimes, abs(signalNoiseFreeDense), 'k-','Linewidth',2);

%Noisy sampled signal
plot(echoTimes, abs(signalNoisy), 'k.','MarkerSize',20,'Linewidth',4);

%Gaussian fitted signal
gaussianPredictedSignal = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, estimatedParas.standard.F, estimatedParas.standard.W, estimatedParas.standard.R2, 0);
plot(denseEchoTimes, abs(gaussianPredictedSignal), 'r--','Linewidth',2)

%Rician fitted signal
ricianPredictedSignal = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, estimatedParas.Rician.F, estimatedParas.Rician.W, estimatedParas.Rician.R2, 0);
plot(denseEchoTimes, abs(ricianPredictedSignal), 'b--','Linewidth',2)

%Complex fitted signal
complexPredictedSignal = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, estimatedParas.complex.F, estimatedParas.complex.W, estimatedParas.complex.R2, 0);
plot(denseEchoTimes, abs(complexPredictedSignal), 'g--','Linewidth',2)

hold off 

legend('Noise-free signal','Noisy sampled signal', 'Gaussian fit','Rician fit', 'Complex fit')