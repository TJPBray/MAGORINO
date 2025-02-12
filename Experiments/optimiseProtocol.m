
function [FFmaps,errormaps,sdmaps,residuals,meanError] = optimiseProtocol(SNR, reps)
% function [FFmaps,errormaps,sdmaps,residuals,meanerror]] = Simulate_Values(SNR)

% Description:
% Performs simulation over a range of FF and R2* values for different
% protocols, in order to compare protocol performance

% Input: 
% SNR is the true SNR; sigma is calculated from this assuming ground truth
% S0 value
% Protocol is a structure containing echo spacing and echo time 

% reps is number of simulation instantiations

% Output: 
% Parameters, parameter error, standard deviation and residuals over a range of FF and R2* values
% meanError is Mean parameter error marginalised over FF and R2* values

% Author:
% Tim Bray, t.bray@ucl.ac.uk

%% Set environment to enforce correct behaviour of parpool
setenv('MW_PCT_TRANSPORT_HEARTBEAT_INTERVAL', '600')

%% 1. Specify protocols to optimise over

%Define field strength
tesla=3;

% Specify a range of TE1 and dTE to optimise over
firstTeValues = [0.65:0.1:1.55];
deltaTeValues = [0.65:0.1:1.55];

%Specify number of TE
numEchoes = 6;

%Define fB for simulation
fB=0;

% estimatedNoiseSD= noiseSD + noiseSD*sigmaError;

%Loop through SNR values, finding noise SD for each

%Turn figure show setting on/off
figshow=0;

%% 2. Specify parameters to optimise over

%Specify S0
S0=100;

