
function [FFmaps,errormaps,sdmaps,residuals] = Simulate_Values(SNR,reps)
% function [FFmaps,errormaps,sdmaps,residuals] = Simulate_Values(SNR)

% Description:
% Enables visualisation of FF accuracy and precision over a range of simulated FF and
% R2* values

% Input: 
% SNR, reps

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

noiseSD=S0/SNR; %here assume total signal is 100 for simplicity (since FF maps are used as input)

%Loop through SNR values, finding noise SD for each

%Turn figure show setting on/off
figshow=0;

%% Generate noise (done before looping over voxels)

%Fix the random seed
rng(1);

% Generate the real and imaginary noises
noiseReal_grid = noiseSD*randn(size(Fgrid,1),size(Fgrid,2),numel(echotimes),reps);
noiseImag_grid = noiseSD*randn(size(Fgrid,1),size(Fgrid,2),numel(echotimes),reps);
noise_grid = noiseReal_grid + 1i*noiseImag_grid;

% 
% %Generate simulate 'ROI' for first echo time to get noise estimate for
% %Rician fitting, % with 50 voxels
% NoiseROI= normrnd(0,noiseSD,[200 1]) + i*normrnd(0,noiseSD,[200 1]);
% sigma=std(real(NoiseROI));

%% Initalise GT
GT=struct();

%% Loop through values

for y=1:size(Fgrid,1)
    for x=1:size(Fgrid,2)
        
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
noise=reshape(noise,[],1);

%Add noise
Snoisy=Snoisefree+noise;

%% Implement fitting with noiseless data

% outparams_noiseless = R2fitting(echotimes,3, Smeasured, noiseSD); %Need to take magnitude here; NB fitting will still work without!

%% Implement fitting with noisy data
% This will implement both standard magnitude fitting and with Rician noise
% modelling

outparams = R2fitting(echotimes,3,Snoisy,noiseSD,GT);


%% Add parameter estimates to grid

%For two-point initialisation

%For FF
FF_standard(y,x,r)=outparams.standard.F/(outparams.standard.W+outparams.standard.F);
FF_Rician(y,x,r)=outparams.Rician.F/(outparams.Rician.W+outparams.Rician.F);
FF_complex(y,x,r)=outparams.complex.F/(outparams.complex.W+outparams.complex.F);

%For R2*
vhat_standard(y,x,r)=outparams.standard.R2;
vhat_Rician(y,x,r)=outparams.Rician.R2;
vhat_complex(y,x,r)=outparams.complex.R2;

%For S0
S0_standard(y,x,r)=outparams.standard.F+outparams.standard.W;
S0_Rician(y,x,r)=outparams.Rician.F+outparams.Rician.W;
S0_complex(y,x,r)=outparams.complex.F+outparams.complex.W;

%For ground-truth initialised values

%For FF
FF_standard_gtinitialised(y,x,r)=outparams.standard.pmin3(1)/(outparams.standard.pmin3(2)+outparams.standard.pmin3(1));
FF_Rician_gtinitialised(y,x,r)=outparams.Rician.pmin3(1)/(outparams.Rician.pmin3(2)+outparams.Rician.pmin3(1));
FF_complex_gtinitialised(y,x,r)=outparams.complex.pmin3(1)/(outparams.complex.pmin3(2)+outparams.complex.pmin3(1));

%For R2*
vhat_standard_gtinitialised(y,x,r)=outparams.standard.pmin3(3);
vhat_Rician_gtinitialised(y,x,r)=outparams.Rician.pmin3(3);
vhat_complex_gtinitialised(y,x,r)=outparams.complex.pmin3(3);

%For S0
S0_standard_gtinitialised(y,x,r)=outparams.standard.pmin3(1)+outparams.standard.pmin3(2);
S0_Rician_gtinitialised(y,x,r)=outparams.Rician.pmin3(1)+outparams.Rician.pmin3(2);
S0_complex_gtinitialised(y,x,r)=outparams.complex.pmin3(1)+outparams.complex.pmin3(2);

%% Add fitting residuals to grid
fmin1standard(y,x,r)=outparams.standard.fmin1;
fmin2standard(y,x,r)=outparams.standard.fmin2;
fmin3standard(y,x,r)=outparams.standard.fmin3;

fmin1Rician(y,x,r)=outparams.Rician.fmin1;
fmin2Rician(y,x,r)=outparams.Rician.fmin2;
fmin3Rician(y,x,r)=outparams.Rician.fmin3;

fmin1complex(y,x,r)=outparams.complex.fmin1;
fmin2complex(y,x,r)=outparams.complex.fmin2;
fmin3complex(y,x,r)=outparams.complex.fmin3;

