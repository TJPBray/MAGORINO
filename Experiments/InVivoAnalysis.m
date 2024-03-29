function [fittedSimFF,fittedSimR2] = InVivoAnalysis(imData, maps, indent)
%function InVivoAnalysis(maps)

%Input:
%imData is initial data used to generate maps along with TE; this provides
%the TE for simulation from in vivo values
%indent specifies the region for analysis

%maps is a structure generated for Gaussian, Rician fitting by
%MultiStepFitImage

% %simErrorMaps is a structure containing simulation results for
% % FF and R2* values corresponding to in vivo data



%% Get image matrix size to enable choice of image region to evaluate
matSize=size(maps.FFrician,1);

%% Convert to vectors
FFrician=reshape(maps.FFrician(indent:matSize-indent,indent:matSize-indent),[],1);
R2rician=reshape(maps.R2rician(indent:matSize-indent,indent:matSize-indent),[],1);
FFgaussian=reshape(maps.FFstandard(indent:matSize-indent,indent:matSize-indent),[],1);
R2gaussian=reshape(maps.R2standard(indent:matSize-indent,indent:matSize-indent),[],1);
FFdiff=FFgaussian-FFrician;
R2diff=R2gaussian-R2rician;

% %% Subtract errormaps (Gaussian - Rician) to ease visualisation
% simFFdiff = simErrorMaps.FFstandard - simErrorMaps.FFRician;
% simR2diff = simErrorMaps.R2standard - simErrorMaps.R2Rician;

%% Perform simulation using in vivo distribution

%Get echotimes
echotimes = 1000*imData.TE; 
% echotimes = [1.1760,	2.776,	4.376,	5.977,	7.577,	9.177];

[fittedSimFF,fittedSimR2] = SimulateInVivoValues(FFrician, R2rician, 40, echotimes) % Use Rician ground truth for now (consider supplying both)

% Subtract values (Gaussian - Rician) to ease comparison with in vivo data
simFFdiff = fittedSimFF.standard  - fittedSimFF.Rician;
simR2diff = fittedSimR2.standard  - fittedSimR2.Rician;

%% Plot 

figure

subplot(5,6,1)
imshow(maps.FFstandard(indent:matSize-indent,indent:matSize-indent),[0 1])
title('Gaussian')
colormap('parula')

subplot(5,6,2)
imshow(maps.FFrician(indent:matSize-indent,indent:matSize-indent),[0 1])
title('Rician')
colormap('parula')

subplot(5,6,3)
imshow(maps.FFrician(indent:matSize-indent,indent:matSize-indent) - maps.FFstandard(indent:matSize-indent,indent:matSize-indent),[-0.2 0.2])
title('R - G')

subplot(5,6,4)
imshow(1000*maps.R2standard(indent:matSize-indent,indent:matSize-indent),[0 300])
title('Gaussian')

subplot(5,6,5)
imshow(1000*maps.R2rician(indent:matSize-indent,indent:matSize-indent),[0 300])
title('Rician')

subplot(5,6,6)
imshow(1000*maps.R2rician(indent:matSize-indent,indent:matSize-indent) - 1000*maps.R2standard(indent:matSize-indent,indent:matSize-indent),[-50 50])
title('R - G')

subplot(5,2,3)
scatter(FFrician,FFgaussian)
xlabel('PDFF Rician')
ylabel('PDFF Gaussian')
xlim([0 1])

subplot(5,2,4)
scatter(1000*R2rician,1000*R2gaussian)
xlabel('R2* Rician (s^-^1)')
ylabel('R2* Gaussian (s^-^1)')
xlim([0 1000])
ylim([0 1000])
hold on
plot([0 1],[0 1],'k--')
hold off

subplot(5,2,5)
scatter(1000*R2rician,FFdiff)
xlabel('R2* Rician')
ylabel('PDFF Gaussian - PDFF Rician')
xlim([0 1000])
hold on
plot([0 1],[0 0],'k--')
hold off

