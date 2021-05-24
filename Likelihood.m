%Visualise likelihood

function [outparams] = Likelihood(FF,v,figshow)

%% Specify parametersfor signal simulation

%Set parameters depending on specified FF
p = [FF 100-FF v 0];

%  Specify echotime values
% MAGO paper at 3T used 12 echoes (TE1 1.1, dTE 1.1)
% MAGO paper at 1.5T used 6 echoes (TE1 1.2, dTE 2)
echotimes=1.1:1.1:13.2;

%Specify field strength
tesla=3;

%% Specify SNR
% Define noise parameters (NB MAGO paper reports typical SNR in vivo of 40
% at 1.5T and 60 at 3T. However, may be lower in the presence of iron or
% marrow. The SNR is a function input. 

SNR=100;

noiseSD=100/SNR; %here assume total signal is 100 for simplicity (since FF maps are used as input)


%% Simulate signal
Smeasured=Fatfunction(echotimes,tesla,p(1),p(2),p(3),p(4));

%% Add noise
Snoisy = Smeasured + normrnd(0,noiseSD,[1 numel(echotimes)]) + i*normrnd(0,noiseSD,[1 numel(echotimes)]);

% Snoisy = abs(Snoisy);

%% Calculate likelihood for values

% Create grid of parameter combinations
vgrid=repelem(0:0.01:1,101,1); %1ms-1 upper limit chosen to reflect Hernando et al. (went up to 1.2)
Fgrid=repelem([0:1:100]',1,101);
Wgrid=100-Fgrid;

%Loop through combinations

for y=1:size(Fgrid,1)
    for x=1:size(Fgrid,2)
        
        phat(1)=Fgrid(y,x);
        phat(2)=Wgrid(y,x);
        phat(3)=vgrid(y,x);
        phat(4)=0;
        
        loglikRic(y,x) = R2RicianObj(phat,echotimes,tesla,Snoisy,noiseSD);
        SSE(y,x)= R2Obj(phat,echotimes,tesla,Snoisy);
        loglikMag(y,x)=-numel(echotimes)*log(sqrt(2*pi*noiseSD*noiseSD))-SSE(y,x)/(2*noiseSD^2);
    end
end

%% Find maximum likelihood

%For Rician
[max1,ind1] = max(loglikRic,[],'all','linear');
[row1,col1]=find(loglikRic==max1);

%For SSE
[max2,ind2] = max(loglikMag,[],'all','linear');
[row2,col2]=find(loglikMag==max2);


%% Fit simulated signal

%Perform fitting
outparams = R2fitting (echotimes, tesla, Snoisy, noiseSD);

%Find coords for fat fraction and R2*
%Standard
outFF=100*outparams.standard.F/(outparams.standard.F+outparams.standard.W);
outR2=100*outparams.standard.R2;

%Rician
outFFric=100*outparams.Rician.F/(outparams.Rician.F+outparams.Rician.W);
outR2ric=100*outparams.Rician.R2;


%Find pmin1
%For standard magnitude
pmin1S_ydim=100*outparams.standard.pmin1(1)/(outparams.standard.pmin1(2)+outparams.standard.pmin1(1)); %calculates FF value from pmin
pmin1S_xdim=100*outparams.standard.pmin1(3); %calculates R2* value from pmin

%For Rician
%For standard magnitude
pmin1R_ydim=100*outparams.Rician.pmin1(1)/(outparams.Rician.pmin1(2)+outparams.Rician.pmin1(1)); %calculates FF value from pmin
pmin1R_xdim=100*outparams.Rician.pmin1(3); %calculates R2* value from pmin

%Find pmin2
%For standard magnitude
pmin2S_ydim=100*outparams.standard.pmin2(1)/(outparams.standard.pmin2(2)+outparams.standard.pmin2(1)); %calculates FF value from pmin
pmin2S_xdim=100*outparams.standard.pmin2(3); %calculates R2* value from pmin

%For Rician
pmin2R_ydim=100*outparams.Rician.pmin2(1)/(outparams.Rician.pmin2(2)+outparams.Rician.pmin2(1)); %calculates FF value from pmin
pmin2R_xdim=100*outparams.Rician.pmin2(3); %calculates R2* value from pmin

disp(outparams.standard)
disp(outparams.Rician)
disp(outparams.complex)

%% Add MLE from grid to output structure
outparams.Rician.MLE_v=col1;
outparams.Rician.MLE_FF=row1;
outparams.standard.MLE_v=col2;
outparams.standard.MLE_FF=row2;

%% Plot
% figshow=0;

if figshow==1

% Plot noisy data
figure
plot(echotimes, abs(Snoisy)); %plot magnitude only 

hold on 

%Plot ground truth data
plot(echotimes, abs(Smeasured), 'Linewidth',3); %plot magnitude only 

%Plot noiseless fits
% plot(echotimes, abs(Fatfunction(echotimes,outparams_noiseless.standard.F,outparams_noiseless.standard.W,outparams_noiseless.standard.R2,0)),'Linewidth',3, 'Linestyle','--')

%Plot for standard fitting
plot(echotimes, abs(Fatfunction(echotimes,tesla,outparams.standard.F,outparams.standard.W,outparams.standard.R2,0)),'Linewidth',3)

%Plot for fitting with Rician noise modelling
%Plot for standard fitting
plot(echotimes, abs(Fatfunction(echotimes,tesla,outparams.Rician.F,outparams.Rician.W,outparams.Rician.R2,0)),'Linewidth',3)

%Plot for complex fitting
plot(echotimes, abs(Fatfunction(echotimes,tesla,outparams.complex.F,outparams.complex.W,outparams.complex.R2,0)),'Linewidth',3)

%% Add legend
legend('Noisy data', 'Ground truth', 'Standard magnitude fitting', 'Rician magnitude fitting', 'Complex fitting')
ax=gca;
ax.FontSize=14;
xlabel('Echo Time (ms)');
ylabel('Signal');




%% Display likelihood

%First convert SSE to loglikelihood for viewing on similar scales (NB first
%time is constant so can be excluded)
% loglikMag= -numel(echotimes)*log(sqrt(2*pi*noiseSD*noiseSD))-SSE./(2*noiseSD^2);
% This is now done higher up

% A = A( ~any( isnan( A ) | isinf( A ), 2 ),: )
%Display
figure

subplot(1,2,1)
% image(abs(loglikMag),'CDataMapping','scaled')
imshow(loglikMag,[10*max(loglikMag,[],'all') 0])

% ax.CLim=[];
axis on
xticks([1 11 21 31 41 51 61 71 81 91 101]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title(strcat('Standard: Log likelihood for true FF =  ',num2str(p(1)),', and true R2star =  ', num2str(p(3))))
colorbar
hold on
% contour(loglikMag,[10*max(loglikMag,[],'all'):-max(loglikMag,[],'all'):0],'red')
colormap('parula')

% Add MLE
plot(col2,row2,'kd','MarkerFaceColor','black','MarkerSize',12,'LineWidth',2) %NB

%Add ground truth
plot(100*v+1,FF+1,'rd','MarkerFaceColor','white','MarkerSize',12,'LineWidth',2)

%Add two candidate solutions from fitting
plot(pmin1S_xdim+1,pmin1S_ydim+1,'rx','MarkerSize',12,'LineWidth',2)
plot(pmin2S_xdim+1,pmin2S_ydim+1,'rx','MarkerSize',12,'LineWidth',2)

%Add solution from fitting
plot(outR2+1,outFF+1,'ro','MarkerSize',12,'LineWidth',2) %NB

%Add legend
lgnd=legend('contour','MLE', 'GT', 'min1', 'min2', 'Fit output');
set(lgnd,'color','none');
hold off


subplot(1,2,2)
% image(exp(loglikRic),'CDataMapping','scaled')
imshow(loglikRic,[10*max(loglikRic,[],'all') 0])
ax=gca;
% ax.CLim=[];
axis on
xticks([1 11 21 31 41 51 61 71 81 91 101]);
xticklabels({'0','0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title(strcat('Rician: Log likelihood for true FF =  ',num2str(p(1)),', and true R2star =  ', num2str(p(3))))
colorbar
hold on
% contour(loglikRic,[10*max(loglikRic,[],'all'):-max(loglikRic,[],'all'):0],'red')
colormap('parula')
%Plot MLE
plot(col1,row1,'kd','MarkerFaceColor','black','MarkerSize',12,'LineWidth',2) 

%Add ground truth
plot(100*v+1,FF+1,'rd','MarkerFaceColor','white','MarkerSize',12,'LineWidth',2)

%Add two candidate solutions from fitting
plot(pmin1R_xdim+1,pmin1R_ydim+1,'rx','MarkerSize',12,'LineWidth',2)
plot(pmin2R_xdim+1,pmin2R_ydim+1,'rx','MarkerSize',12,'LineWidth',2)

%Add solution from fitting
plot(outR2ric+1,outFFric+1,'ro','MarkerSize',12,'LineWidth',2) %NB

%Add legend
lgnd=legend('contour','MLE', 'GT', 'min1', 'min2', 'Fit output');
set(lgnd,'color','none');

hold off

else ;
end

