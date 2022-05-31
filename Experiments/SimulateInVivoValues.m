function [FF,R2] = SimulateInVivoValues(FFvals, R2vals, SNR, echotimes)
% function  = SimulateInVivoValues(FFvals, R2vals, SNR, echotimes)

% Description:
% Enables simulation of signal from in vivo parameter distribution

% Input: 
% SNR is the true SNR; sigma is calculated from this assuming ground truth
% S0 value

% sigmaError is the proportional error on sigma due to inaccurate
% estimation

% reps is number of simulation instantiations

% Output: 
% FF, error, standard deviation and residuals over a range of FF and R2* values

% Author:
% Tim Bray, t.bray@ucl.ac.uk

%Specify S0
S0=100;

%Create vectors of ground truth values
Fvals=S0*FFvals;
Wvals=S0-Fvals;
fB=0;

%% Define noise parameters (NB MAGO paper reports typical SNR in vivo of 40
% at 1.5T and 60 at 3T. However, may be lower in the presence of iron or
% marrow. The SNR is a function input. 

noiseSD=S0/SNR;

% Initialise dummy ground truth signal
GT.S = [1 2 3 4 5 6];
GT.p = [10 10 0.1 0];

FF=struct;
R2=struct;

%Fix the random seed
rng(2);

%Waitbar
f=waitbar(0,'Progress');


%% Loop over voxels
for n=1:size(Fvals,1)

%Simulate noise-free signal
Snoisefree=MultiPeakFatSingleR2(echotimes,3,Fvals(n),Wvals(n),R2vals(n),fB);

% Generate the real and imaginary noises
noiseReal = noiseSD*randn(1,numel(echotimes))';
noiseImag = noiseSD*randn(1,numel(echotimes))';
noise = noiseReal + 1i*noiseImag;

%Add noise
Snoisy=Snoisefree+noise;

% Implement fitting with noisy data
% This will implement both standard magnitude fitting and with Rician noise
% modelling
outparams = FittingWrapper(echotimes,3,Snoisy,noiseSD,GT);

%For FF
FFstandard(n)=outparams.standard.F/(outparams.standard.W+outparams.standard.F);
FFRician(n)=outparams.Rician.F/(outparams.Rician.W+outparams.Rician.F);

%For R2*
R2standard(n)=outparams.standard.R2;
R2Rician(n)=outparams.Rician.R2;

waitbar(n/size(Fvals,1), f);

end

FF.standard=FFstandard;
FF.Rician=FFRician;
R2.standard=R2standard;
R2.Rician=R2Rician;

end