% Define noise parameters (NB MAGO paper reports typical SNR in vivo of 40
% at 1.5T and 60 at 3T. However, may be lower in the presence of iron or
% marrow. The SNR is a function input. 
noiseSD=S0/SNR;

%Specify FFmax, R2max and intervals

FFmax = 1;
FFinterval = 0.1;
FFvals = [0:FFinterval:FFmax];

R2max = 0.5;
R2interval=0.1;
R2vals=[0:R2interval:R2max];

%Create grids of ground truth values
FFgrid=repelem(FFvals',1,numel(R2vals));

Fgrid=S0*FFgrid;

Wgrid=S0-Fgrid;

vgrid=repelem(R2vals,numel(FFvals),1);%1ms-1 upper limit chosen to reflect Hernando et al. (went up to 1.2)

%% 3. Loop over different protocols

%Add waitbar
w1 = waitbar(0,'Progress in first TE values');
w2 = waitbar(0,'Progress in delta TE values');

%Prefill arrays
meanError.FFRician = zeros(numel(firstTeValues), numel(deltaTeValues));
meanError.R2Rician = zeros(numel(firstTeValues), numel(deltaTeValues));

%Choose particular protocol
for f = 1:numel(firstTeValues)
    for d = 1:numel(deltaTeValues)

        % Specify echotimes
        % MAGO paper at 3T used 12 echoes (TE1 1.1, dTE 1.1)
        % MAGO paper at 1.5T used 6 echoes (TE1 1.2, dTE 2)
        echotimes=[firstTeValues(f):deltaTeValues(d):firstTeValues(f)+(numEchoes-1)*deltaTeValues(d)]';

%% Specify sigma correction factor
%Assume perfect estimation for now 

sigmaEst = noiseSD;

%% Generate noise (done before looping over voxels)

%Fix the random seed
rng(2);

% Generate the real and imaginary noises
noiseReal_grid = noiseSD*randn(size(Fgrid,1),size(Fgrid,2),numel(echotimes),reps);
noiseImag_grid = noiseSD*randn(size(Fgrid,1),size(Fgrid,2),numel(echotimes),reps);
noise_grid = noiseReal_grid + 1i*noiseImag_grid;

% 
% %Generate simulate 'ROI' for first echo time to get noise estimate for
% %Rician fitting, % with 50 voxels
% NoiseROI= normrnd(0,noiseSD,[200 1]) + i*normrnd(0,noiseSD,[200 1]);
% sigma=std(real(NoiseROI));



%% Loop through values



for x=1:size(Fgrid,2)
for y=1:size(Fgrid,1)

        
        W=Wgrid(y,x);
        F=Fgrid(y,x);
        v=vgrid(y,x);

%Simulate noise-free signal
Snoisefree=MultiPeakFatSingleR2(echotimes,3,F,W,v,fB);

% Specify ground truth signal
GT.S = Snoisefree;

%Specify ground truth parameter values
GT.p = [F W v 0];

%%Loop through reps
parfor r=1:reps

%Get noise from grid
noise=noise_grid(y,x,:,r);

%Reshape
noise=reshape(noise,1,[]);

%Add noise
Snoisy=Snoisefree+noise;

%% Implement fitting with noiseless data

% outparams_noiseless = R2fitting(echotimes,3, Smeasured, noiseSD); %Need to take magnitude here; NB fitting will still work without!

%% Implement fitting with noisy data
% This will implement both standard magnitude fitting and with Rician noise
% modelling

outparams = FittingWrapper(echotimes,3,Snoisy,sigmaEst,GT);


%% Add parameter estimates to grid

%For FF
FF_Rician(y,x,r)=outparams.Rician.F/(outparams.Rician.W+outparams.Rician.F);

%For R2*
vhat_Rician(y,x,r)=outparams.Rician.R2;

%For S0
S0_Rician(y,x,r)=outparams.Rician.F+outparams.Rician.W;

% %For ground-truth initialised values
% 
% %For FF
% FF_standard_gtinitialised(y,x,r)=outparams.standard.pmin3(1)/(outparams.standard.pmin3(2)+outparams.standard.pmin3(1));
% FF_Rician_gtinitialised(y,x,r)=outparams.Rician.pmin3(1)/(outparams.Rician.pmin3(2)+outparams.Rician.pmin3(1));
% FF_complex_gtinitialised(y,x,r)=outparams.complex.pmin3(1)/(outparams.complex.pmin3(2)+outparams.complex.pmin3(1));
% FF_complexFixed_gtinitialised(y,x,r)=outparams.complexFixed.pmin3(1)/(outparams.complexFixed.pmin3(2)+outparams.complexFixed.pmin3(1));
% 
% %For R2*
% vhat_standard_gtinitialised(y,x,r)=outparams.standard.pmin3(3);
% vhat_Rician_gtinitialised(y,x,r)=outparams.Rician.pmin3(3);
% vhat_complex_gtinitialised(y,x,r)=outparams.complex.pmin3(3);
% vhat_complexFixed_gtinitialised(y,x,r)=outparams.complexFixed.pmin3(3);
% 
% %For S0
% S0_standard_gtinitialised(y,x,r)=outparams.standard.pmin3(1)+outparams.standard.pmin3(2);
% S0_Rician_gtinitialised(y,x,r)=outparams.Rician.pmin3(1)+outparams.Rician.pmin3(2);
% S0_complex_gtinitialised(y,x,r)=outparams.complex.pmin3(1)+outparams.complex.pmin3(2);
% S0_complexFixed_gtinitialised(y,x,r)=outparams.complexFixed.pmin3(1)+outparams.complexFixed.pmin3(2);

%% Add fitting residuals to grid

fmin1Rician(y,x,r)=outparams.Rician.fmin1;
fmin2Rician(y,x,r)=outparams.Rician.fmin2;
fmin3Rician(y,x,r)=outparams.Rician.fmin3;

%SSE 
SSERician(y,x,r)=outparams.Rician.SSE;

%SSE true
SSEtrue_Rician(y,x,r)=outparams.Rician.SSEtrue;

%SSE versus true noise 
SSEvsTrueNoise_Rician(y,x,r)=outparams.Rician.SSE / (noise*noise');

end
end

end

close all 

%% Average parameter estimate grids over repetitions
%Data recorded in 4D array where the first two dimensions specify the
%protocol 
FFmaps.Rician(:,:,f,d)=mean(FF_Rician,3);
R2maps.Rician(:,:,f,d)=mean(vhat_Rician,3);
S0maps.Rician(:,:,f,d)=mean(S0_Rician,3);

%% Create parameter error grids
%Data recorded in 4D array where the first two dimensions specify the
%protocol 
errormaps.FFRician(:,:,f,d)=FFmaps.Rician(:,:,f,d)-FFgrid;
errormaps.R2Rician(:,:,f,d)=R2maps.Rician(:,:,f,d)-vgrid;
errormaps.S0Rician(:,:,f,d)=(S0maps.Rician(:,:,f,d)-S0)/S0;

%% Get parameter SD  grids over repetitions
%Data recorded in 4D array where the first two dimensions specify the
%protocol 
sdmaps.FFRician(:,:,f,d)=std(FF_Rician,0,3);
sdmaps.R2Rician(:,:,f,d)=std(vhat_Rician,0,3);
sdmaps.S0Rician(:,:,f,d)=std(S0_Rician,0,3)/S0;

%% Find mean parameter error values
meanError.FFRician(f,d)=mean((errormaps.FFRician(:,:,f,d)),'all');
meanError.R2Rician(f,d)=mean((errormaps.R2Rician(:,:,f,d)),'all');

%% Residuals
% Data recorded in 4D array where the first two dimensions specify the
% protocol 
residuals.Rician.fmin1(:,:,f,d)=mean(fmin1Rician,3);
residuals.Rician.fmin2(:,:,f,d)=mean(fmin2Rician,3);
residuals.Rician.SSE(:,:,f,d)=mean(SSERician,3);
residuals.Rician.SSEtrue(:,:,f,d)=mean(SSEtrue_Rician,3);
residuals.Rician.SSEvstruenoise(:,:,f,d)=mean(SSEvsTrueNoise_Rician,3);

    waitbar(d/size(deltaTeValues,2),w2)

    end

    waitbar(f/size(firstTeValues,2),w1)

end

%% Create figures for particular protocol
% Createfig(FFmaps,errormaps,sdmaps,residuals)

%Choose protocol to view
f = 2;
d = 1;

figure
subplot(1,3,1)
image(FFmaps.Rician(:,:,f,d),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabelsOptimisation
title('Rician magnitude FF')
colorbar


subplot(1,3,2)
image(errormaps.FFRician(:,:,f,d),'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabelsOptimisation
title('Rician magnitude FF error')
colorbar


subplot(1,3,3)
image(1000*errormaps.R2Rician(:,:,f,d),'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1000 1000];
FigLabelsOptimisation
title('Rician magnitude R2* error')
colorbar;

protocolError = meanError.FFRician(f,d)

%% Create figures across protocols

figure
subplot(2,2,1)
image(meanError.FFRician,'CDataMapping','scaled')
ax=gca;
% ax.CLim=[];
FigLabelsProtocols(firstTeValues,deltaTeValues)
title('FF error')
colorbar

subplot(2,2,2)
image(meanError.R2Rician,'CDataMapping','scaled')
ax=gca;
% ax.CLim=[];
FigLabelsProtocols(firstTeValues,deltaTeValues)
title('R2* error')
colorbar

subplot(2,2,3)
image(abs(meanError.FFRician),'CDataMapping','scaled')
ax=gca;
% ax.CLim=[];
FigLabelsProtocols(firstTeValues,deltaTeValues)
title('Absolute FF error')
colorbar

subplot(2,2,4)
image(abs(meanError.R2Rician),'CDataMapping','scaled')
ax=gca;
% ax.CLim=[];
FigLabelsProtocols(firstTeValues,deltaTeValues)
title('Absolute R2* error')
colorbar



end