% subplot(4,2,5)
% scatter3(R2rician,FFrician,FFdiff,15,FFdiff,'filled')
% xlabel('R2* Rician')
% ylabel('PDFF Rician')
% zlabel('PDFF Rician - PDFF Gaussian')
% xlim([0 1])
% title('PDFF bias')
% c=colorbar;
% c.Label.String=('PDFF Gaussian - PDFF Rician');
% ax=gca;
% ax.CLim=[-1 1];
% 
% subplot(4,2,6)
% scatter3(R2rician,FFrician,R2diff,15,R2diff,'filled')
% xlabel('R2* Rician')
% ylabel('PDFF Rician')
% zlabel('R2* Rician - R2* Gaussian')
% xlim([0 1])
% title('R2* bias')
% c=colorbar;
% c.Label.String=('R2* Gaussian - R2* Rician');
% ax=gca;
% ax.CLim=[-0.2 0.2];

%Scaling factor for points
scale=50;

subplot(5,2,7)
scatter3(1000*R2rician,FFrician,FFdiff,15,FFdiff,'o','filled')
xlabel('R2* Rician')
ylabel('PDFF Rician')
zlabel('PDFF Rician - PDFF Gaussian')
xlim([0 1000])
title('In vivo: PDFF bias')
c=colorbar;
c.Label.String=('PDFF Gaussian - PDFF Rician');
view(0,90)
ax=gca;
ax.CLim=[-0.3 0.3];
set(gca, 'YDir','reverse')

subplot(5,2,8)
scatter3(1000*R2rician,FFrician,1000*R2diff,15,1000*R2diff,'o','filled')
xlabel('R2* Rician')
ylabel('PDFF Rician')
zlabel('R2* Gaussian - R2* Rician (s^-^1)')
xlim([0 1000])
title('In vivo: R2* bias')
colorbar
c=colorbar;
c.Label.String=('R2* Gaussian - R2* Rician');
view(0,90)
ax=gca;
ax.CLim=[-100 100];
set(gca, 'YDir','reverse')

subplot(5,2,9)
scatter3(1000*fittedSimR2.Rician,fittedSimFF.Rician,simFFdiff,15,simFFdiff,'o','filled')
xlabel('R2* Rician')
ylabel('PDFF Rician')
zlabel('PDFF Gaussian - PDFF Rician')
xlim([0 1000])
title('Simulation: PDFF bias')
c=colorbar;
c.Label.String=('PDFF Gaussian - PDFF Rician');
view(0,90)
ax=gca;
ax.CLim=[-0.5 0.5];
set(gca, 'YDir','reverse')

subplot(5,2,10)
scatter3(1000*fittedSimR2.Rician,fittedSimFF.Rician,1000*simR2diff,15,1000*simR2diff,'o','filled')
xlabel('R2* Rician')
ylabel('PDFF Rician')
zlabel('R2* Gaussian - R2* Rician (s^-^1)')
xlim([0 1000])
title('Simulation: R2* bias')
colorbar
c=colorbar;
c.Label.String=('R2* Gaussian - R2* Rician');
view(0,90)
ax=gca;
ax.CLim=[-100 100];
set(gca, 'YDir','reverse')





% s1=subplot(5,2,9)
% image(simFFdiff,'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[-1 1];
% xticks([1 2 3 4 5 6 7 8 9 10 11]);
% xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
% xlabel('R2* (ms^-^1)','FontSize',12)
% yticks([1 6 11 16 21 26 31 36 41 46 51]);
% yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
% ylabel('Fat fraction (%)','FontSize',12)
% title('Simulation: PDFF Gaussian - PDFF Rician')
% colorbar
% 
% s1=subplot(5,2,10)
% image(simR2diff,'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[-1 1];
% xticks([1 2 3 4 5 6 7 8 9 10 11]);
% xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
% xlabel('R2* (ms^-^1)','FontSize',12)
% yticks([1 6 11 16 21 26 31 36 41 46 51]);
% yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
% ylabel('Fat fraction (%)','FontSize',12)
% title('Simulation: R2* Gaussian - R2* Rician')
% colorbar




end
