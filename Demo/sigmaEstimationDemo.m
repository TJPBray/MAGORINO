%% Sigma estimation demo demo
% Simulates varying sigma and then estimates sigma by fitting

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
SNR = 50;

% set the sigma
sigma = S0/SNR;

% Add sigma to ground truth parameter structure
GT.p(4)=sigma;

%Fix the random seed
rng(2);

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

% 2.6 visualise the noisy signals
plot(h1, echoTimes, real(signalNoisy), 'r*');
hold on;
plot(h1, echoTimes, imag(signalNoisy), 'b*');
xlabel(h1, 'echo time (ms)');
ylabel(h1, 'noisy signal');
legend(h1, 'noise-free real', 'noise-free imag', 'noisy real', 'noisy imag');
plot(h3, echoTimes, signalMagnNoisy, 'r*');
legend(h3, 'noise-free magnitude', 'noisy magnitude');



%% Visualise likelihood for each parameter

%% 3. Fit the model to the data

%3.1 Give rough idea of SNR
SNRest=40;

%3.2 Specify initialisation values and bounds 
algoparams = setAlgoparams(signalMagnNoisy,SNRest,2) %opt=2 specifies inclusion of bounds for sigma in algoParams

%3.3 Run Rician fitting with sigma included as a parameter to estimate the value of sigma
estimatedParas = RicianMagnitudeFitting_WithSigma(echoTimes, fieldStrength, signalMagnNoisy, algoparams.sigEst, GT,algoparams)

%% Visualise predicted signal relative to ground truth and noisy measured signal 
figure
subplot(2,2,1)

hold on

%Noise-free signal
plot(denseEchoTimes, abs(signalNoiseFreeDense), 'k-','Linewidth',2);

%Noisy sampled signal
plot(echoTimes, abs(signalNoisy), 'k.','MarkerSize',20,'Linewidth',4);

%Rician fitted signal
ricianPredictedSignal = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, estimatedParas.F, estimatedParas.W, estimatedParas.R2, 0);
plot(denseEchoTimes, abs(ricianPredictedSignal), 'b--','Linewidth',2)

hold off 

legend('Noise-free signal','Noisy sampled signal', 'Rician fit with sigma')