function Fitsuccess(FF,v,SNR,reps)

%  Description:
% Measures the frequency of correct minimisation with two fitting methods
% (Gaussian and Rician)

% Input: 
% FF, R2*, SNR, repetitions

% Output:
% Generates histograms showing frequency of estimates in relation to ground
% truth

% Author:
% Tim Bray, t.bray@ucl.ac.uk

%% Loop over repetitions
parfor r =1:reps
    
    [outparams] = VisObjFun(FF,v,SNR,0);
    
    %Standard fitting
    
    %Get FF and v
    fittedFF_mag(r,1)=100*outparams.standard.F/(outparams.standard.F+outparams.standard.W);
    fittedv_mag(r,1)=outparams.standard.R2;
    %Get MLE from grid search
    MLE_FF_standard(r,1)=outparams.standard.gridFF;
    %Get likelihood difference for standard fitting
    likdiff_mag(r,1)=-(outparams.standard.fmin1-outparams.standard.fmin2);

    
    %Rician fitting
    
    %Get FF for Rician fitting
    fittedFF_Ric(r,1)=100*outparams.Rician.F/(outparams.Rician.F+outparams.Rician.W);
    fittedv_Ric(r,1)=outparams.Rician.R2;
    %Get likelihood difference for Rician
    likdiff_Ric(r,1)=-(outparams.Rician.fmin1-outparams.Rician.fmin2); % -sign needed here to enable like-for-like comparison, because Gaussian fitting minimises SSE whereas Rician fitting minimised NEGATIVE likelihood
    %Get MLE for Rician fitting
    MLE_FF_Rician(r,1)=outparams.Rician.gridFF;
    
    %Complex fitting
    
    %Get FF for Rician fitting
    fittedFF_complex(r,1)=100*outparams.complex.F/(outparams.complex.F+outparams.complex.W);
    fittedv_complex(r,1)=outparams.complex.R2;
    %Get likelihood difference for Rician
    likdiff_complex(r,1)=-(outparams.complex.fmin1-outparams.complex.fmin2); % -sign needed here to enable like-for-like comparison, because Gaussian fitting minimises SSE whereas Rician fitting minimised NEGATIVE likelihood
    %Get MLE for Rician fitting
    MLE_FF_complex(r,1)=outparams.complex.gridFF;
    
    
end


%Generate histogram for FF
figure('name',strcat('FF Estimates for FF= ',num2str(FF),'  R2*= ',num2str(v)))

title(strcat('FF Estimates for FF= ',num2str(FF),'  R2*= ',num2str(v)))

subplot(2,3,1)
histogram(fittedFF_mag,[0:2:100])
title('Fitting estimates (Gaussian)')
xticks([0 10 20 30 40 50 60 70 80 90 100]);
xticklabels({'0','10', '20', '30', '40', '50', '60', '70', '80', '90','100'});
xlabel('FF estimate','FontSize',12)
ylabel('Frequency of estimate','FontSize',12)
yl=1.5*ylim; %get y limit from histogram, then..
ylim(yl)
hold on
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
% plot([magFF_low magFF_low],[yl(1) yl(2)],'LineWidth',2,'color','blue','Linestyle','--') %..add lowmean as line
% plot([magFF_high magFF_high],[yl(1) yl(2)],'LineWidth',2,'color','black','Linestyle','--') %..add highmean as line
hold off
legend('Estimates','Ground truth')

subplot(2,3,2)
histogram(fittedFF_Ric,[0:2:100])
title('Fitting estimates (Rician)')
xticks([0 10 20 30 40 50 60 70 80 90 100]);
xticklabels({'0','10', '20', '30', '40', '50', '60', '70', '80', '90','100'});
xlabel('FF estimate','FontSize',12)
ylabel('Frequency of estimate','FontSize',12)
ylim(yl)
hold on
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
% plot([RicFF_low RicFF_low],[yl(1) yl(2)],'LineWidth',2,'color','blue','Linestyle','--') %..add lowmean as line
% plot([RicFF_high RicFF_high],[yl(1) yl(2)],'LineWidth',2,'color','black','Linestyle','--') %..add highmean as line
hold off
legend('Estimates','Ground truth')


subplot(2,3,3)
histogram(fittedFF_complex,[0:2:100])
title('Fitting estimates (complex)')
xticks([0 10 20 30 40 50 60 70 80 90 100]);
xticklabels({'0','10', '20', '30', '40', '50', '60', '70', '80', '90','100'});
xlabel('FF estimate','FontSize',12)
ylabel('Frequency of estimate','FontSize',12)
ylim(yl)
hold on
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
% plot([RicFF_low RicFF_low],[yl(1) yl(2)],'LineWidth',2,'color','blue','Linestyle','--') %..add lowmean as line
% plot([RicFF_high RicFF_high],[yl(1) yl(2)],'LineWidth',2,'color','black','Linestyle','--') %..add highmean as line
hold off
legend('Estimates','Ground truth')
% 
% subplot(3,3,4)
% histogram( MLE_FF_standard,[0:2:100])
% title('Maximum likelihood estimate from grid search (Gaussian)')
% xticks([0 10 20 30 40 50 60 70 80 90 100]);
% xticklabels({'0','10', '20', '30', '40', '50', '60', '70', '80', '90','100'});
% xlabel('FF estimate (%)','FontSize',12)
% ylabel('Frequency of estimate','FontSize',12)
% yl=1.5*ylim;%get y limit from histogram, then..
% ylim(yl)
% hold on
% plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
% hold off
% legend('Estimates','Ground truth')
% 
% subplot(3,3,5)
% histogram(MLE_FF_Rician,[0:2:100])
% title('Maximum likelihood estimate from grid search (Rician)')
% xticks([0 10 20 30 40 50 60 70 80 90 100]);
% xticklabels({'0','10', '20', '30', '40', '50', '60', '70', '80', '90','100'});
% xlabel('FF estimate (%)','FontSize',12)
% ylabel('Frequency of estimate','FontSize',12)
% ylim(yl)
% hold on
% plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
% hold off
% legend('Estimates','Ground truth')

