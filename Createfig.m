%% Create figures

function createfig(FFmaps,errormaps,sdmaps)

%% FF
figure('Name', 'FF')
s1=subplot(2,3,1)
image(FFmaps.standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
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
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
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
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex FF')
colorbar


%% R2* 
% R2* error
figure('Name', 'R2* error')
s1=subplot(2,3,1)
image(errormaps.R2standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude fitting error')
colorbar

subplot(2,3,2)
image(errormaps.R2rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude fitting error')
colorbar

subplot(2,3,3)
image(errormaps.R2complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting error')
colorbar

%R2* SD

s1=subplot(2,3,4)
image(abs(sdmaps.R2standard),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude fitting SD')
colorbar

subplot(2,3,5)
image(abs(sdmaps.R2rician),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude fitting SD')
colorbar

subplot(2,3,6)
image(abs(sdmaps.R2complex),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting SD')
colorbar

%% FF error
% FF error
figure('Name', 'FF error')
s1=subplot(3,3,1)
image(errormaps.FFstandard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-100 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude fitting error')
colorbar

subplot(3,3,2)
image(errormaps.FFrician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-100 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude fitting error')
colorbar

subplot(3,3,3)
image(errormaps.FFerror_Complex,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-100 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting error')
colorbar

%FF swaps
s1=subplot(3,3,4)
image(1-errormaps.FFstandard_true,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude fitting swap frequency')
colormap(s1,gray)
colorbar

s2=subplot(3,3,5)
image(1-errormaps.FFRician_true,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude fitting swap frequency')
colormap(s2,gray)
colorbar

s3=subplot(3,3,6)
image(1-errormaps.FFcomplex_true,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex fitting swap frequency')
colormap(s3,gray)
colorbar


%FF SD
s1=subplot(3,3,7)
image(abs(sdmaps.FFstandard),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Gaussian magnitude fitting SD')
colormap(s1,gray)
colorbar

s2=subplot(3,3,8)
image(abs(sdmaps.FFrician),'CDataMapping','scaled')
ax=gca;
 ax.CLim=[0 100];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician magnitude fitting SD')
colormap(s2,gray)
colorbar

s3=subplot(3,3,9)
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