%SSE 
SSEstandard(y,x,r)=outparams.standard.SSE; %NB SSE matches the lower of the two residuals above (i.e. the chosen likelihood maximum / error minimum)
SSERician(y,x,r)=outparams.Rician.SSE;
SSEcomplex(y,x,r)=outparams.complex.SSE;

%SSE true (relative to ground truth noise-free signal)
SSEtrue_standard(y,x,r)=outparams.standard.SSEtrue;
SSEtrue_Rician(y,x,r)=outparams.Rician.SSEtrue;
SSEtrue_complex(y,x,r)=outparams.complex.SSEtrue;

%SSE versus true noise 
SSEvsTrueNoise_standard(y,x,r)=outparams.standard.SSE / (noise'*noise); %Use conjugate transpose for calculation of 'noise SSE' (denominator)
SSEvsTrueNoise_Rician(y,x,r)=outparams.Rician.SSE / (noise'*noise);
SSEvsTrueNoise_complex(y,x,r)=outparams.complex.SSE / (noise'*noise);

%SSE with ground-truth initialisation 
SSEgtinit_standard(y,x,r)=outparams.standard.SSEgtinit;
SSEgtinit_Rician(y,x,r)=outparams.Rician.SSEgtinit;
SSEgtinit_complex(y,x,r)=outparams.complex.SSEgtinit;

%SSE true with ground-truth initialisation 
SSEgtinit_true_standard(y,x,r)=outparams.standard.SSEtrue_gtinit;
SSEgtinit_true_Rician(y,x,r)=outparams.Rician.SSEtrue_gtinit;
SSEgtinit_true_complex(y,x,r)=outparams.complex.SSEtrue_gtinit;

%SSE with ground-truth initialisation vs true noise
%SSE versus true noise 
SSEgtinitvsTrueNoise_standard(y,x,r)=outparams.standard.SSEgtinit / (noise'*noise); %Use conjugate transpose for calculation of 'noise SSE' (denominator)
SSEgtinitvsTrueNoise_Rician(y,x,r)=outparams.Rician.SSEgtinit / (noise'*noise);
SSEgtinitvsTrueNoise_complex(y,x,r)=outparams.complex.SSEgtinit / (noise'*noise);

    end
end
end

close all 

%% Average grids over repetitions

%For two point initialisation
FFmaps.standard=100*mean(FF_standard,3); %Convert to percentage
FFmaps.Rician=100*mean(FF_Rician,3);
FFmaps.complex=100*mean(FF_complex,3);

R2maps.standard=mean(vhat_standard,3);
R2maps.Rician=mean(vhat_Rician,3);
R2maps.complex=mean(vhat_complex,3);

S0maps.standard=mean(S0_standard,3);
S0maps.Rician=mean(S0_Rician,3);
S0maps.complex=mean(S0_complex,3);

%For ground truth initialisation
FFmaps.standard_gtinitialised=100*mean(FF_standard_gtinitialised,3); %Convert to percentage
FFmaps.Rician_gtinitialised=100*mean(FF_Rician_gtinitialised,3);
FFmaps.complex_gtinitialised=100*mean(FF_complex_gtinitialised,3);

R2maps.standard_gtinitialised=mean(vhat_standard_gtinitialised,3);
R2maps.Rician_gtinitialised=mean(vhat_Rician_gtinitialised,3);
R2maps.complex_gtinitialised=mean(vhat_complex_gtinitialised,3);

S0maps.standard_gtinitialised=mean(S0_standard_gtinitialised,3);
S0maps.Rician_gtinitialised=mean(S0_Rician_gtinitialised,3);
S0maps.complex_gtinitialised=mean(S0_complex_gtinitialised,3);

%% Create error grids

%For two-point initialisation
errormaps.FFstandard=FFmaps.standard-Fgrid;
errormaps.FFRician=FFmaps.Rician-Fgrid;
errormaps.FFcomplex=FFmaps.complex-Fgrid;

errormaps.R2standard=R2maps.standard-vgrid;
errormaps.R2Rician=R2maps.Rician-vgrid;
errormaps.R2complex=R2maps.complex-vgrid;

errormaps.S0standard=(S0maps.standard-S0)/S0;
errormaps.S0Rician=(S0maps.Rician-S0)/S0;
errormaps.S0complex=(S0maps.complex-S0)/S0;

%For ground-truth initialisation
errormaps.FFstandard_gtinitialised=FFmaps.standard_gtinitialised-Fgrid;
errormaps.FFRician_gtinitialised=FFmaps.Rician_gtinitialised-Fgrid;
errormaps.FFcomplex_gtinitialised=FFmaps.complex_gtinitialised-Fgrid;

errormaps.R2standard_gtinitialised=R2maps.standard_gtinitialised-vgrid;
errormaps.R2Rician_gtinitialised=R2maps.Rician_gtinitialised-vgrid;
errormaps.R2complex_gtinitialised=R2maps.complex_gtinitialised-vgrid;

errormaps.S0standard_gtinitialised=(S0maps.standard_gtinitialised-S0)/S0;
errormaps.S0Rician_gtinitialised=(S0maps.Rician_gtinitialised-S0)/S0;
errormaps.S0complex_gtinitialised=(S0maps.complex_gtinitialised-S0)/S0;

%% Get SD of grids over repetitions

%For two-point initialisation
sdmaps.R2standard=std(vhat_standard,0,3);
sdmaps.R2Rician=std(vhat_Rician,0,3);
sdmaps.R2complex=std(vhat_complex,0,3);

sdmaps.FFstandard=100*std(FF_standard,0,3);
sdmaps.FFRician=100*std(FF_Rician,0,3);
sdmaps.FFcomplex=100*std(FF_complex,0,3);

sdmaps.S0standard=std(S0_standard,0,3); 
sdmaps.S0Rician=std(S0_Rician,0,3);
sdmaps.S0complex=std(S0_complex,0,3);

%For ground-truth initialisation
sdmaps.R2standard_gtinitialised=std(vhat_standard_gtinitialised,0,3);
sdmaps.R2Rician_gtinitialised=std(vhat_Rician_gtinitialised,0,3);
sdmaps.R2complex_gtinitialised=std(vhat_complex_gtinitialised,0,3);

sdmaps.FFstandard_gtinitialised=100*std(FF_standard_gtinitialised,0,3);
sdmaps.FFRician_gtinitialised=100*std(FF_Rician_gtinitialised,0,3);
sdmaps.FFcomplex_gtinitialised=100*std(FF_complex_gtinitialised,0,3);

sdmaps.S0standard_gtinitialised=std(S0_standard_gtinitialised,0,3); 
sdmaps.S0Rician_gtinitialised=std(S0_Rician_gtinitialised,0,3);
sdmaps.S0complex_gtinitialised=std(S0_complex_gtinitialised,0,3);


%% Find mean parameter error values
meanerror.standard=mean(abs(errormaps.FFstandard),'all');
meanerror.Rician=mean(abs(errormaps.FFRician),'all');
meanerror.complex=mean(abs(errormaps.FFcomplex),'all');

%% Residuals
residuals.standard.fmin1=mean(fmin1standard,3);
residuals.standard.fmin2=mean(fmin2standard,3);
residuals.standard.SSE=mean(SSEstandard,3);
residuals.standard.SSEtrue=mean(SSEtrue_standard,3);
residuals.standard.SSEvstruenoise=mean(SSEvsTrueNoise_standard,3);
residuals.standard.SSEgtinit=mean(SSEgtinit_standard,3);
residuals.standard.SSEgtinit_true=mean(SSEgtinit_true_standard,3);
residuals.standard.SSEgtinitvstruenoise=mean(SSEgtinitvsTrueNoise_standard,3);

residuals.Rician.fmin1=mean(fmin1Rician,3);
residuals.Rician.fmin2=mean(fmin2Rician,3);
residuals.Rician.SSE=mean(SSERician,3);
residuals.Rician.SSEtrue=mean(SSEtrue_Rician,3);
residuals.Rician.SSEvstruenoise=mean(SSEvsTrueNoise_Rician,3);
residuals.Rician.SSEgtinit=mean(SSEgtinit_Rician,3);
residuals.Rician.SSEgtinit_true=mean(SSEgtinit_true_Rician,3);
residuals.Rician.SSEgtinitvstruenoise=mean(SSEgtinitvsTrueNoise_Rician,3);

residuals.complex.fmin1=mean(fmin1complex,3);
residuals.complex.fmin2=mean(fmin2complex,3);
residuals.complex.SSE=mean(SSEcomplex,3);
residuals.complex.SSEtrue=mean(SSEtrue_complex,3);
residuals.complex.SSEvstruenoise=mean(SSEvsTrueNoise_complex,3);
residuals.complex.SSEgtinit=mean(SSEgtinit_complex,3);
residuals.complex.SSEgtinit_true=mean(SSEgtinit_true_complex,3);
residuals.complex.SSEgtinitvstruenoise=mean(SSEgtinitvsTrueNoise_complex,3);

%% Create figures
Createfig(FFmaps,errormaps,sdmaps,residuals)