%Generate likelihood difference plot
s1=subplot(2,3,4)
scatter(fittedFF_mag,likdiff_mag)
set(s1,'YGrid','on','GridAlpha',0.5)
title('Likelihood difference plot (Gaussian)')
ylabel('Likelihood difference','FontSize',12)
xlabel('FF estimate (%)','FontSize',12)
xlim([0 100])
yl=ylim; %get ylim to enable setting for next plot
hold on
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
hold off
legend('Estimates','Ground truth')

s2=subplot(2,3,5)
scatter(fittedFF_Ric,likdiff_Ric)
set(s2,'YGrid','on','GridAlpha',0.5)
title('Likelihood difference plot (Rician)')
ylabel('Likelihood difference','FontSize',12)
xlabel('FF estimate (%)','FontSize',12)
xlim([0 100])
ylim(yl) %set ylim to match previous plot
hold on
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
hold off
legend('Estimates','Ground truth')


%Findoutliers for simplifying desplay
[b,outliers]=rmoutliers(likdiff_complex,'percentiles',[2 98]);

%Find datapoints to be kept
kept=1-outliers;

s2=subplot(2,3,6)
scatter(kept.*fittedFF_complex,kept.*likdiff_complex)
set(s2,'YGrid','on','GridAlpha',0.5)
title('Likelihood difference plot (Complex)')
ylabel('Likelihood difference','FontSize',12)
xlabel('FF estimate (%)','FontSize',12)
xlim([0 100])
yl=ylim;
hold on
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
hold off
legend('Estimates','Ground truth')

%% Generate histogram for R2*
figure('name',strcat('R2* Estimates for FF= ',num2str(FF),'  R2*= ',num2str(v)))

title(strcat('R2* Estimates for FF= ',num2str(FF),'  R2*= ',num2str(v)))

subplot(1,3,1)
histogram(fittedv_mag,[0:0.05:1])
title('Fitting estimates (Gaussian)')
xticks([0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* estimate','FontSize',12)
ylabel('Frequency of estimate','FontSize',12)
yl=1.5*ylim; %get y limit from histogram, then..
ylim(yl)
hold on
plot([v v],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
% plot([magFF_low magFF_low],[yl(1) yl(2)],'LineWidth',2,'color','blue','Linestyle','--') %..add lowmean as line
% plot([magFF_high magFF_high],[yl(1) yl(2)],'LineWidth',2,'color','black','Linestyle','--') %..add highmean as line
hold off
legend('Estimates','Ground truth')

subplot(1,3,2)
histogram(fittedv_Ric,[0:0.05:1])
title('Fitting estimates (Rician)')
xticks([0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* estimate','FontSize',12)
ylabel('Frequency of estimate','FontSize',12)
%Use y limit from first histogram
ylim(yl)
hold on
plot([v v],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
% plot([magFF_low magFF_low],[yl(1) yl(2)],'LineWidth',2,'color','blue','Linestyle','--') %..add lowmean as line
% plot([magFF_high magFF_high],[yl(1) yl(2)],'LineWidth',2,'color','black','Linestyle','--') %..add highmean as line
hold off
legend('Estimates','Ground truth')

subplot(1,3,3)
histogram(fittedv_complex,[0:0.05:1])
title('Fitting estimates (Complex)')
xticks([0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* estimate','FontSize',12)
ylabel('Frequency of estimate','FontSize',12)
%Use y limit from first histogram
ylim(yl)
hold on
plot([v v],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
% plot([magFF_low magFF_low],[yl(1) yl(2)],'LineWidth',2,'color','blue','Linestyle','--') %..add lowmean as line
% plot([magFF_high magFF_high],[yl(1) yl(2)],'LineWidth',2,'color','black','Linestyle','--') %..add highmean as line
hold off
legend('Estimates','Ground truth')

% %Generate histogram for v
% figure('name',strcat('R2* Estimates for FF= ',num2str(FF),'  R2*= ',num2str(v)))
% 
% subplot(1,2,1)
% histogram(fittedv_mag,[0:0.05:1])
% title('Standard fitting')
% 
% subplot(1,2,2)
% histogram(fittedv_Ric,[0:0.05:1])
% title('Rician fitting')

end
