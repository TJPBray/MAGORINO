%Minimisation success
%Measures the frequency of correct minimisation with two fitting methods
%(Gaussian and Rician)
function Fitsuccess(FF,v)

% Specify FF and R2*

%Specify reps
R=30;

parfor reps =1:R
    
    [outparams] = Likelihood(FF,v,0);
    
    %Get FF and v for standard fitting
    fittedFF_mag(reps,1)=100*outparams.standard.F/(outparams.standard.F+outparams.standard.W);
    fittedv_mag(reps,1)=outparams.standard.R2;
    
    %Get MLE for standard fitting
    MLE_FF_standard(reps,1)=outparams.standard.MLE_FF;
    
    %Get likelihood difference for standard fitting
    likdiff_mag(reps,1)=outparams.standard.fmin1-outparams.standard.fmin2;

    
    %Get FF for Rician fitting
    fittedFF_Ric(reps,1)=100*outparams.Rician.F/(outparams.Rician.F+outparams.Rician.W);
    fittedv_Ric(reps,1)=outparams.Rician.R2;
    
    %Get likelihood difference for Rician
    likdiff_Ric(reps,1)=outparams.Rician.fmin1-outparams.Rician.fmin2;
    
    %Get MLE for Rician fitting
    MLE_FF_Rician(reps,1)=outparams.Rician.MLE_FF;
    
    
end


%Generate histogram for FF
figure('name',strcat('FF Estimates for FF= ',num2str(FF),'  R2*= ',num2str(v)))

subplot(2,2,1)
histogram(fittedFF_mag,[0:2:100])
title(strcat('Standard fitting estimates, ground truth FF =  ',num2str(FF),'  R2*= ',num2str(v)))
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

subplot(2,2,2)
histogram(fittedFF_Ric,[0:2:100])
title(strcat('Rician fitting estimates, ground truth FF =  ',num2str(FF),'  R2*= ',num2str(v)))
xticks([0 10 20 30 40 50 60 70 80 90 100]);
xticklabels({'0','10', '20', '30', '40', '50', '60', '70', '80', '90','100'});
xlabel('FF estimate','FontSize',12)
ylabel('Frequency of estimate','FontSize',12)
ylim(yl)
hold on
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
hold off
legend('Estimates','Ground truth')

subplot(2,2,3)
histogram( MLE_FF_standard,[0:2:100])
title(strcat('Gaussian MLE from grid search, ground truth FF =  ',num2str(FF),'  R2*= ',num2str(v)))
xticks([0 10 20 30 40 50 60 70 80 90 100]);
xticklabels({'0','10', '20', '30', '40', '50', '60', '70', '80', '90','100'});
xlabel('FF estimate','FontSize',12)
ylabel('Frequency of estimate','FontSize',12)
yl=1.5*ylim;%get y limit from histogram, then..
ylim(yl)
hold on
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
hold off
legend('Estimates','Ground truth')

subplot(2,2,4)
histogram(MLE_FF_Rician,[0:2:100])
title(strcat('Rician MLE from grid search, ground truth FF =  ',num2str(FF),'  R2*= ',num2str(v)))
xticks([0 10 20 30 40 50 60 70 80 90 100]);
xticklabels({'0','10', '20', '30', '40', '50', '60', '70', '80', '90','100'});
xlabel('FF estimate','FontSize',12)
ylabel('Frequency of estimate','FontSize',12)
ylim(yl)
hold on
plot([FF FF],[yl(1) yl(2)],'LineWidth',2,'color','red','Linestyle','--') %..add ground truth as line
hold off
legend('Estimates','Ground truth')



%Generate likelihood difference plot
figure

s1=subplot(1,2,1)
scatter(fittedFF_mag,likdiff_mag)
set(s1,'YGrid','on')
title('Standard magnitude fitting')
ylabel('min1 - min2 (water dominant vs fat dominant, SSE from fit)','FontSize',12)

s2=subplot(1,2,2)
scatter(fittedFF_Ric,likdiff_Ric)
set(s2,'YGrid','on')
title('Rician fitting')
ylabel('min1 - min2 (water dominant vs fat dominant, negative likelihood from fit)','FontSize',12)

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
