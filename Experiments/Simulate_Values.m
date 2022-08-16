
function [FFmaps,errormaps,sdmaps,residuals] = Simulate_Values(SNR, sigmaError, reps)
% function [FFmaps,errormaps,sdmaps,residuals] = Simulate_Values(SNR)

% Description:
% Enables visualisation of FF accuracy and precision over a range of simulated FF and
% R2* values

% Input: 
% SNR is the true SNR; sigma is calculated from this assuming ground truth
% S0 value

% sigmaError is the proportional error on sigma due to inaccurate
% estimation (e.g. for overestimation of 30%, sigmaError = 0.3, for
% underestimation of 30%, sigmaError = -0.3)

% reps is number of simulation instantiations

% Output: 
% FF, error, standard deviation and residuals over a range of FF and R2* values

% Author:
% Tim Bray, t.bray@ucl.ac.uk

%% Create grid for different options of each param

%Specify S0
S0=100;

%Create grids of ground truth values
FFgrid=repelem([0:0.02:1]',1,11);

Fgrid=S0*FFgrid;

Wgrid=S0-Fgrid;

vgrid=repelem(0:0.1:1,51,1);%1ms-1 upper limit chosen to reflect Hernando et al. (went up to 1.2)

%% Specify parameter values

% Specify echotimes
% MAGO paper at 3T used 12 echoes (TE1 1.1, dTE 1.1)
% MAGO paper at 1.5T used 6 echoes (TE1 1.2, dTE 2)
echotimes=[1.1:1.1:13.2]';
%echotimes=1.2:2:11.2;

%Define fB
fB=0;

%Define field strength
tesla=3;

% Define noise parameters (NB MAGO paper reports typical SNR in vivo of 40
% at 1.5T and 60 at 3T. However, may be lower in the presence of iron or
% marrow. The SNR is a function input. 

noiseSD=S0/SNR;

% estimatedNoiseSD= noiseSD + noiseSD*sigmaError;

%Loop through SNR values, finding noise SD for each

%Turn figure show setting on/off
figshow=0;

%% First generate simulations for a small number of voxels (e.g. 100) to get sigma estimate

%Add waitbar
w1 = waitbar(0,'Progress in sigma estimation voxels');

%Define values for estimation
F=0;
W=100;
v=0;

%Specify ground truth parameter values

% Initalise GT
GT=struct();
GT.p = [0 100 0 0];

%Simulate noise-free signal
Snoisefree=MultiPeakFatSingleR2(echotimes,3,F,W,v,fB);

% Specify ground truth signal
GT.S = Snoisefree;

parfor n=1:100

%Create noise
noise=noiseSD*randn(1,numel(echotimes));

%Add noise
Snoisy(n,:)=Snoisefree+noise;

end

sigmaEst = std(Snoisy(:,1));

%Specify sigma correction factor
load("sigmaCorrection.mat")

sigmaEst = sigmaEst*sigmaCorrection(1);

%Specify error in sigma estimation (over or under)
sigmaEst = sigmaEst + sigmaEst*sigmaError;


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

%Add waitbar
w1 = waitbar(0,'Progress in R2* dimension of parameter space');
w2 = waitbar(0,'Progress in FF dimension of parameter space');

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

%For two-point initialisation

%For FF
FF_standard(y,x,r)=outparams.standard.F/(outparams.standard.W+outparams.standard.F);
FF_Rician(y,x,r)=outparams.Rician.F/(outparams.Rician.W+outparams.Rician.F);
% FF_RicianWithSigma(y,x,r)=outparams.RicianWithSigma.F/(outparams.RicianWithSigma.W+outparams.RicianWithSigma.F);
FF_complex(y,x,r)=outparams.complex.F/(outparams.complex.W+outparams.complex.F);
% FF_complexFixed(y,x,r)=outparams.complexFixed.F/(outparams.complexFixed.W+outparams.complexFixed.F);

%For R2*
vhat_standard(y,x,r)=outparams.standard.R2;
vhat_Rician(y,x,r)=outparams.Rician.R2;
% vhat_RicianWithSigma(y,x,r)=outparams.RicianWithSigma.R2;
vhat_complex(y,x,r)=outparams.complex.R2;
% vhat_complexFixed(y,x,r)=outparams.complexFixed.R2;

%For S0
S0_standard(y,x,r)=outparams.standard.F+outparams.standard.W;
S0_Rician(y,x,r)=outparams.Rician.F+outparams.Rician.W;
% S0_RicianWithSigma(y,x,r)=outparams.RicianWithSigma.F+outparams.RicianWithSigma.W;
S0_complex(y,x,r)=outparams.complex.F+outparams.complex.W;
% S0_complexFixed(y,x,r)=outparams.complexFixed.F+outparams.complexFixed.W;

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
fmin1standard(y,x,r)=outparams.standard.fmin1;
fmin2standard(y,x,r)=outparams.standard.fmin2;
fmin3standard(y,x,r)=outparams.standard.fmin3;

fmin1Rician(y,x,r)=outparams.Rician.fmin1;
fmin2Rician(y,x,r)=outparams.Rician.fmin2;
fmin3Rician(y,x,r)=outparams.Rician.fmin3;

% fmin1RicianWithSigma(y,x,r)=outparams.RicianWithSigma.fmin1;
% fmin2RicianWithSigma(y,x,r)=outparams.RicianWithSigma.fmin2;
% fmin3RicianWithSigma(y,x,r)=outparams.RicianWithSigma.fmin3;

fmin1complex(y,x,r)=outparams.complex.fmin1;
fmin2complex(y,x,r)=outparams.complex.fmin2;
fmin3complex(y,x,r)=outparams.complex.fmin3;

% fmin1complexFixed(y,x,r)=outparams.complexFixed.fmin1;
% fmin2complexFixed(y,x,r)=outparams.complexFixed.fmin2;
% fmin3complexFixed(y,x,r)=outparams.complexFixed.fmin3;

%SSE 
SSEstandard(y,x,r)=outparams.standard.SSE; %NB SSE matches the lower of the two residuals above (i.e. the chosen likelihood maximum / error minimum)
SSERician(y,x,r)=outparams.Rician.SSE;
% SSERicianWithSigma(y,x,r)=outparams.RicianWithSigma.SSE;
SSEcomplex(y,x,r)=outparams.complex.SSE;
% SSEcomplexFixed(y,x,r)=outparams.complexFixed.SSE;

%SSE true (relative to ground truth noise-free signal)
SSEtrue_standard(y,x,r)=outparams.standard.SSEtrue;
SSEtrue_Rician(y,x,r)=outparams.Rician.SSEtrue;
% SSEtrue_RicianWithSigma(y,x,r)=outparams.RicianWithSigma.SSEtrue;
SSEtrue_complex(y,x,r)=outparams.complex.SSEtrue;
% SSEtrue_complexFixed(y,x,r)=outparams.complexFixed.SSEtrue;

%SSE versus true noise 
SSEvsTrueNoise_standard(y,x,r)=outparams.standard.SSE / (noise*noise'); %Use conjugate transpose for calculation of 'noise SSE' (denominator)
SSEvsTrueNoise_Rician(y,x,r)=outparams.Rician.SSE / (noise*noise');
% SSEvsTrueNoise_RicianWithSigma(y,x,r)=outparams.RicianWithSigma.SSE / (noise*noise');
SSEvsTrueNoise_complex(y,x,r)=outparams.complex.SSE / (noise*noise');
% SSEvsTrueNoise_complexFixed(y,x,r)=outparams.complexFixed.SSE / (noise*noise');

% %SSE with ground-truth initialisation 
% SSEgtinit_standard(y,x,r)=outparams.standard.SSEgtinit;
% SSEgtinit_Rician(y,x,r)=outparams.Rician.SSEgtinit;
% SSEgtinit_complex(y,x,r)=outparams.complex.SSEgtinit;
% SSEgtinit_complexFixed(y,x,r)=outparams.complexFixed.SSEgtinit;
% 
% %SSE true with ground-truth initialisation 
% SSEgtinit_true_standard(y,x,r)=outparams.standard.SSEtrue_gtinit;
% SSEgtinit_true_Rician(y,x,r)=outparams.Rician.SSEtrue_gtinit;
% SSEgtinit_true_complex(y,x,r)=outparams.complex.SSEtrue_gtinit;
% SSEgtinit_true_complexFixed(y,x,r)=outparams.complexFixed.SSEtrue_gtinit;
% 
% %SSE with ground-truth initialisation vs true noise
% %SSE versus true noise 
% SSEgtinitvsTrueNoise_standard(y,x,r)=outparams.standard.SSEgtinit / (noise*noise'); %Use conjugate transpose for calculation of 'noise SSE' (denominator)
% SSEgtinitvsTrueNoise_Rician(y,x,r)=outparams.Rician.SSEgtinit / (noise*noise');
% SSEgtinitvsTrueNoise_complex(y,x,r)=outparams.complex.SSEgtinit / (noise*noise');
% SSEgtinitvsTrueNoise_complexFixed(y,x,r)=outparams.complexFixed.SSEgtinit / (noise*noise');

end

waitbar(y/size(Fgrid,1),w2)

end

waitbar(x/size(Fgrid,2),w1)

end

close all 

%% Average grids over repetitions

%For two point initialisation
FFmaps.standard=mean(FF_standard,3); %Convert to percentage
FFmaps.Rician=mean(FF_Rician,3);
% FFmaps.RicianWithSigma=mean(FF_RicianWithSigma,3);
FFmaps.complex=mean(FF_complex,3);
% FFmaps.complexFixed=mean(FF_complexFixed,3);

R2maps.standard=mean(vhat_standard,3);
R2maps.Rician=mean(vhat_Rician,3);
% R2maps.RicianWithSigma=mean(vhat_RicianWithSigma,3);
R2maps.complex=mean(vhat_complex,3);
% R2maps.complexFixed=mean(vhat_complexFixed,3);

S0maps.standard=mean(S0_standard,3);
S0maps.Rician=mean(S0_Rician,3);
% S0maps.RicianWithSigma=mean(S0_RicianWithSigma,3);
S0maps.complex=mean(S0_complex,3);
% S0maps.complexFixed=mean(S0_complexFixed,3);

% %For ground truth initialisation
% FFmaps.standard_gtinitialised=mean(FF_standard_gtinitialised,3); %Convert to percentage
% FFmaps.Rician_gtinitialised=mean(FF_Rician_gtinitialised,3);
% FFmaps.complex_gtinitialised=mean(FF_complex_gtinitialised,3);
% FFmaps.complexFixed_gtinitialised=mean(FF_complexFixed_gtinitialised,3);
% 
% R2maps.standard_gtinitialised=mean(vhat_standard_gtinitialised,3);
% R2maps.Rician_gtinitialised=mean(vhat_Rician_gtinitialised,3);
% R2maps.complex_gtinitialised=mean(vhat_complex_gtinitialised,3);
% R2maps.complexFixed_gtinitialised=mean(vhat_complexFixed_gtinitialised,3);
% 
% S0maps.standard_gtinitialised=mean(S0_standard_gtinitialised,3);
% S0maps.Rician_gtinitialised=mean(S0_Rician_gtinitialised,3);
% S0maps.complex_gtinitialised=mean(S0_complex_gtinitialised,3);
% S0maps.complexFixed_gtinitialised=mean(S0_complexFixed_gtinitialised,3);

%% Create error grids

%For two-point initialisation
errormaps.FFstandard=FFmaps.standard-FFgrid;
errormaps.FFRician=FFmaps.Rician-FFgrid;
% errormaps.FFRicianWithSigma=FFmaps.RicianWithSigma-FFgrid;
errormaps.FFcomplex=FFmaps.complex-FFgrid;
% errormaps.FFcomplexFixed=FFmaps.complexFixed-FFgrid;

errormaps.R2standard=R2maps.standard-vgrid;
errormaps.R2Rician=R2maps.Rician-vgrid;
% errormaps.R2RicianWithSigma=R2maps.RicianWithSigma-vgrid;
errormaps.R2complex=R2maps.complex-vgrid;
% errormaps.R2complexFixed=R2maps.complexFixed-vgrid;

errormaps.S0standard=(S0maps.standard-S0)/S0;
errormaps.S0Rician=(S0maps.Rician-S0)/S0;
% errormaps.S0RicianWithSigma=(S0maps.RicianWithSigma-S0)/S0;
errormaps.S0complex=(S0maps.complex-S0)/S0;
% errormaps.S0complexFixed=(S0maps.complexFixed-S0)/S0;

% %For ground-truth initialisation
% errormaps.FFstandard_gtinitialised=FFmaps.standard_gtinitialised-FFgrid;
% errormaps.FFRician_gtinitialised=FFmaps.Rician_gtinitialised-FFgrid;
% 
% errormaps.FFcomplex_gtinitialised=FFmaps.complex_gtinitialised-FFgrid;
% errormaps.FFcomplexFixed_gtinitialised=FFmaps.complexFixed_gtinitialised-FFgrid;
% 
% errormaps.R2standard_gtinitialised=R2maps.standard_gtinitialised-vgrid;
% errormaps.R2Rician_gtinitialised=R2maps.Rician_gtinitialised-vgrid;
% errormaps.R2complex_gtinitialised=R2maps.complex_gtinitialised-vgrid;
% errormaps.R2complexFixed_gtinitialised=R2maps.complexFixed_gtinitialised-vgrid;
% 
% errormaps.S0standard_gtinitialised=(S0maps.standard_gtinitialised-S0)/S0;
% errormaps.S0Rician_gtinitialised=(S0maps.Rician_gtinitialised-S0)/S0;
% errormaps.S0complex_gtinitialised=(S0maps.complex_gtinitialised-S0)/S0;
% errormaps.S0complexFixed_gtinitialised=(S0maps.complexFixed_gtinitialised-S0)/S0;

%% Get SD of grids over repetitions

%For two-point initialisation
sdmaps.R2standard=std(vhat_standard,0,3);
sdmaps.R2Rician=std(vhat_Rician,0,3);
% sdmaps.R2RicianWithSigma=std(vhat_RicianWithSigma,0,3);
sdmaps.R2complex=std(vhat_complex,0,3);
% sdmaps.R2complexFixed=std(vhat_complexFixed,0,3);

sdmaps.FFstandard=std(FF_standard,0,3);
sdmaps.FFRician=std(FF_Rician,0,3);
% sdmaps.FFRicianWithSigma=std(FF_RicianWithSigma,0,3);
sdmaps.FFcomplex=std(FF_complex,0,3);
% sdmaps.FFcomplexFixed=std(FF_complexFixed,0,3);

sdmaps.S0standard=std(S0_standard,0,3)/S0; 
sdmaps.S0Rician=std(S0_Rician,0,3)/S0;
% sdmaps.S0RicianWithSigma=std(S0_RicianWithSigma,0,3)/S0;
sdmaps.S0complex=std(S0_complex,0,3)/S0;
% sdmaps.S0complexFixed=std(S0_complexFixed,0,3)/S0;

% %For ground-truth initialisation
% sdmaps.R2standard_gtinitialised=std(vhat_standard_gtinitialised,0,3);
% sdmaps.R2Rician_gtinitialised=std(vhat_Rician_gtinitialised,0,3);
% sdmaps.R2complex_gtinitialised=std(vhat_complex_gtinitialised,0,3);
% sdmaps.R2complexFixed_gtinitialised=std(vhat_complexFixed_gtinitialised,0,3);
% 
% sdmaps.FFstandard_gtinitialised=std(FF_standard_gtinitialised,0,3);
% sdmaps.FFRician_gtinitialised=std(FF_Rician_gtinitialised,0,3);
% sdmaps.FFcomplex_gtinitialised=std(FF_complex_gtinitialised,0,3);
% sdmaps.FFcomplexFixed_gtinitialised=std(FF_complexFixed_gtinitialised,0,3);
% 
% sdmaps.S0standard_gtinitialised=std(S0_standard_gtinitialised,0,3); 
% sdmaps.S0Rician_gtinitialised=std(S0_Rician_gtinitialised,0,3);
% sdmaps.S0complex_gtinitialised=std(S0_complex_gtinitialised,0,3);
% sdmaps.S0complexFixed_gtinitialised=std(S0_complexFixed_gtinitialised,0,3);

%% Find mean parameter error values
meanerror.standard=mean(abs(errormaps.FFstandard),'all');
meanerror.Rician=mean(abs(errormaps.FFRician),'all');
% meanerror.RicianWithSigma=mean(abs(errormaps.FFRicianWithSigma),'all');
meanerror.complex=mean(abs(errormaps.FFcomplex),'all');
% meanerror.complexFixed=mean(abs(errormaps.FFcomplexFixed),'all');

%% Residuals
residuals.standard.fmin1=mean(fmin1standard,3);
residuals.standard.fmin2=mean(fmin2standard,3);
residuals.standard.SSE=mean(SSEstandard,3);
residuals.standard.SSEtrue=mean(SSEtrue_standard,3);
residuals.standard.SSEvstruenoise=mean(SSEvsTrueNoise_standard,3);
% residuals.standard.SSEgtinit=mean(SSEgtinit_standard,3);
% residuals.standard.SSEgtinit_true=mean(SSEgtinit_true_standard,3);
% residuals.standard.SSEgtinitvstruenoise=mean(SSEgtinitvsTrueNoise_standard,3);

residuals.Rician.fmin1=mean(fmin1Rician,3);
residuals.Rician.fmin2=mean(fmin2Rician,3);
residuals.Rician.SSE=mean(SSERician,3);
residuals.Rician.SSEtrue=mean(SSEtrue_Rician,3);
residuals.Rician.SSEvstruenoise=mean(SSEvsTrueNoise_Rician,3);
% residuals.Rician.SSEgtinit=mean(SSEgtinit_Rician,3);
% residuals.Rician.SSEgtinit_true=mean(SSEgtinit_true_Rician,3);
% residuals.Rician.SSEgtinitvstruenoise=mean(SSEgtinitvsTrueNoise_Rician,3);

% residuals.RicianWithSigma.fmin1=mean(fmin1RicianWithSigma,3);
% residuals.RicianWithSigma.fmin2=mean(fmin2RicianWithSigma,3);
% residuals.RicianWithSigma.SSE=mean(SSERicianWithSigma,3);
% residuals.RicianWithSigma.SSEtrue=mean(SSEtrue_RicianWithSigma,3);
% residuals.RicianWithSigma.SSEvstruenoise=mean(SSEvsTrueNoise_RicianWithSigma,3);
% residuals.RicianWithSigma.SSEgtinit=mean(SSEgtinit_Rician,3);
% residuals.RicianWithSigma.SSEgtinit_true=mean(SSEgtinit_true_Rician,3);
% residuals.RicianWithSigma.SSEgtinitvstruenoise=mean(SSEgtinitvsTrueNoise_Rician,3);

residuals.complex.fmin1=mean(fmin1complex,3);
residuals.complex.fmin2=mean(fmin2complex,3);
residuals.complex.SSE=mean(SSEcomplex,3);
residuals.complex.SSEtrue=mean(SSEtrue_complex,3);
residuals.complex.SSEvstruenoise=mean(SSEvsTrueNoise_complex,3);
% residuals.complex.SSEgtinit=mean(SSEgtinit_complex,3);
% residuals.complex.SSEgtinit_true=mean(SSEgtinit_true_complex,3);
% residuals.complex.SSEgtinitvstruenoise=mean(SSEgtinitvsTrueNoise_complex,3);


% residuals.complexFixed.fmin1=mean(fmin1complexFixed,3);
% residuals.complexFixed.fmin2=mean(fmin2complexFixed,3);
% residuals.complexFixed.SSE=mean(SSEcomplexFixed,3);
% residuals.complexFixed.SSEtrue=mean(SSEtrue_complexFixed,3);
% residuals.complexFixed.SSEvstruenoise=mean(SSEvsTrueNoise_complexFixed,3);
% % residuals.complexFixed.SSEgtinit=mean(SSEgtinit_complexFixed,3);
% % residuals.complexFixed.SSEgtinit_true=mean(SSEgtinit_true_complexFixed,3);
% % residuals.complexFixed.SSEgtinitvstruenoise=mean(SSEgtinitvsTrueNoise_complexFixed,3);

%% Create figures
Createfig(FFmaps,errormaps,sdmaps,residuals)
