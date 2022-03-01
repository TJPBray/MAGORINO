%% Sigma estimation simulation
% Simulates varying sigma and then estimates sigma by fitting
% An extension of sigma demo

function SigmaEstimationSim(reps)
%function SigmaEstimationSim(reps)

%% 1. Generate the noise-free forward model

% 1.1 set the tissue parameters
% [Sf(au),  Sw(au), R2*(kHz), fB(kHz)]

%Define S0
    S0=1;

    %1. Pure water, 0 R2*
    params(1,:) =    [0, S0, 0, 0];
    %2. Low FF, 0 R2*
    params(2,:  )=   [0.2*S0, 0.8*S0, 0.05, 0];
    %3. Middle FF, low R2*
    params(3,:)  =   [0.4*S0, 0.4*S0, 0.1, 0];
    %4. Pure fat, low R2*
    params(4,:)  =   [1*S0, 0*S0, 0.1, 0];
    %5. Zero FF, high R2*
    params(5,:)  =   [0*S0, 1*S0, 0.5, 0];
    %6. Low FF, high R2*
    params(6,:)  =   [0.2*S0, 0.8*S0, 0.5, 0];
    %7. Middle FF, high R2*
    params(7,:)  =   [0.5*S0, 0.5*S0, 0.5, 0];
    %8. Pure fat, high R2*
    params(8,:)   =  [0.9*S0, 0.1*S0, 0.5, 0];

    %Pick tissue type
    tissue=2;
    
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

% 2.3 Loop over SNR values
for k=1:100

% set the SNR (SNR = S0/sigma)
SNR=k; %Start at SNR = 10 (unrealistic below this)

% set the sigma
sigma = S0/SNR;

%Create SNR and sigma vectors for storage
SNRvec(k)=SNR;
sigmaVec(k)=sigma;

% Add sigma to ground truth parameter structure
GT.p(4)=sigma;

%Fix the random seed (NB - needs to come before the noise instantiation
%loop is initiated - otherwise noise will be identical for each instantiation)
rng(3);

%2.4 Loop over noise instantiations
parfor r=1:reps

% 2.5 generate the real and imaginary noises
noiseReal = (sigma*randn(numOfMeas, 1))';
noiseImag = (sigma*randn(numOfMeas, 1))';
noise = noiseReal + 1i*noiseImag;

% 2.6 add noise to the noise-free signals
signalNoisy = signalNoiseFree + noise;
signalMagnNoisy = abs(signalNoisy);

%% 3. Fit the model to the data

%3.1 Give rough idea of SNR
SNRest=60;

%3.2 Specify initialisation values and bounds 
algoparams = setAlgoparams(signalMagnNoisy,SNRest,2) %opt=2 specifies inclusion of bounds for sigma in algoParams

%3.3 Run Rician fitting with sigma included as a parameter to estimate the value of sigma
estimatedParas = RicianMagnitudeFitting_WithSigma(echoTimes, fieldStrength, signalMagnNoisy, algoparams.sigEst, GT,algoparams)

%3.4 Add parameter estimates to vector
F(k,r)=estimatedParas.F;
W(k,r)=estimatedParas.W;
R2(k,r)=estimatedParas.R2;
estimatedSigma(k,r)=estimatedParas.sig;

end
end

%3.5 Create vector of FF estimates
FF=F./(F+W);

%% 4. Plot sigma estimates against SNR

figure
subplot(2,3,1)
plot(SNRvec,sigmaVec,'LineWidth',2)
hold on
shadedErrorBar(SNRvec,mean(estimatedSigma,2),std(estimatedSigma,0,2))
xlabel('True SNR','FontSize',12)
ylabel('Sigma','FontSize',12)
legend('True sigma','Measured sigma')
hold off

subplot(2,3,2)
plot(sigmaVec,sigmaVec,'LineWidth',2)
hold on
shadedErrorBar(sigmaVec,mean(estimatedSigma,2),std(estimatedSigma,0,2))
xlim([0 0.1])
ylim([0 0.1])
xlabel('True sigma','FontSize',12)
ylabel('Estimated sigma','FontSize',12)
legend('True sigma (Unity)','Estimated sigma')
hold off

subplot(2,3,3)
plot(SNRvec,S0./sigmaVec,'LineWidth',2)
hold on
shadedErrorBar(SNRvec,mean(S0./estimatedSigma,2),std(S0./estimatedSigma,0,2))
xlim([0 100])
ylim([0 150])
xlabel('True SNR','FontSize',12)
ylabel('Estimated SNR','FontSize',12)
legend('True SNR (Unity)','Estimated SNR')
hold off

subplot(2,3,5)
shadedErrorBar(SNRvec,mean(FF,2),std(FF,0,2)) %Average over noise instantiations
xlabel('True SNR','FontSize',12)
ylabel('PDFF estimate','FontSize',12)
xl=ylim; %Get xlim
hold on
plot(xlim,([p(1) p(1)]),'LineWidth',2,'color','blue','Linestyle','--')
ylim([0 1.1])
hold off

subplot(2,3,6)
shadedErrorBar(SNRvec,mean(R2,2),std(R2,0,2)) %Average over noise instantiations
xlabel('True SNR','FontSize',12)
ylabel('R2* estimate','FontSize',12)
xl=ylim; %Get xlim
hold on
plot(xlim,([p(3) p(3)]),'LineWidth',2,'color','blue','Linestyle','--')
ylim([0 1])
hold off

end



