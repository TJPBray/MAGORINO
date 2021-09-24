
function [FFmaps,errormaps,sdmaps,residuals] = Simulate_Values(SNR,reps)
% function [FFmaps,errormaps,sdmaps] = Simulate_Values(SNR)

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

%Create grid
vgrid=repelem(0:0.1:1,51,1); %1ms-1 upper limit chosen to reflect Hernando et al. (went up to 1.2)
Fgrid=S0*repelem([0:0.02:1]',1,11);
Wgrid=S0-Fgrid;

% vgrid=repelem(0:0.2:1,6,1); %1ms-1 upper limit chosen to reflect Hernando et al. (went up to 1.2)
% Fgrid=repelem([0:20:100]',1,6);
% Wgrid=100-Fgrid;

% Add echotime values
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

%% Loop through values

for y=1:size(Fgrid,1)
    for x=1:size(Fgrid,2)
        
        W=Wgrid(y,x);
        F=Fgrid(y,x);
        v=vgrid(y,x);

%Simulate noise-free signal
Snoisefree=MultiPeakFatSingleR2(echotimes,3,F,W,v,fB);

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
outparams = R2fitting(echotimes,3,Snoisy,noiseSD,[F W v]);

%% Plot

if figshow==1

% Plot noisy data
figure('name',strcat('FF= ',num2str(F),'  R2*= ',num2str(v)))
plot(echotimes, abs(Snoisy)); %plot magnitude only 

hold on 

%Plot ground truth data
plot(echotimes, abs(Smeasured), 'Linewidth',3); %plot magnitude only 

%Plot noiseless fits
% plot(echotimes, abs(Fatfunction(echotimes,outparams_noiseless.standard.F,outparams_noiseless.standard.W,outparams_noiseless.standard.R2,0)),'Linewidth',3, 'Linestyle','--')

%Plot for standard fitting
plot(echotimes, abs(Fatfunction(echotimes,tesla,outparams.standard.F,outparams.standard.W,outparams.standard.R2,0)),'Linewidth',3)

%Plot for fitting with Rician noise modelling
%Plot for standard fitting
plot(echotimes, abs(Fatfunction(echotimes,tesla,outparams.Rician.F,outparams.Rician.W,outparams.Rician.R2,0)),'Linewidth',3)

%Plot for complex fitting
plot(echotimes, abs(Fatfunction(echotimes,tesla,outparams.complex.F,outparams.complex.W,outparams.complex.R2,0)),'Linewidth',3)

%% Add legend
legend('Noisy data', 'Ground truth', 'Standard magnitude fitting', 'Rician magnitude fitting', 'Complex fitting')
ax=gca;
ax.FontSize=14;
xlabel('Echo Time (ms)');
ylabel('Signal');

%% Print data
disp(outparams.standard)
disp(outparams.Rician)
disp(outparams.complex)

else ;
end


%% Add parameter estimates to grid
%For R2*
vhat_standard(y,x,r)=outparams.standard.R2;
vhat_Rician(y,x,r)=outparams.Rician.R2;
vhat_complex(y,x,r)=outparams.complex.R2;

%For FF
FF_standard(y,x,r)=outparams.standard.F/(outparams.standard.W+outparams.standard.F);
FF_Rician(y,x,r)=outparams.Rician.F/(outparams.Rician.W+outparams.Rician.F);
FF_complex(y,x,r)=outparams.complex.F/(outparams.complex.W+outparams.complex.F);

% %% Determine if true or swapped
% FF_standard_true(y,x,r)= (FF_standard(y,x,r)<=0.58)==(Fgrid(y,x)<=58);
% FF_Rician_true(y,x,r)= (FF_Rician(y,x,r)<=0.58)==(Fgrid(y,x)<=58);
% FF_complex_true(y,x,r)= (FF_complex(y,x,r)<=0.58)==(Fgrid(y,x)<=58);

%% Add fitting residuals to grid
fmin1standard(y,x,r)=outparams.standard.fmin1;
fmin2standard(y,x,r)=outparams.standard.fmin2;

fmin1Rician(y,x,r)=outparams.Rician.fmin1;
fmin2Rician(y,x,r)=outparams.Rician.fmin2;

SSEstandard(y,x,r)=outparams.standard.SSE; %NB SSE matches the lower of the two residuals above (i.e. the chosen likelihood maximum / error minimum)
SSERician(y,x,r)=outparams.Rician.SSE;

    end
end
end

close all 

%% Average grids over repetitions
vhat_standard_mean=mean(vhat_standard,3);
vhat_Rician_mean=mean(vhat_Rician,3);
vhat_complex_mean=mean(vhat_complex,3);

FF_standard_mean=100*mean(FF_standard,3); %Convert to percentage
FF_Rician_mean=100*mean(FF_Rician,3);
FF_complex_mean=100*mean(FF_complex,3);

% errormaps.FFstandard_true=mean(FF_standard_true,3);
% errormaps.FFRician_true=mean(FF_Rician_true,3);
% errormaps.FFcomplex_true=mean(FF_complex_true,3);

residuals.standard.fmin1=mean(fmin1standard,3);
residuals.standard.fmin2=mean(fmin2standard,3);
residuals.standard.SSE=mean(SSEstandard,3);

residuals.Rician.fmin1=mean(fmin1Rician,3);
residuals.Rician.fmin2=mean(fmin2Rician,3);
residuals.Rician.SSE=mean(SSERician,3);

%% Get SD of grids over repetitions
vhat_standard_sd=std(vhat_standard,0,3);
vhat_Rician_sd=std(vhat_Rician,0,3);
vhat_complex_sd=std(vhat_complex,0,3);

FF_standard_sd=100*std(FF_standard,0,3); %Convert to percentage
FF_Rician_sd=100*std(FF_Rician,0,3);
FF_complex_sd=100*std(FF_complex,0,3);


%% Create error grids
R2error_standard=vhat_standard_mean-vgrid;
R2error_Rician=vhat_Rician_mean-vgrid;
R2error_Complex=vhat_complex_mean-vgrid;

FFerror_standard=FF_standard_mean-Fgrid;
FFerror_Rician=FF_Rician_mean-Fgrid;
FFerror_Complex=FF_complex_mean-Fgrid;

%% Add to structure
FFmaps.standard=FF_standard_mean; %Convert to percentage
FFmaps.Rician=FF_Rician_mean;
FFmaps.complex=FF_complex_mean;

errormaps.R2standard=R2error_standard;
errormaps.R2rician=R2error_Rician;
errormaps.R2complex=R2error_Complex;

errormaps.FFstandard=FFerror_standard;
errormaps.FFrician=FFerror_Rician;
errormaps.FFerror_Complex=FFerror_Complex;

sdmaps.R2standard=vhat_standard_sd;
sdmaps.R2rician=vhat_Rician_sd;
sdmaps.R2complex=vhat_complex_sd;

sdmaps.FFstandard=FF_standard_sd;
sdmaps.FFrician=FF_Rician_sd;
sdmaps.FFcomplex=FF_complex_sd;


%% Find mean parameter error values
meanerror.standard=mean(abs(errormaps.FFstandard),'all')
meanerror.Rician=mean(abs(errormaps.FFrician),'all')
meanerror.complex=mean(abs(errormaps.FFerror_Complex),'all')

%% Create figures
Createfig(FFmaps,errormaps,sdmaps,residuals)
