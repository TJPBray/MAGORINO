% Can use the following to simulate  parameters and visualise signal for testing:
% Input: v
% Output: FF error maps relative for each FF and SNR value
% Tim Bray
% t.bray@ucl.ac.uk

function [FFmaps,errormaps,sdmaps] = Simulate_Values_SNR(v)

%% Create vector of FF values


Fgrid=[0:2:100];
Wgrid=100-Fgrid;

% Add echotime values
% MAGO paper at 3T used 12 echoes (TE1 1.1, dTE 1.1)
% MAGO paper at 1.5T used 6 echoes (TE1 1.2, dTE 2)
echotimes=1.1:1.1:13.2;
% echotimes=1.2:2:11.2;

%Define fB
fB=0;

%Define field strength
tesla=3;

% Define noise parameters (NB MAGO paper reports typical SNR in vivo of 40
% at 1.5T and 60 at 3T. However, may be lower in the presence of iron or
% marrow. The SNR is a function input. 

%% Loop over SNR values

for SNR=1:100
    
noiseSD=100/SNR; %here assume total signal is 100 for simplicity (since FF maps are used as input)

%Loop through SNR values, finding noise SD for each

%Specify repetitions 
reps=3;

%Turn figure show setting on/off
figshow=0;


%% Loop through values

for a=1:size(Fgrid,2)

W=Wgrid(a);
F=Fgrid(a);    
    
%%Loop through reps
parfor r=1:reps
        

%Simulate signal
Smeasured=Fatfunction(echotimes,3,F,W,v,fB);

%Add noise
Snoisy = Smeasured + normrnd(0,noiseSD,[1 numel(echotimes)]) + i*normrnd(0,noiseSD,[1 numel(echotimes)]);

%Generate simulate 'ROI' for first echo time to get noise estimate for
%Rician fitting, % with 50 voxels
NoiseROI= normrnd(0,noiseSD,[1 200]) + i*normrnd(0,noiseSD,[1 200]);
sig=std(real(NoiseROI));


%% Implement fitting with noiseless data

% outparams_noiseless = R2fitting(echotimes,3, Smeasured, noiseSD); %Need to take magnitude here; NB fitting will still work without!

%% Implement fitting with noisy data
% This will implement both standard magnitude fitting and with Rician noise
% modelling
outparams = R2fitting(echotimes,3,Snoisy,sig); %Need to take magnitude here; NB fitting will still work without!


%% Add parameter estimates to grid
%For R2*
vhat_standard(SNR,a,r)=outparams.standard.R2;
vhat_Rician(SNR,a,r)=outparams.Rician.R2;
vhat_complex(SNR,a,r)=outparams.complex.R2;

%For FF
FF_standard(SNR,a,r)=outparams.standard.F/(outparams.standard.W+outparams.standard.F);
FF_Rician(SNR,a,r)=outparams.Rician.F/(outparams.Rician.W+outparams.Rician.F);
FF_complex(SNR,a,r)=outparams.complex.F/(outparams.complex.W+outparams.complex.F);

%% Determine if true or swapped
FF_standard_true(SNR,a,r)= (FF_standard(SNR,a,r)<=0.58)==(Fgrid(a)<=58);
FF_Rician_true(SNR,a,r)= (FF_Rician(SNR,a,r)<=0.58)==(Fgrid(a)<=58);
FF_complex_true(SNR,a,r)= (FF_complex(SNR,a,r)<=0.58)==(Fgrid(a)<=58);

end
end
end

close all 

%% Average grids over repetitions
vhat_standard_mean=mean(vhat_standard,3);
vhat_Rician_mean=mean(vhat_Rician,3);
vhat_complex_mean=mean(vhat_complex,3);

FFmaps.standard=100*mean(FF_standard,3); %Convert to percentage
FFmaps.Rician=100*mean(FF_Rician,3);
FFmaps.complex=100*mean(FF_complex,3);

FFmaps.standard_median=100*median(FF_standard,3); %Convert to percentage
FFmaps.Rician_median=100*median(FF_Rician,3);
FFmaps.complex_median=100*median(FF_complex,3);

errormaps.FFstandard_true=mean(FF_standard_true,3);
errormaps.FFRician_true=mean(FF_Rician_true,3);
errormaps.FFcomplex_true=mean(FF_complex_true,3);

%% Get SD of grids over repetitions
sdmaps.R2standard=std(vhat_standard,0,3);
sdmaps.R2rician=std(vhat_Rician,0,3);
sdmaps.R2complex=std(vhat_complex,0,3);

sdmaps.FFstandard=100*std(FF_standard,0,3); %Convert to percentage
sdmaps.FFrician=100*std(FF_Rician,0,3);
sdmaps.FFcomplex=100*std(FF_complex,0,3);


%% Create error grids
errormaps.R2standard=vhat_standard_mean-v;
errormaps.R2rician=vhat_Rician_mean-v;
errormaps.R2complex=vhat_complex_mean-v;

errormaps.FFstandard=FFmaps.standard-Fgrid;
errormaps.FFrician=FFmaps.Rician-Fgrid;
errormaps.FFcomplex=FFmaps.complex-Fgrid;

errormaps.FFstandard_median=FFmaps.standard_median-Fgrid;
errormaps.FFrician_median=FFmaps.Rician_median-Fgrid;
errormaps.FFcomplex_median=FFmaps.complex_median-Fgrid;

%% Create figures
CreatefigSNR(FFmaps,errormaps,sdmaps)
