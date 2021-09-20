%% Create figures

function CreatefigSNR(FFmaps,errormaps,sdmaps)

% CreatefigSNR(FFmaps,errormaps,sdmaps)

% Input: FFmaps,errormaps,sdmaps

% This function takes the outputs from Simulate_Values_SNR as inputs and uses
% them to generate FF, error and SD plots

% Author:
% Tim Bray, t.bray@ucl.ac.uk

%FF
figure('Name', 'FF')
subplot(1,2,1)
image(flipud(FFmaps.standard),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Gaussian magnitude FF')
colorbar

subplot(1,2,2)
image(flipud(FFmaps.Rician),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Rician magnitude FF')
colorbar

% subplot(1,3,3)
% image(flipud(FFmaps.complex),'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[0 100];
% xticks([1 6 11 16 21 26 31 36 41 46 51]);
% xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
% xlabel('Fat fraction (%)','FontSize',12)
% yticks([1 11 21 31 41 51 61 71 81 91 101]);
% yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
% ylabel('SNR','FontSize',12)
% title('Complex FF')
% colorbar

%% R2* 
% Error
figure('Name', 'R2* error')
s1=subplot(2,2,1)
image(flipud(errormaps.R2standard),'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Standard magnitude fitting error')
colorbar

subplot(2,2,2)
image(flipud(errormaps.R2rician),'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Rician magnitude fitting error')
colorbar

% subplot(2,3,3)
% image(flipud(errormaps.R2complex),'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[-1 1];
% xticks([1 6 11 16 21 26 31 36 41 46 51]);
% xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
% xlabel('Fat fraction (%)','FontSize',12)
% yticks([1 11 21 31 41 51 61 71 81 91 101]);
% yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
% ylabel('SNR','FontSize',12)
% title('Complex fitting error')
% colorbar

%R2* SD

s1=subplot(2,2,3)
image(flipud(abs(sdmaps.R2standard)),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Standard magnitude fitting SD')
colorbar

subplot(2,2,4)
image(flipud(abs(sdmaps.R2rician)),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Rician magnitude fitting SD')
colorbar

% subplot(2,3,6)
% image(flipud(abs(sdmaps.R2complex)),'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[0 1];
% xticks([1 6 11 16 21 26 31 36 41 46 51]);
% xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
% xlabel('Fat fraction (%)','FontSize',12)
% yticks([1 11 21 31 41 51 61 71 81 91 101]);
% yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
% ylabel('SNR','FontSize',12)
% title('Complex fitting SD')
% colorbar

%% FF error

%FF bias
figure('Name', 'FF error')
s1=subplot(3,2,1)
image(flipud(errormaps.FFstandard),'CDataMapping','scaled')
ax=gca;
ax.CLim=[-100 100];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Gaussian magnitude fitting error')
colorbar

subplot(3,2,2)
image(flipud(errormaps.FFrician),'CDataMapping','scaled')
ax=gca;
ax.CLim=[-100 100];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Rician magnitude fitting error')
colorbar

% subplot(3,3,3)
% image(flipud(errormaps.FFcomplex),'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[-100 100];
% xticks([1 6 11 16 21 26 31 36 41 46 51]);
% xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
% xlabel('Fat fraction (%)','FontSize',12)
% yticks([1 11 21 31 41 51 61 71 81 91 101]);
% yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
% ylabel('SNR','FontSize',12)
% title('Complex fitting error')
% colorbar

%Swaps
s1=subplot(3,2,3)
image(1-flipud(errormaps.FFstandard_true),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Gaussian magnitude fitting swap frequency')
colormap(s1,gray)
colorbar

s2=subplot(3,2,4)
image(1-flipud(errormaps.FFRician_true),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Rician magnitude fitting swap frequency')
colormap(s2,gray)
colorbar

% s3=subplot(3,2,6)
% image(1-flipud(errormaps.FFcomplex_true),'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[0 1];
% xticks([1 6 11 16 21 26 31 36 41 46 51]);
% xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
% xlabel('Fat fraction (%)','FontSize',12)
% yticks([1 11 21 31 41 51 61 71 81 91 101]);
% yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
% ylabel('SNR','FontSize',12)
% title('Complex fitting swap frequency')
% colormap(s3,gray)
% colorbar

%FF SD
s1=subplot(3,2,5)
image(flipud(abs(sdmaps.FFstandard)),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 50];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Gaussian magnitude fitting SD')
colormap(s1,gray)
colorbar

s2=subplot(3,2,6)
image(flipud(abs(sdmaps.FFrician)),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 50];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Rician magnitude fitting SD')
colormap(s2,gray)
colorbar

% s3=subplot(3,3,9)
% image(flipud(abs(sdmaps.FFcomplex)),'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[0 50];
% xticks([1 6 11 16 21 26 31 36 41 46 51]);
% xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
% xlabel('Fat fraction (%)','FontSize',12)
% yticks([1 11 21 31 41 51 61 71 81 91 101]);
% yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
% ylabel('SNR','FontSize',12)
% title('Complex fitting SD')
% colormap(s3,gray)
% colorbar

%% FF error for median

%FF bias
figure('Name', 'FF error for median')
s1=subplot(3,2,1)
image(flipud(errormaps.FFstandard_median),'CDataMapping','scaled')
ax=gca;
ax.CLim=[-100 100];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Gaussian magnitude fitting error')
colorbar

subplot(3,2,2)
image(flipud(errormaps.FFrician_median),'CDataMapping','scaled')
ax=gca;
ax.CLim=[-100 100];
xticks([1 6 11 16 21 26 31 36 41 46 51]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
ylabel('SNR','FontSize',12)
title('Rician magnitude fitting error')
colorbar

% subplot(3,3,3)
% image(flipud(errormaps.FFcomplex_median),'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[-100 100];
% xticks([1 6 11 16 21 26 31 36 41 46 51]);
% xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
% xlabel('Fat fraction (%)','FontSize',12)
% yticks([1 11 21 31 41 51 61 71 81 91 101]);
% yticklabels({'100','90','80','70','60','50','40','30','20','10','0'});
% ylabel('SNR','FontSize',12)
% title('Complex fitting error')
% colorbar


% %FF values
% figure('Name', 'FF')
% s1=subplot(1,4,1)
% image(abs(FF_standard_mean),'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[0 100];
% xticks([1 2 3 4 5 6 7 8 9 10 11]);
% xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
% xlabel('R2* (ms^-^1)','FontSize',12)
% yticks([1 6 11 16 21 26 31 36 41 46 51]);
% yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
% ylabel('Fat fraction (%)','FontSize',12)
% title('Standard magnitude fitting')
% 
% subplot(1,4,2)
% image(abs(FF_Rician_mean),'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[0 100];
% xticks([1 2 3 4 5 6 7 8 9 10 11]);
% xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
% xlabel('R2* (ms^-^1)','FontSize',12)
% yticks([1 6 11 16 21 26 31 36 41 46 51]);
% yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
% ylabel('Fat fraction (%)','FontSize',12)
% title('Rician magnitude fitting')
% 
% subplot(1,4,3)
% image(abs(FF_dual_mean),'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[0 100];
% xticks([1 2 3 4 5 6 7 8 9 10 11]);
% xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
% xlabel('R2* (ms^-^1)','FontSize',12)
% yticks([1 6 11 16 21 26 31 36 41 46 51]);
% yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
% ylabel('Fat fraction (%)','FontSize',12)
% title('Dual fitting')
% 
% subplot(1,4,4)
% image(abs(FF_complex_mean),'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[0 100];
% xticks([1 2 3 4 5 6 7 8 9 10 11]);
% xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
% xlabel('R2* (ms^-^1)','FontSize',12)
% yticks([1 6 11 16 21 26 31 36 41 46 51]);
% yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
% ylabel('Fat fraction (%)','FontSize',12)
% title('Complex fitting')