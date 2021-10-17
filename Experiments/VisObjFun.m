%Visualise likelihood

function [outparams] = VisObjFun(FF,v,SNR,figshow)

% function [outparams] = VisObjFun(FF,v,figshow)

% Description:
% Enables visualisation of objective function for signal intensities
% generated from specified FF and R2* values, as well as results from fit
% and grid search 

% Input: 
% Specified FF (specify as a fraction), R2* (v) and SNR 
% figshow specifies whether likelihood map is displayed

% Output: 
% Outparams structure showing fitting results from two initialisations and
% chosen parameter values as well as MLE from grid search

% Author:
% Tim Bray, t.bray@ucl.ac.uk


%% Specify parameters for signal simulation

%Specify S0
S0=1;

%Set parameters depending on specified FF
GT.p = [FF*S0, (1-FF)*S0 v 0];

%  Specify echotime values
% MAGO paper at 3T used 12 echoes (TE1 1.1, dTE 1.1)
% MAGO paper at 1.5T used 6 echoes (TE1 1.2, dTE 2)
echotimes=1.1:1.1:13.2;

%Specify field strength
tesla=3;

%% Specify SNR
% Define noise parameters (NB MAGO paper reports typical SNR in vivo of 40
% at 1.5T and 60 at 3T. However, may be lower in the presence of iron or
% marrow. 

% The SNR is a function input. SNR=60 is typical for 3T.

noiseSD=1/SNR; %here assume total signal is 100 for simplicity (since FF maps are used as input)


%% Simulate signal
sNoiseFree=MultiPeakFatSingleR2(echotimes,tesla,GT.p(1),GT.p(2),GT.p(3),GT.p(4));

%Add to GT structure for passage to fitting
GT.S=sNoiseFree;

%% Add noise

%Fix the random seed
% rng(2);

% Generate the real and imaginary noises
noiseReal = noiseSD*randn(1, numel(echotimes));
noiseImag = noiseSD*randn(1, numel(echotimes));

noise = noiseReal + 1i*noiseImag;

sNoisy = sNoiseFree + noise;

sMagNoisy=abs(sNoisy);

% Snoisy = abs(Snoisy);

%% Calculate likelihood for values

% Create grid of parameter combinations
FFgrid=repelem([0:0.01:1]',1,101);

Fgrid=S0*FFgrid;

Wgrid=S0-Fgrid;

vgrid=repelem(0:0.01:1,101,1); %1ms-1 upper limit chosen to reflect Hernando et al. (went up to 1.2)

%Loop through combinations

for y=1:size(Fgrid,1)
    for x=1:size(Fgrid,2)
        
        %pval refers to value of parameter vector for specified point on the grid
        pval(1)=Fgrid(y,x); 
        pval(2)=Wgrid(y,x);
        pval(3)=vgrid(y,x);
        pval(4)=0;
        
        loglikMag(y,x)= R2Obj(pval,echotimes,tesla,sMagNoisy,noiseSD);
        loglikRic(y,x) = R2RicianObj(pval,echotimes,tesla,sMagNoisy,noiseSD);
        loglikComplex(y,x)=R2ComplexObj(pval,echotimes,tesla,sNoisy,noiseSD);
        
    end
end

%% Find maximum likelihood using grid search

%For standard / Gaussian
[max1,ind1] = max(loglikMag,[],'all','linear');
ffGridStandard=Fgrid(ind1);
r2GridStandard=vgrid(ind1);

%For Rician
[max2,ind2] = max(loglikRic,[],'all','linear');
ffGridRician=Fgrid(ind2);
r2GridRician=vgrid(ind2);

%For complex
[max3,ind3] = max(loglikComplex,[],'all','linear');
ffGridComplex=Fgrid(ind3);
r2GridComplex=vgrid(ind3);

%% Find coords for grid search estimates

coords.gridsearch.standard.FF=100*ffGridStandard+1;
coords.gridsearch.standard.R2=100*r2GridStandard+1;

coords.gridsearch.Rician.FF=100*ffGridRician+1;
coords.gridsearch.Rician.R2=100*r2GridRician+1;

coords.gridsearch.complex.FF=100*ffGridComplex+1;
coords.gridsearch.complex.R2=100*r2GridComplex+1;

%% Set constants for initialisation

%Set initialisation value for R2*: vinit
vinit=0.1;
algoparams.vinit=0.1;
vmax=2;
vmin=0; %negative value for min to avoid penalisation at boundary

%Set signal initialisation for fat and water: Sinit
C=exp(vinit);
Sinit=C*max(abs(sNoisy)); %partially compensates for R2* to improve initialisation
algoparams.Sinit=Sinit;
% Sinit=100;

%% Fit simulated signal

%Perform fitting
outparams = R2fitting (echotimes, tesla, sNoisy, noiseSD, GT);


%% Add grid search estimates to Outparams structure (needed for Fitsuccess)

outparams.standard.gridFF=ffGridStandard;
outparams.standard.gridR2=r2GridStandard;
outparams.Rician.gridFF=ffGridRician;
outparams.Rician.gridR2=r2GridRician;
outparams.complex.gridFF=ffGridComplex;
outparams.complex.gridR2=r2GridComplex;


%% Re-implement fitting to show path on objective function

%Set option to perform with search history
searchhist=1;

%Perform fit with searchist if searchhist is set to 1
if searchhist==1
[outparams_hist,searchdir] = runfmincon(echotimes, tesla, sNoisy, noiseSD, algoparams);

else ;
end


%% Specify coords for fat fraction and R2*
%FF is ydim, R2 is xdim

%Specify ground truth coordinates
coords.gt.R2=100*v+1;
coords.gt.FF=100*FF+1;

%Specify fitted coordinates - Gaussian
%Find pmin1 coords
coords.pmin1.standard.FF=100*outparams.standard.pmin1(1)/(outparams.standard.pmin1(2)+outparams.standard.pmin1(1))+1; %calculates FF coord from FF value pmin
coords.pmin1.standard.R2=100*outparams.standard.pmin1(3)+1; %calculates R2* value from pmin
%Find pmin2 coords
coords.pmin2.standard.FF=100*outparams.standard.pmin2(1)/(outparams.standard.pmin2(2)+outparams.standard.pmin2(1))+1; %calculates FF coord from FF value pmin
coords.pmin2.standard.R2=100*outparams.standard.pmin2(3)+1; %calculates R2* value from pmin
%Find chosen minimum
coords.chosen.standard.FF=100*outparams.standard.F/(outparams.standard.F+outparams.standard.W)+1;
coords.chosen.standard.R2=100*outparams.standard.R2+1;

%Specify fitted coordinates - Rician
%Find pmin1 coords
coords.pmin1.Rician.FF=100*outparams.Rician.pmin1(1)/(outparams.Rician.pmin1(2)+outparams.Rician.pmin1(1))+1; %calculates FF value from pmin
coords.pmin1.Rician.R2=100*outparams.Rician.pmin1(3)+1; %calculates R2* value from pmin
%Find pmin2 coords
coords.pmin2.Rician.FF=100*outparams.Rician.pmin2(1)/(outparams.Rician.pmin2(2)+outparams.Rician.pmin2(1))+1; %calculates FF value from pmin
coords.pmin2.Rician.R2=100*outparams.Rician.pmin2(3)+1; %calculates R2* value from pmin
%Find chosen minimum
coords.chosen.Rician.FF=100*outparams.Rician.F/(outparams.Rician.F+outparams.Rician.W)+1;
coords.chosen.Rician.R2=100*outparams.Rician.R2+1;

%Specify fitted coordinates - complex
coords.pmin1.complex.FF=100*outparams.complex.pmin1(1)/(outparams.complex.pmin1(2)+outparams.complex.pmin1(1))+1; %calculates FF value from pmin
coords.pmin1.complex.R2=100*outparams.complex.pmin1(3)+1; %calculates R2* value from pmin
%Find pmin2 coords
coords.pmin2.complex.FF=100*outparams.complex.pmin2(1)/(outparams.complex.pmin2(2)+outparams.complex.pmin2(1))+1; %calculates FF value from pmin
coords.pmin2.complex.R2=100*outparams.complex.pmin2(3)+1; %calculates R2* value from pmin
%Find chosen minimum
coords.chosen.complex.FF=100*outparams.complex.F/(outparams.complex.F+outparams.complex.W)+1;
coords.chosen.complex.R2=100*outparams.complex.R2+1;


% %% Plot
% % figshow=0;
% 
% if figshow==1
% 
% % Plot noisy data
% figure
% plot(echotimes, abs(sNoisy)); %plot magnitude only 
% 
% hold on 
% 
% %Plot ground truth data
% plot(echotimes, abs(sNoiseFree), 'Linewidth',3); %plot magnitude only 
% 
% %Plot noiseless fits
% % plot(echotimes, abs(Fatfunction(echotimes,outparams_noiseless.standard.F,outparams_noiseless.standard.W,outparams_noiseless.standard.R2,0)),'Linewidth',3, 'Linestyle','--')
% 
% %Plot for standard fitting
% plot(echotimes, abs(MultiPeakFatSingleR2(echotimes,tesla,outparams.standard.F,outparams.standard.W,outparams.standard.R2,0)),'Linewidth',3)
% 
% %Plot for fitting with Rician noise modelling
% %Plot for standard fitting
% plot(echotimes, abs(MultiPeakFatSingleR2(echotimes,tesla,outparams.Rician.F,outparams.Rician.W,outparams.Rician.R2,0)),'Linewidth',3)
% 
% %Plot for complex fitting
% plot(echotimes, abs(MultiPeakFatSingleR2(echotimes,tesla,outparams.complex.F,outparams.complex.W,outparams.complex.R2,0)),'Linewidth',3)
% 
% %% Add legend
% legend('Noisy data', 'Ground truth', 'Standard magnitude fitting', 'Rician magnitude fitting', 'Complex fitting')
% ax=gca;
% ax.FontSize=14;
% xlabel('Echo Time (ms)');
% ylabel('Signal');

%% Display likelihood for FF and R2* combinations

%Specify whether path should be shown

pathshow=0;

if figshow==1
  
f=figure

%% 1 For standard (Gaussian)

subplot(1,3,1)
imshow(loglikMag,[-3*abs(max(loglikMag,[],'all')) max(loglikMag,[],'all')])
% image(abs(loglikMag),'CDataMapping','scaled')

% ax.CLim=[];
axis on
xticks([1 11 21 31 41 51 61 71 81 91 101]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title(strcat('Standard: Log likelihood for true FF =  ',num2str(GT.p(1)),', and true R2star =  ', num2str(GT.p(3))))
colorbar
hold on
colormap('parula')

%Add ground truth
plot(coords.gt.R2,coords.gt.FF,'wd','MarkerFaceColor','white','MarkerSize',8,'LineWidth',4)

% Add MLE from grid search
plot(coords.gridsearch.standard.R2,coords.gridsearch.standard.FF,'bd','MarkerFaceColor','white','MarkerSize',8,'LineWidth',2) %NB

%Breakpoint here to generate simplified figure without contours and labels

contour(loglikMag,[-3*abs(max(loglikMag,[],'all')):abs(max(loglikMag,[],'all')):max(loglikMag,[],'all')],'color',[0.5 0.5 0.5],'LineWidth',1)

if pathshow==1
%Add path on objective function
plot(100*outparams_hist.standard.R2_1+1,outparams_hist.standard.FF1+1,'--b.','MarkerSize',12,'LineWidth',2,'Color','black') %NB
%Add path on objective function
plot(100*outparams_hist.standard.R2_2+1,outparams_hist.standard.FF2+1,'--b.','MarkerSize',12,'LineWidth',2,'Color','black') %NB
else ;
end

%Add two candidate solutions from fitting
plot(coords.pmin1.standard.R2,coords.pmin1.standard.FF,'rx','MarkerSize',12,'LineWidth',2)
plot(coords.pmin2.standard.R2,coords.pmin2.standard.FF,'rx','MarkerSize',12,'LineWidth',2)

%Add solution from fitting
plot(coords.chosen.standard.R2, coords.chosen.standard.FF,'ro','MarkerSize',12,'LineWidth',2) %NB


%Add legend
% lgnd=legend('GT','MLE','contour','path1','path2', 'min1', 'min2', 'Fit output');
if pathshow==1
lgnd=legend('GT','MLE (grid search)','contour', 'path1','path2','opt1', 'opt2', 'Fit output');
else
lgnd=legend('GT','MLE (grid search)','contour','opt1', 'opt2', 'Fit output');
end

set(lgnd,'color','none');
hold off

%% 2 For Rician

subplot(1,3,2)
% image(exp(loglikRic),'CDataMapping','scaled')
imshow(loglikRic,[-3*abs(max(loglikMag,[],'all')) max(loglikMag,[],'all')])
ax=gca;
% ax.CLim=[];
axis on
xticks([1 11 21 31 41 51 61 71 81 91 101]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title(strcat('Rician: Log likelihood for true FF =  ',num2str(GT.p(1)),', and true R2star =  ', num2str(GT.p(3))))
colorbar
hold on
colormap('parula')


%Add ground truth
plot(coords.gt.R2,coords.gt.FF,'wd','MarkerFaceColor','white','MarkerSize',8,'LineWidth',4)

% Add MLE from grid search
plot(coords.gridsearch.Rician.R2,coords.gridsearch.Rician.FF,'bd','MarkerFaceColor','white','MarkerSize',8,'LineWidth',2) %NB

%Breakpoint here to generate simplified figure without contours and labels

%Add contours
contour(loglikRic,[-3*abs(max(loglikMag,[],'all')):abs(max(loglikMag,[],'all')):max(loglikMag,[],'all')],'color',[0.5 0.5 0.5],'LineWidth',1)

if pathshow==1
%Add path on objective function
plot(100*outparams_hist.Rician.R2_1+1,outparams_hist.Rician.FF1+1,'--b.','MarkerSize',12,'LineWidth',2,'Color','black') %NB
%Add path on objective function
plot(100*outparams_hist.Rician.R2_2+1,outparams_hist.Rician.FF2+1,'--b.','MarkerSize',12,'LineWidth',2,'Color','black') %NB
else ;
end

%Add two candidate solutions from fitting
plot(coords.pmin1.Rician.R2,coords.pmin1.Rician.FF,'rx','MarkerSize',12,'LineWidth',2)
plot(coords.pmin2.Rician.R2,coords.pmin2.Rician.FF,'rx','MarkerSize',12,'LineWidth',2)

%Add solution from fitting
plot(coords.chosen.Rician.R2, coords.chosen.Rician.FF,'ro','MarkerSize',12,'LineWidth',2) %NB


%Add legend
% lgnd=legend('GT','MLE','contour','path1','path2', 'min1', 'min2', 'Fit output');
if pathshow==1
lgnd=legend('GT','MLE (grid search)','contour', 'path1','path2','opt1', 'opt2', 'Fit output');
else
lgnd=legend('GT','MLE (grid search)','contour','opt1', 'opt2', 'Fit output');
end

set(lgnd,'color','none');
hold off

%% 3 For complex

subplot(1,3,3)
% image(exp(loglikRic),'CDataMapping','scaled')
imshow(loglikComplex,[-3*abs(max(loglikMag,[],'all')) max(loglikMag,[],'all')])
ax=gca;
% ax.CLim=[];
axis on
xticks([1 11 21 31 41 51 61 71 81 91 101]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title(strcat('Complex: Log likelihood for true FF =  ',num2str(GT.p(1)),', and true R2star =  ', num2str(GT.p(3))))
colorbar
hold on
colormap('parula')


%Add ground truth
plot(coords.gt.R2,coords.gt.FF,'wd','MarkerFaceColor','white','MarkerSize',8,'LineWidth',4)

% Add MLE from grid search
plot(coords.gridsearch.complex.R2,coords.gridsearch.complex.FF,'bd','MarkerFaceColor','white','MarkerSize',8,'LineWidth',2) %NB

%Breakpoint here to generate simplified figure without contours and labels

%Add contours
contour(loglikComplex,[-3*abs(max(loglikMag,[],'all')):abs(max(loglikMag,[],'all')):max(loglikMag,[],'all')],'color',[0.5 0.5 0.5],'LineWidth',1)

if pathshow==1
%Add path on objective function
plot(100*outparams_hist.complex.R2_1+1,outparams_hist.complex.FF1+1,'--b.','MarkerSize',12,'LineWidth',2,'Color','black') %NB
%Add path on objective function
plot(100*outparams_hist.complex.R2_2+1,outparams_hist.complex.FF2+1,'--b.','MarkerSize',12,'LineWidth',2,'Color','black') %NB
else ;
end

%Add two candidate solutions from fitting
plot(coords.pmin1.complex.R2,coords.pmin1.complex.FF,'rx','MarkerSize',12,'LineWidth',2)
plot(coords.pmin2.complex.R2,coords.pmin2.complex.FF,'rx','MarkerSize',12,'LineWidth',2)

%Add solution from fitting
plot(coords.chosen.complex.R2, coords.chosen.complex.FF,'ro','MarkerSize',12,'LineWidth',2) %NB


%Add legend
% lgnd=legend('GT','MLE','contour','path1','path2', 'min1', 'min2', 'Fit output');
if pathshow==1
lgnd=legend('GT','MLE (grid search)','contour', 'path1','path2','opt1', 'opt2', 'Fit output');
else
lgnd=legend('GT','MLE (grid search)','contour','opt1', 'opt2', 'Fit output');
end

set(lgnd,'color','none');
hold off

% print(gcf,'-dtiff',fullfile('/Users/tjb57/Dropbox/MATLAB/Rician FW/Figures',strcat('FF Estimates for FF= ',num2str(FF),'  R2star= ',num2str(v),'.tiff')))

%% Display likelihood for different FF values for chosen R2*


% May not be useful for higher R2* as the R2* values for the two minima are different -
% would need to plot a sloping line through both
% Use to generate figures for illustration of concept

figure
subplot(1,2,1)

%Get log likelihood for Gaussian fitting (profile across 3D plot)


%First get gradient for profile line 
grad=[(coords.pmin2.standard.FF-coords.pmin1.standard.FF)/(coords.pmin2.standard.R2-coords.pmin1.standard.R2)];%gradient specified in terms of FF/R2

%Now get left y-intercept and right y-intercept
yint=coords.pmin1.standard.FF-coords.pmin1.standard.R2*grad;
yhigh=yint+100*grad;

%Get profile
profile_standard=improfile(loglikMag,[0 100], [yint yhigh]); %get profile 
profile_standard_smooth=smoothdata(profile_standard,'loess',30); %smooth for visualisation (loess -> quadratic regression over each window)

xvals_standard=improfile(Fgrid,[0 100], [yint yhigh]); %get profile 

%Plot profile against FF
plot(xvals_standard,profile_standard_smooth,'LineWidth',2,'color','black','Linestyle','-')
ylabel('Likelihood','FontSize',12)
xlabel('Fat fraction (%)','FontSize',12)

%Add GT
hold on
yl=ylim; %Get xlim
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
lgnd=legend('Likelihood','Ground truth FF');


%Add horiz line at max
yl=ylim; %Get xlim
plot([0 1],[max(profile_standard) max(profile_standard)],'LineWidth',2,'color','blue','Linestyle','--') %..add ground truth as line
lgnd=legend('Likelihood','Ground truth FF','Likelihood maximum');
hold off

subplot(1,2,2)

%Get log likelihood for Rician (profile across 3D plot)

%First get gradient and y-intercept for profile line 
grad=[(coords.pmin2.Rician.FF-coords.pmin1.Rician.FF)/(coords.pmin2.Rician.R2-coords.pmin1.Rician.R2)];%gradient specified in terms of y/x

%Now get left y-intercept and right y-intercept
yint=coords.pmin1.Rician.FF-coords.pmin1.Rician.R2*grad;
yhigh=yint+100*grad;

%Get profile
profile_Rician=improfile(loglikRic,[0 100], [yint yhigh]); %get profile 
profile_Rician_smooth=smoothdata(profile_Rician,'loess',30); %smooth for visualisation (loess -> quadratic regression over each window)

xvals_Rician=improfile(Fgrid,[0 100], [yint yhigh]); %get profile 

%Plot profile against FF
plot(xvals_Rician,profile_Rician_smooth,'LineWidth',2,'color','black','Linestyle','-')
ylabel('Likelihood','FontSize',12)
xlabel('Fat fraction (%)','FontSize',12)

%Add GT
hold on
yl=ylim; %Get xlim
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line

%Add horiz line at max
yl=ylim; %Get xlim
plot([0 1],[max(profile_Rician) max(profile_Rician)],'LineWidth',2,'color','blue','Linestyle','--') %..add ground truth as line
lgnd=legend('Likelihood','Ground truth FF','Likelihood maximum');
hold off

% Below is previous implementation along row of likelihood plot (not
% accounting for 'staggering' of optima
% plot(Fgrid(:,100*v+1),loglikMag(:,100*v+1),'LineWidth',2,'color','black','Linestyle','-') %Select column in loglikMag matching specified R2* 
% ylabel('Likelihood','FontSize',12)
% xlabel('Fat fraction (%)','FontSize',12)
% 

% %Plot log likelihood for Rician
% plot(Fgrid(:,100*v+1),loglikRic(:,100*v+1),'LineWidth',2,'color','blue','Linestyle','-') %Select column in loglikRic matching specified R2* 
% 
% lgnd=legend('Gaussian','Rician');
% set(lgnd,'color','none');

% % Add lines showing maximum likelihood for Gaussian
% xl=xlim; %Get xlim
% plot([xl(1) xl(2)],[max(loglikMag(:,100*v+1)) max(loglikMag(:,100*v+1))],'LineWidth',2,'color','red','Linestyle','--') 
% plot([xl(1) xl(2)],[max(loglikRic(:,100*v+1)) max(loglikRic(:,100*v+1))],'LineWidth',2,'color','blue','Linestyle','--') 
% hold off


else ;
end


end


