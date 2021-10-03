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
s1=subplot(1,4,1)
image(FFmaps.standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude FF')
colorbar

subplot(1,4,2)
image(FFmaps.Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude FF')
colorbar

subplot(1,4,3)
image(FFmaps.complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex FF')
colorbar

subplot(1,4,4)
image(FFmaps.complexFixed,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex FF fixed fB')
colorbar

%% 1. Parameter error
% 1.1 FF error
figure('Name', 'Parameter error')
s1=subplot(3,4,1)
image(errormaps.FFstandard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude FF error')
colorbar

subplot(3,4,2)
image(errormaps.FFRician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude FF error')
colorbar

subplot(3,4,3)
image(errormaps.FFcomplex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting FF error')
colorbar

subplot(3,4,4)
image(errormaps.FFcomplexFixed,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting FF error with fB fixed')
colorbar

% 1.2 R2* error
s1=subplot(3,4,5)
image(errormaps.R2standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude R2* error')
colorbar

subplot(3,4,6)
image(errormaps.R2Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude R2* error')
colorbar

subplot(3,4,7)
image(errormaps.R2complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting R2* error')
colorbar

subplot(3,4,8)
image(errormaps.R2complexFixed,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting R2* error with fB fixed')
colorbar


% 1.3 S0 error

s1=subplot(3,4,9);
image(errormaps.S0standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude S0 error')
colorbar

subplot(3,4,10)
image(errormaps.S0Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude S0 error')
colorbar

subplot(3,4,11)
image(errormaps.S0complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting S0 error')
colorbar

subplot(3,4,12)
image(errormaps.S0complexFixed,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting S0 error with fB fixed')
colorbar


%% 2. Parameter SD
%2.1 FF SD
figure('Name', 'Parameter SD')
s1=subplot(3,4,1)
image(abs(sdmaps.FFstandard),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude FF SD')
colorbar

s2=subplot(3,4,2)
image(abs(sdmaps.FFRician),'CDataMapping','scaled')
ax=gca;
 ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude FF SD')
colorbar

s3=subplot(3,4,3)
image(abs(sdmaps.FFcomplex),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting FF SD')
colorbar

s3=subplot(3,4,4)
image(abs(sdmaps.FFcomplexFixed),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting FF SD with fB fixed')
colorbar

%2.2 R2* SD
s1=subplot(3,4,5);
image(abs(sdmaps.R2standard),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude R2* SD')
colorbar

subplot(3,4,6)
image(abs(sdmaps.R2Rician),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude R2* SD')
colorbar

subplot(3,4,7)
image(abs(sdmaps.R2complex),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting R2* SD')
colorbar

subplot(3,4,8)
image(abs(sdmaps.R2complexFixed),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting R2* SD with fB fixed')
colorbar

% 2.3 S0 SD
s1=subplot(3,4,9);
image(abs(sdmaps.S0standard),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude S0 SD')
colorbar

subplot(3,4,10)
image(abs(sdmaps.S0Rician),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude S0 SD')
colorbar

subplot(3,4,11)
image(abs(sdmaps.S0complex),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting S0 SD')
colorbar

subplot(3,4,12)
image(abs(sdmaps.S0complexFixed),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting S0 SD with fB fixed')
colorbar

%% 3. Fitting error
figure('Name', 'Fitting error')

%3.1 SSE
s2=subplot(3,4,1)
image(residuals.standard.SSE,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 0.01];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian fitting SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,4,2)
image(residuals.Rician.SSE,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 0.01];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician fitting SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,4,3)
image(residuals.complex.SSE,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 0.01];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,4,4)
image(residuals.complexFixed.SSE,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 0.01];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting SSE with fB fixed')
colormap(s2,gray)
colorbar

%3.2 SSE true
s2=subplot(3,4,5)
image(residuals.standard.SSEtrue,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 0.01];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

s2=subplot(3,4,6)
image(residuals.Rician.SSEtrue,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 0.01];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

s2=subplot(3,4,7)
image(residuals.complex.SSEtrue,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 0.01];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

s2=subplot(3,4,8)
image(residuals.complexFixed.SSEtrue,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 0.01];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting True SSE (error vs noiseless signal) with fB fixed')
colormap(s2,gray)
colorbar

%Noise estimate compared to true noise
s2=subplot(3,4,9)
image(residuals.standard.SSEvstruenoise,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian fitting SSE / true noise SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,4,10)
image(residuals.Rician.SSEvstruenoise,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician fitting SSE / true noise SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,4,11)
image(residuals.complex.SSEvstruenoise,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting SSE / true noise SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,4,12)
image(residuals.complexFixed.SSEvstruenoise,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
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
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude FF error')
colorbar

subplot(3,3,2)
image(errormaps.FFRician_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude FF error')
colorbar

subplot(3,3,3)
image(errormaps.FFcomplex_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting FF error')
colorbar

% 4.2 R2* error
s1=subplot(3,3,4)
image(errormaps.R2standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude R2* error')
colorbar

subplot(3,3,5)
image(errormaps.R2Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude R2* error')
colorbar

subplot(3,3,6)
image(errormaps.R2complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting R2* error')
colorbar

% 4.3 S0 error
subplot(3,3,7)
image(errormaps.S0standard_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude S0 error')
colorbar

subplot(3,3,8)
image(errormaps.S0Rician_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude S0 error')
colorbar

subplot(3,3,9)
image(errormaps.S0complex_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting S0 error')
colorbar


%% 5 Parameter SD for ground-truth initialised values

figure('Name', 'Parameter SD for GT initialisation')

%5.1 FF SD
s1=subplot(3,3,1)
image(abs(sdmaps.FFstandard_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude FF SD')
colorbar

s2=subplot(3,3,2)
image(abs(sdmaps.FFRician_gtinitialised),'CDataMapping','scaled')
ax=gca;
 ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude FF SD')
colorbar

s3=subplot(3,3,3)
image(abs(sdmaps.FFcomplex_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting FF SD')
colorbar

%5.2 R2* SD

s1=subplot(3,3,4)
image(abs(sdmaps.R2standard_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude R2* SD')
colorbar

subplot(3,3,5)
image(abs(sdmaps.R2Rician_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude R2* SD')
colorbar

subplot(3,3,6)
image(abs(sdmaps.R2complex_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting R2* SD')
colorbar

%5.3 S0 SD

s1=subplot(3,3,7)
image(abs(sdmaps.S0standard_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude parameter SD')
colorbar

subplot(3,3,8)
image(abs(sdmaps.S0Rician_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude parameter SD')
colorbar

subplot(3,3,9)
image(abs(sdmaps.S0complex_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting parameter SD')
colorbar


%% 6. SSE for ground-truth initialisation

figure('Name', 'SSE  for GT initialisation')

%6.1 SSE

s2=subplot(3,3,1)
image(residuals.standard.SSEgtinit,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian fitting SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,3,2)
image(residuals.Rician.SSEgtinit,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician fitting SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,3,3)
image(residuals.complex.SSEgtinit,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting SSE')
colormap(s2,gray)
colorbar

%6.2 SSE true
s2=subplot(3,3,4)
image(residuals.standard.SSEgtinit_true,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

s2=subplot(3,3,5)
image(residuals.Rician.SSEgtinit_true,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

s2=subplot(3,3,6)
image(residuals.complex.SSEgtinit_true,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

%6.3 Estimated vs true noise
s2=subplot(3,3,7)
image(residuals.standard.SSEgtinitvstruenoise,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian fitting SSE / true noise SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,3,8)
image(residuals.Rician.SSEgtinitvstruenoise,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician fitting SSE / true noise SSE')
colormap(s2,gray)
colorbar

s2=subplot(3,3,9)
image(residuals.complex.SSEgtinitvstruenoise,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting SSE / true noise SSE')
colormap(s2,gray)
colorbar

else ;  
end



end









