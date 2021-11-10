% Master script
% Runs the various simulations and generates figures
% Author: Tim Bray (t.bray@ucl.ac.uk)

%% Set number of reps across simulations
reps=1000;

%% Run simulations for varying FF and SNR with R2* = 0
% [FFmaps,errormaps,sdmaps] = Simulate_Values_SNR(v,reps)

[FFmaps,errormaps,sdmaps] = Simulate_Values_SNR(0,reps)

%% Run simulations for varying FF and R2* with SNR = 60
% [FFmaps,errormaps,sdmaps] = Simulate_Values(SNR,reps)

[FFmaps,errormaps,sdmaps] = Simulate_Values(60,0,reps)

%% Run simulations for varying FF and R2* with SNR = 20
% [FFmaps,errormaps,sdmaps] = Simulate_Values(SNR,reps)

[FFmaps,errormaps,sdmaps] = Simulate_Values(20,0,reps)

%% Run likelihood function analysis for chosen FF, R2*, SNR
% [outparams] = Likelihood(FF,R2*,SNR,figshow) %Set figshow=1 for display

% Combination 1 (R2*=0, both methods likely to succeed): 
    %Run likelihood function analysis
    [outparams] = VisObjFun(0.2,0,60,1)
    %Show proportion of successful fits
    Fitsuccess(0.2,0,60,200)

% Combination 2 (Larger R2*, Rician may outperform): 
    %Run likelihood function analysis
    [outparams] = VisObjFun(0.2,0.3,60,1)
    %Show proportion of successful fits
    Fitsuccess(0.2,0.3,60,200)
    
% Combination 3 (Largest R2*, challenging case but Rician best): 
    %Run likelihood function analysis
    [outparams] = VisObjFun(0.2,0.5,60,1)
    %Show proportion of successful fits
    Fitsuccess(0.2,0.5,60,200) %Can use larger number of reps here as only one value pair / set