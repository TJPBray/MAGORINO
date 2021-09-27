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
s1=subplot(2,3,1)
image(FFmaps.standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude FF')
colorbar

subplot(2,3,2)
image(FFmaps.Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude FF')
colorbar

subplot(2,3,3)
image(FFmaps.complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex FF')
colorbar



%% FF error
% FF error
figure('Name', 'FF error')
s1=subplot(5,3,1)
image(errormaps.FFstandard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-100 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude parameter error')
colorbar

subplot(5,3,2)
image(errormaps.FFRician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-100 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude parameter error')
colorbar

subplot(5,3,3)
image(errormaps.FFcomplex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-100 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting error')
colorbar

% %FF swaps
% s1=subplot(4,2,3)
% image(1-errormaps.FFstandard_true,'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[0 1];
% xticks([1 2 3 4 5 6 7 8 9 10 11]);
% xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
% xlabel('R2* (ms^-^1)','FontSize',12)
% yticks([1 6 11 16 21 26 31 36 41 46 51]);
% yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
% ylabel('Fat fraction (%)','FontSize',12)
% title('Gaussian magnitude fitting swap frequency')
% colormap(s1,gray)
% colorbar
% 
% s2=subplot(4,2,4)
% image(1-errormaps.FFRician_true,'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[0 1];
% xticks([1 2 3 4 5 6 7 8 9 10 11]);
% xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
% xlabel('R2* (ms^-^1)','FontSize',12)
% yticks([1 6 11 16 21 26 31 36 41 46 51]);
% yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
% ylabel('Fat fraction (%)','FontSize',12)
% title('Rician magnitude fitting swap frequency')
% colormap(s2,gray)
% colorbar

% s3=subplot(3,3,6)
% image(1-errormaps.FFcomplex_true,'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[0 1];
% xticks([1 2 3 4 5 6 7 8 9 10 11]);
% xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
% xlabel('R2* (ms^-^1)','FontSize',12)
% yticks([1 6 11 16 21 26 31 36 41 46 51]);
% yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
% ylabel('Fat fraction (%)','FontSize',12)
% title('Complex fitting swap frequency')
% colormap(s3,gray)
% colorbar


%FF SD
s1=subplot(5,3,4)
image(abs(sdmaps.FFstandard),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude fitting SD')
colormap(s1,gray)
colorbar

s2=subplot(5,3,5)
image(abs(sdmaps.FFRician),'CDataMapping','scaled')
ax=gca;
 ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude fitting SD')
colormap(s2,gray)
colorbar

s3=subplot(5,3,6)
image(abs(sdmaps.FFcomplex),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting SD')
colormap(s3,gray)
colorbar

%FF SSE
s2=subplot(5,3,7)
image(residuals.standard.SSE,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian fitting SSE')
colormap(s2,gray)
colorbar

s2=subplot(5,3,8)
image(residuals.Rician.SSE,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician fitting SSE')
colormap(s2,gray)
colorbar

s2=subplot(5,3,9)
image(residuals.complex.SSE,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting SSE')
colormap(s2,gray)
colorbar

%FF SSE true
s2=subplot(5,3,10)
image(residuals.standard.SSEtrue,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

s2=subplot(5,3,11)
image(residuals.Rician.SSEtrue,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

s2=subplot(5,3,12)
image(residuals.complex.SSEtrue,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

%FF SSE true
s2=subplot(5,3,13)
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

s2=subplot(5,3,14)
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

s2=subplot(5,3,15)
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

%% R2* error

figure('Name', 'R2* error')
s1=subplot(2,3,1)
image(errormaps.R2standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude parameter error')
colorbar

subplot(2,3,2)
image(errormaps.R2Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude parameter error')
colorbar

subplot(2,3,3)
image(errormaps.R2complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting parameter error')
colorbar

%R2* SD

s1=subplot(2,3,4)
image(abs(sdmaps.R2standard),'CDataMapping','scaled')
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

subplot(2,3,5)
image(abs(sdmaps.R2Rician),'CDataMapping','scaled')
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

subplot(2,3,6)
image(abs(sdmaps.R2complex),'CDataMapping','scaled')
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

%% S0 error

figure('Name', 'S0 error')
s1=subplot(2,3,1)
image(errormaps.S0standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude parameter error')
colorbar

subplot(2,3,2)
image(errormaps.S0Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude parameter error')
colorbar

subplot(2,3,3)
image(errormaps.S0complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting parameter error')
colorbar

%S0 SD

s1=subplot(2,3,4)
image(abs(sdmaps.S0standard),'CDataMapping','scaled')
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

subplot(2,3,5)
image(abs(sdmaps.S0Rician),'CDataMapping','scaled')
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

subplot(2,3,6)
image(abs(sdmaps.S0complex),'CDataMapping','scaled')
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

%% FF error for ground-truth initialised values
% FF error
figure('Name', 'FF error for GT initialisation')
s1=subplot(5,3,1)
image(errormaps.FFstandard_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-100 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude parameter error')
colorbar

subplot(5,3,2)
image(errormaps.FFRician_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-100 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude parameter error')
colorbar

subplot(5,3,3)
image(errormaps.FFcomplex_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-100 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting error')
colorbar

%FF SD
s1=subplot(5,3,4)
image(abs(sdmaps.FFstandard_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude fitting SD')
colormap(s1,gray)
colorbar

s2=subplot(5,3,5)
image(abs(sdmaps.FFRician_gtinitialised),'CDataMapping','scaled')
ax=gca;
 ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude fitting SD')
colormap(s2,gray)
colorbar

s3=subplot(5,3,6)
image(abs(sdmaps.FFcomplex_gtinitialised),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting SD')
colormap(s3,gray)
colorbar

%FF SSE
s2=subplot(5,3,7)
image(residuals.standard.SSEgtinit,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian fitting SSE')
colormap(s2,gray)
colorbar

s2=subplot(5,3,8)
image(residuals.Rician.SSEgtinit,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician fitting SSE')
colormap(s2,gray)
colorbar

s2=subplot(5,3,9)
image(residuals.complex.SSEgtinit,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting SSE')
colormap(s2,gray)
colorbar

%FF SSE true
s2=subplot(5,3,10)
image(residuals.standard.SSEgtinit_true,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

s2=subplot(5,3,11)
image(residuals.Rician.SSEgtinit_true,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

s2=subplot(5,3,12)
image(residuals.complex.SSEgtinit_true,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting True SSE (error vs noiseless signal)')
colormap(s2,gray)
colorbar

%FF SSE true
s2=subplot(5,3,13)
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

s2=subplot(5,3,14)
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

s2=subplot(5,3,15)
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


%% R2* error for GT initialisation

figure('Name', 'R2* error for GT initialisation')
s1=subplot(2,3,1)
image(errormaps.R2standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude parameter error')
colorbar

subplot(2,3,2)
image(errormaps.R2Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude parameter error')
colorbar

subplot(2,3,3)
image(errormaps.R2complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting parameter error')
colorbar

%R2* SD

s1=subplot(2,3,4)
image(abs(sdmaps.R2standard_gtinitialised),'CDataMapping','scaled')
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

subplot(2,3,5)
image(abs(sdmaps.R2Rician_gtinitialised),'CDataMapping','scaled')
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

subplot(2,3,6)
image(abs(sdmaps.R2complex_gtinitialised),'CDataMapping','scaled')
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

%% S0 error

figure('Name', 'S0 error for GT initialisation')
subplot(2,3,1)
image(errormaps.S0standard_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude parameter error')
colorbar

subplot(2,3,2)
image(errormaps.S0Rician_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude parameter error')
colorbar

subplot(2,3,3)
image(errormaps.S0complex_gtinitialised,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting parameter error')
colorbar

%S0 SD

s1=subplot(2,3,4)
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

subplot(2,3,5)
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

subplot(2,3,6)
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
