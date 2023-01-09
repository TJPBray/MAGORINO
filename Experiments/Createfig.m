%% Create figures

function Createfig(FFmaps,errormaps,sdmaps,residuals)
% Createfig(FFmaps,errormaps,sdmaps,residuals)

% Input: FFmaps,errormaps,sdmaps, residuals

% This function takes the outputs from Simulate_Values as inputs and uses
% them to generate FF, error, SD and residual plots

% Author:
% Tim Bray, t.bray@ucl.ac.uk

%% FF
figure('Name', 'FF')
s1=subplot(1,3,1)
image(FFmaps.standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Gaussian magnitude FF')
colorbar

subplot(1,3,2)
image(FFmaps.Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Rician magnitude FF')
colorbar

subplot(1,3,3)
image(FFmaps.complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Complex FF')
colorbar


%% 1. Parameter error
% 1.1 FF error
figure('Name', 'Parameter error')
s1=subplot(3,3,1)
image(errormaps.FFstandard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Gaussian magnitude FF error')
colorbar

subplot(3,3,2)
image(errormaps.FFRician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Rician magnitude FF error')
colorbar

subplot(3,3,3)
image(errormaps.FFcomplex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Complex fitting FF error')
colorbar


% 1.2 R2* error
s1=subplot(3,3,4)
image(1000*errormaps.R2standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1000 1000];
FigLabels;
title('Gaussian magnitude R2* error')
c=colorbar;


subplot(3,3,5)
image(1000*errormaps.R2Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1000 1000];
FigLabels;
title('Rician magnitude R2* error')
colorbar;

subplot(3,3,6)
image(1000*errormaps.R2complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1000 1000];
FigLabels;
title('Complex fitting R2* error')
colorbar;

% 1.3 S0 error

s1=subplot(3,3,7);
image(errormaps.S0standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Gaussian magnitude S0 error')
colorbar

subplot(3,3,8)
image(errormaps.S0Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Rician magnitude S0 error')
colorbar

subplot(3,3,9)
image(errormaps.S0complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Complex fitting S0 error')
colorbar


%% 2. Parameter SD
%2.1 FF SD
figure('Name', 'Parameter SD')
s1=subplot(3,3,1)
image(abs(sdmaps.FFstandard),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(abs(sdmaps.FFstandard),[],'all')];
FigLabels;
title('Gaussian magnitude FF SD')
colorbar

s2=subplot(3,3,2)
image(abs(sdmaps.FFRician),'CDataMapping','scaled')
ax=gca;
 ax.CLim=[0 2*max(abs(sdmaps.FFstandard),[],'all')];
FigLabels;
title('Rician magnitude FF SD')
colorbar

s3=subplot(3,3,3)
image(abs(sdmaps.FFcomplex),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(abs(sdmaps.FFstandard),[],'all')];
FigLabels;
title('Complex fitting FF SD')
colorbar

%2.2 R2* SD
s1=subplot(3,3,4);
image(abs(1000*sdmaps.R2standard),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(abs(1000*sdmaps.R2standard),[],'all')];
FigLabels;
title('Gaussian magnitude R2* SD')
colorbar

subplot(3,3,5)
image(abs(1000*sdmaps.R2Rician),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(abs(1000*sdmaps.R2standard),[],'all')];
FigLabels;
title('Rician magnitude R2* SD')
colorbar

subplot(3,3,6)
image(abs(1000*sdmaps.R2complex),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(abs(1000*sdmaps.R2standard),[],'all')];
FigLabels;
title('Complex fitting R2* SD')
colorbar

% 2.3 S0 SD
s1=subplot(3,3,7);
image(abs(sdmaps.S0standard),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(abs(sdmaps.S0standard),[],'all')];
FigLabels;
title('Gaussian magnitude S0 SD')
colorbar

subplot(3,3,8)
image(abs(sdmaps.S0Rician),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(abs(sdmaps.S0standard),[],'all')];
FigLabels;
title('Rician magnitude S0 SD')
colorbar


subplot(3,3,9)
image(abs(sdmaps.S0complex),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(abs(sdmaps.S0standard),[],'all')];
FigLabels;
title('Complex fitting S0 SD')
colorbar

%% 3. Fitting error
figure('Name', 'Fitting error')

%3.1 SSE
s2=subplot(3,3,1)
image(residuals.standard.SSE,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(residuals.standard.SSE,[],'all')];
FigLabels;
title('Gaussian fitting SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,3,2)
image(residuals.Rician.SSE,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(residuals.standard.SSE,[],'all')];
FigLabels;
title('Rician fitting SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,3,3)
image(residuals.complex.SSE,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(residuals.standard.SSE,[],'all')];
FigLabels;
title('Complex fitting SSE')
colormap(s2,gray)
colorbar

%3.2 SSE true
s2=subplot(3,3,4)
image(residuals.standard.SSEtrue,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(residuals.standard.SSEtrue,[],'all')];
FigLabels;
title('Gaussian fitting "True SSE"')
colormap(s2,gray)
colorbar

s2=subplot(3,3,5)
image(residuals.Rician.SSEtrue,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(residuals.standard.SSEtrue,[],'all')];
FigLabels;
title('Rician fitting "True SSE"')
colormap(s2,gray)
colorbar

s2=subplot(3,3,6)
image(residuals.complex.SSEtrue,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2*max(residuals.standard.SSEtrue,[],'all')];
FigLabels;
title('Complex fitting "True SSE"')
colormap(s2,gray)
colorbar

%Noise estimate compared to true noise
s2=subplot(3,3,7)
image(residuals.standard.SSEvstruenoise,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2];
FigLabels;
title('Gaussian fitting SSE / true noise SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,3,8)
image(residuals.Rician.SSEvstruenoise,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2];
FigLabels;
title('Rician fitting SSE / true noise SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,3,9)
image(residuals.complex.SSEvstruenoise,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2];
FigLabels;
title('Complex fitting SSE / true noise SSE')
colormap(s2,gray)
colorbar



%% Set option to show ground-truth initialised figures

%Specify whether to show figures for ground-truth initialised fitting
gtshow=0;

if gtshow==1


%% 4. Parameter error for ground-truth initialised values
% 4.1 FF error
figure('Name', 'Parameter error for GT initialisation')
s1=subplot(3,3,1)
image(errormaps.FFstandard_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Gaussian magnitude FF error')
colorbar

subplot(3,3,2)
image(errormaps.FFRician_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Rician magnitude FF error')
colorbar

subplot(3,3,3)
image(errormaps.FFcomplex_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Complex fitting FF error')
colorbar

% 4.2 R2* error
s1=subplot(3,3,4)
image(1000*errormaps.R2standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1000 1000];
FigLabels;
title('Gaussian magnitude R2* error')
c=colorbar;
c('Ticks', [-1, -0.5, 0, 0.5, 1], 'Ticklabels',[ -1000, -500, 0, +500, +1000]);

subplot(3,3,5)
image(1000*errormaps.R2Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1000 1000];
xticks([1 3 5 7 9 11]);
xticklabels({'0','200', '400', '600', '800','1000'});
xlabel('R2* (s^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
ylabel('PDFF','FontSize',12)
title('Rician magnitude R2* error')
c=colorbar;
c('Ticks', [-1, -0.5, 0, 0.5, 1], 'Ticklabels',[ -1000, -500, 0, +500, +1000]);


subplot(3,3,6)
image(1000*errormaps.R2complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1000 1000];
FigLabels;
title('Complex fitting R2* error')
c=colorbar;
c('Ticks', [-1, -0.5, 0, 0.5, 1], 'Ticklabels',[ -1000, -500, 0, +500, +1000]);


% 4.3 S0 error
subplot(3,3,7)
image(errormaps.S0standard_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Gaussian magnitude S0 error')
colorbar

subplot(3,3,8)
image(errormaps.S0Rician_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Rician magnitude S0 error')
colorbar

subplot(3,3,9)
image(errormaps.S0complex_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Complex fitting S0 error')
colorbar


%% 5 Parameter SD for ground-truth initialised values

figure('Name', 'Parameter SD for GT initialisation')

%5.1 FF SD
s1=subplot(3,3,1)
image(abs(sdmaps.FFstandard_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Gaussian magnitude FF SD')
colorbar

s2=subplot(3,3,2)
image(abs(sdmaps.FFRician_gtinitialised),'CDataMapping','scaled')
ax=gca;
 ax.CLim=[0 1];
FigLabels;
title('Rician magnitude FF SD')
colorbar

s3=subplot(3,3,3)
image(abs(sdmaps.FFcomplex_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Complex fitting FF SD')
colorbar

%5.2 R2* SD

s1=subplot(3,3,4)
image(abs(1000*sdmaps.R2standard_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1000];
xticks([1 3 5 7 9 11]);
xticklabels({'0','200', '400', '600', '800','1000'});
xlabel('R2* (s^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
ylabel('PDFF','FontSize',12)
title('Gaussian magnitude R2* SD')
colorbar

subplot(3,3,5)
image(abs(1000*sdmaps.R2Rician_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1000];
FigLabels;
title('Rician magnitude R2* SD')
colorbar

subplot(3,3,6)
image(abs(1000*sdmaps.R2complex_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1000];
FigLabels;
title('Complex fitting R2* SD')
colorbar

%5.3 S0 SD

s1=subplot(3,3,7)
image(abs(sdmaps.S0standard_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 3 5 7 9 11]);
xticklabels({'0','200', '400', '600', '800','1000'});
xlabel('R2* (s^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
ylabel('Proton density fat fraction','FontSize',12)
title('Gaussian magnitude parameter SD')
colorbar

subplot(3,3,8)
image(abs(sdmaps.S0Rician_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Rician magnitude parameter SD')
colorbar

subplot(3,3,9)
image(abs(sdmaps.S0complex_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Complex fitting parameter SD')
colorbar


%% 6. SSE for ground-truth initialisation

figure('Name', 'SSE  for GT initialisation')

%6.1 SSE

s2=subplot(3,3,1)
image(residuals.standard.SSEgtinit,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Gaussian fitting SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,3,2)
image(residuals.Rician.SSEgtinit,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Rician fitting SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,3,3)
image(residuals.complex.SSEgtinit,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Complex fitting SSE')
colormap(s2,gray)
colorbar

%6.2 SSE true
s2=subplot(3,3,4)
image(residuals.standard.SSEgtinit_true,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Gaussian fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

s2=subplot(3,3,5)
image(residuals.Rician.SSEgtinit_true,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Rician fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

s2=subplot(3,3,6)
image(residuals.complex.SSEgtinit_true,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Complex fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

%6.3 Estimated vs true noise
s2=subplot(3,3,7)
image(residuals.standard.SSEgtinitvstruenoise,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2];
FigLabels;
title('Gaussian fitting SSE / true noise SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,3,8)
image(residuals.Rician.SSEgtinitvstruenoise,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2];
FigLabels;
title('Rician fitting SSE / true noise SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,3,9)
image(residuals.complex.SSEgtinitvstruenoise,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 2];
FigLabels;
title('Complex fitting SSE / true noise SSE')
colormap(s2,gray)
colorbar

else ;  
end



end









