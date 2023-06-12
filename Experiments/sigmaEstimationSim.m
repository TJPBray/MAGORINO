%% Sigma estimation simulation
% Simulates varying sigma and then estimates sigma by fitting
% An extension of sigma demo

function sigmaCorrection = SigmaEstimationSim(reps,fieldStrength)
%function SigmaEstimationSim(reps)

%Inputs:
%reps specifies number of noise instantiations
%fieldStrength specifies main magnetic field strength in tesla

%Outputs:
%Value of correction factor needed to compensate for sigma overfitting

%% 1. Specify the tissue parameters and acquisition settings

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
    tissue=1;
    
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

%% Loop over inhomogeneity factors

%Set up inhomogeneity factors
inhomogeneityFactor = [0 0 0.05 0.1];

%Set up random seed values 
seed = [2 3 3 3]; %First training set has a different seed

figure 
for inh = 1:4

%% 2. Loop over SNR values 

%Set low and high limits for SNR
snrLow = 20;
snrHigh = 70;
snrRange=snrHigh - snrLow;

for k=1:snrRange

% set the SNR (SNR = S0/sigma)
SNR=snrLow + k; %Start at SNR = 10 (unrealistic below this)

% set the sigma
sigma = S0/SNR;

%Create SNR and sigma vectors for storage
SNRvec(k)=SNR;
sigmaVec(k)=sigma;

% Add sigma to ground truth parameter structure
GT.p(4)=sigma;

%Fix the random seed (NB - needs to come before the noise instantiation
%loop is initiated - otherwise noise will be identical for each instantiation)
rng(seed(inh));


%% 4. Loop over noise instantiations to create virtual ROI for a given SNR

for r=1:reps

% 4.1 Add tissue inhomogeneity (modify S0 pseudorandomly (increment value with each rep) 
ploop(1:2)=p(1:2)*(1+inhomogeneityFactor(inh)*((1-r)/reps)); %p loop used as a temporary value to increment p within the loop

% 4.2 generate the noise-free measured signal with Fatfunction
signalNoiseFreeDense(r,:) = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, ploop(1), ploop(2), p(3), p(4));

signalNoiseFree(r,:) = MultiPeakFatSingleR2(echoTimes, fieldStrength, ploop(1), ploop(2), p(3), p(4));

% add noise-free signal to ground truth structure 
GT.S=signalNoiseFree;

% 4.3 generate the real and imaginary noises
noiseReal = (sigma*randn(numOfMeas, 1))';
noiseImag = (sigma*randn(numOfMeas, 1))';
noise(r,:) = noiseReal + 1i*noiseImag;

end

% 4.4 add noise to the noise-free signals
signalNoisy = signalNoiseFree + noise;
signalMagnNoisy = abs(signalNoisy);

% 4.5 Get estimate of sigma across ROI

% 4.5.1 Find index of echo time closest to first in phase to use for
%roi-based sigma
[~,index] = min(echoTimes - 2.3);

% 4.5.2 Use this to estimate sigma
roiSigma(k) = std(signalMagnNoisy(:,1));


%% 5. Fit the model to the data in ever voxel in the virual ROI

parfor r=1:reps

%5.1 Specify initialisation values and bounds 
algoparams = setAlgoparams(signalMagnNoisy(r,:),sigma,2) %initialise with true sigma; opt=2 specifies inclusion of bounds for sigma in algoParams

%5.2 Run Rician fitting with sigma included as a parameter to estimate the value of sigma
estimatedParas = RicianMagnitudeFitting_WithSigma(echoTimes, fieldStrength, signalMagnNoisy(r,:), algoparams.sigEst, GT,algoparams);

%5.3 Add parameter estimates to vector
F(k,r)=estimatedParas.F;
W(k,r)=estimatedParas.W;
R2(k,r)=estimatedParas.R2;
estimatedSigma(k,r)=estimatedParas.sig;

end
end

%5.5 Create vector of FF estimates
FF=F./(F+W);

%% 6. Determine correction factor for fitted sigma

mdl=fitlm(sigmaVec,mean(estimatedSigma,2));

sigmaCorrection(inh) = 1/mdl.Coefficients{2,1};

%% 7. Add to output structure and plot sigma estimates against SNR


%7.1 

%7.2 Sigma estimates with no inhomogeneity in the voxel

%Only plot 'test' data (don't plot data which sigmaCorrection was estimated
%from)
if inh>1 

subplot(1,3,(inh-1))
plot(sigmaVec,sigmaVec,'LineWidth',2)
hold on
% shadedErrorBar(sigmaVec,mean(estimatedSigma,2),std(estimatedSigma,0,2))
plot(sigmaVec,mean(estimatedSigma,2),'LineWidth',2)
plot(sigmaVec,sigmaCorrection(1)*mean(estimatedSigma,2),'LineWidth',2,'LineStyle','--')
plot(sigmaVec,roiSigma,'LineWidth',2)
xlim([0 1/snrLow])
ylim([0 1/snrLow])
xlabel('True sigma','FontSize',12)
ylabel('Estimated sigma','FontSize',12)
legend('True sigma (Unity)','Fitted Sigma','Corrected fitted sigma','ROI sigma')
hold off
title(strcat('Inhomogeneity factor =   ',num2str(inhomogeneityFactor(inh))))

else %do not plot
    ;
end

end


% figure
% subplot(2,3,1)
% plot(SNRvec,sigmaVec,'LineWidth',2)
% hold on
% shadedErrorBar(SNRvec,mean(estimatedSigma,2),std(estimatedSigma,0,2))
% xlabel('True SNR','FontSize',12)
% ylabel('Sigma','FontSize',12)
% legend('True sigma','Measured sigma')
% hold off
% 

% 
% subplot(2,3,3)
% plot(SNRvec,S0./sigmaVec,'LineWidth',2)
% hold on
% shadedErrorBar(SNRvec,mean(S0./estimatedSigma,2),std(S0./estimatedSigma,0,2))
% xlim([0 100])
% ylim([0 150])
% xlabel('True SNR','FontSize',12)
% ylabel('Estimated SNR','FontSize',12)
% legend('True SNR (Unity)','Estimated SNR')
% hold off
% 
% subplot(2,3,5)
% shadedErrorBar(SNRvec,mean(FF,2),std(FF,0,2)) %Average over noise instantiations
% xlabel('True SNR','FontSize',12)
% ylabel('PDFF estimate','FontSize',12)
% xl=ylim; %Get xlim
% hold on
% plot(xlim,([p(1) p(1)]),'LineWidth',2,'color','blue','Linestyle','--')
% ylim([0 1.1])
% hold off
% 
% subplot(2,3,6)
% shadedErrorBar(SNRvec,mean(R2,2),std(R2,0,2)) %Average over noise instantiations
% xlabel('True SNR','FontSize',12)
% ylabel('R2* estimate','FontSize',12)
% xl=ylim; %Get xlim
% hold on
% plot(xlim,([p(3) p(3)]),'LineWidth',2,'color','blue','Linestyle','--')
% ylim([0 1])
% hold off

end



