

function Fitsuccess(FF,v,SNR,reps)

% Description:
% Measures the frequency of correct minimisation with two fitting methods
% (Gaussian and Rician)

% Input: 
% FF, R2*, SNR, repetitions

% Output:
% Generates histograms showing frequency of estimates in relation to ground
% truth



parfor r =1:reps
    
    [outparams] = Likelihood(FF,v,SNR,0);
    
    %Get FF and v for standard fitting
    fittedFF_mag(r,1)=100*outparams.standard.F/(outparams.standard.F+outparams.standard.W);
    fittedv_mag(r,1)=outparams.standard.R2;
    
    %Get MLE for standard fitting
    MLE_FF_standard(r,1)=outparams.standard.MLE_FF;
    
    %Get likelihood difference for standard fitting
    likdiff_mag(r,1)=outparams.standard.likmax1-outparams.standard.likmax2;

    %Get FF for Rician fitting
    fittedFF_Ric(r,1)=100*outparams.Rician.F/(outparams.Rician.F+outparams.Rician.W);
    fittedv_Ric(r,1)=outparams.Rician.R2;
    
    %Get likelihood difference for Rician
    likdiff_Ric(r,1)=-(outparams.Rician.fmin1-outparams.Rician.fmin2); % -sign needed here to enable like-for-like comparison, because Gaussian fitting minimises SSE whereas Rician fitting minimised NEGATIVE likelihood
    
    %Get MLE for Rician fitting
    MLE_FF_Rician(r,1)=outparams.Rician.MLE_FF;
    
    
end


%Generate histogram for FF
figure('name',strcat('FF Estimates for FF= ',num2str(FF),'  R2*= ',num2str(v)))

title(strcat('FF Estimates for FF= ',num2str(FF),'  R2*= ',num2str(v)))

subplot(3,2,1)
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
hold off
legend('Estimates','Ground truth')

subplot(3,2,2)
histogram(fittedFF_Ric,[0:2:100])
title('Fitting estimates (Rician)')
xticks([0 10 20 30 40 50 60 70 80 90 100]);
xticklabels({'0','10', '20', '30', '40', '50', '60', '70', '80', '90','100'});
xlabel('FF estimate','FontSize',12)
ylabel('Frequency of estimate','FontSize',12)
ylim(yl)
hold on
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
hold off
legend('Estimates','Ground truth')

subplot(3,2,3)
histogram( MLE_FF_standard,[0:2:100])
title('Maximum likelihood estimate from grid search (Gaussian)')
xticks([0 10 20 30 40 50 60 70 80 90 100]);
xticklabels({'0','10', '20', '30', '40', '50', '60', '70', '80', '90','100'});
xlabel('FF estimate (%)','FontSize',12)
ylabel('Frequency of estimate','FontSize',12)
yl=1.5*ylim;%get y limit from histogram, then..
ylim(yl)
hold on
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
hold off
legend('Estimates','Ground truth')

subplot(3,2,4)
histogram(MLE_FF_Rician,[0:2:100])
title('Maximum likelihood estimate from grid search (Rician)')
xticks([0 10 20 30 40 50 60 70 80 90 100]);
xticklabels({'0','10', '20', '30', '40', '50', '60', '70', '80', '90','100'});
xlabel('FF estimate (%)','FontSize',12)
ylabel('Frequency of estimate','FontSize',12)
ylim(yl)
hold on
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
hold off
legend('Estimates','Ground truth')



%Generate likelihood difference plot

s1=subplot(3,2,5)
scatter(fittedFF_mag,likdiff_mag)
set(s1,'YGrid','on','GridAlpha',0.5)
title('Likelihood difference plot (Gaussian)')
ylabel('Likelihood difference','FontSize',12)
xlabel('FF estimate (%)','FontSize',12)
xlim([0 100])
yl=ylim*1.5; %get ylim to enable setting for next plot
ylim(yl)
hold on
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
hold off
legend('Estimates','Ground truth')

s2=subplot(3,2,6)
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
