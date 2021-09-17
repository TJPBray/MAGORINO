%% FW-MRI forward model demo

%% 1. Generate the noise-free forward model

% 1.1 set the tissue parameters

% R2* (kHz or ms^-1)
R2star = 0.1;

% field strength offset (kHz)
fieldStrengthOffset = 0.0;

% S0 (arbitrary unit) - corresponding to the theoretical signal at TE = 0
S0 = 1;

% fat fraction
fatFraction = 0.6;

% convert S0 and fat fraction to fat and water signals

% fat signal (arbitrary unit)
Sfat = S0*fatFraction;

% water signal (arbitrary unit)
Swater = S0*(1 - fatFraction);

% 1.2 set the acquisition parameters

% scanner field strength (Tesla)
fieldStrength = 3;

% echo times (ms) - densely sampled here for visualisation purposes
echoTimes = 0:0.1:10;

% number of measurements
numOfMeas = length(echoTimes);

% 1.3 generate the signal with Fatfunction
signalNoiseFree = Fatfunction(echoTimes, fieldStrength, Sfat, Swater, R2star, fieldStrengthOffset);

% 1.4 visualise the signal
figure;
h1 = subplot(2, 2, 1);
hold on;
plot(echoTimes, real(signalNoiseFree), 'r-.');
plot(echoTimes, imag(signalNoiseFree), 'b-.');
xlabel('echo time (ms)');
ylabel('noise-free signal');
legend('real', 'imag');

%% 2. Simulate noisy measured signal from noise free data

% 2.1 fix the random seed
rng(1);

% 2.2 set the standard deviation of the Gaussian noise

% set the SNR (SNR = S0/sigma)
SNR = 10;

% set the sigma
sigma = S0/SNR;

% 2.3 generate the real and imaginary noises
noiseReal = sigma*randn(1, numOfMeas);
noiseImag = sigma*randn(1, numOfMeas);

% 2.4 visualise the noises
h2 = subplot(2, 2, 2);
histogram(noiseReal, 10);
hold on;
histogram(noiseImag, 10);
xlabel('noise');
ylabel('count');
legend('real', 'imag');

% 2.5 add noise to the noise-free signals
signalNoisy = signalNoiseFree + noiseReal + 1i*noiseImag;

% 2.6 visualise the noisy signals
plot(h1, echoTimes, real(signalNoisy), 'r*');
hold on;
plot(h1, echoTimes, imag(signalNoisy), 'b*');
xlabel(h1, 'echo time (ms)');
ylabel(h1, 'noisy signal');
legend(h1, 'real', 'imag');

%% 3. Fit the model to the data

estimatedParas = R2fitting(echoTimes, fieldStrength, signalNoisy, sigma);
