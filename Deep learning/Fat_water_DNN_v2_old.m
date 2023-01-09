%% Fat-water deep neural network (DNN) w/ Matlab Deep Learning Toolbox
%
% Version 2: Larger network, train on MLE labels from MAGORINO
%

%% 1.0 Synthesise training/validation data using multipeak fat model 

% 1.1 First try uniformly spaced samples over the parameter space (vary
% both FF and R2*)

%Specify dataset size
s=1000;

% S0 (au)
S0 = 1;

rng(2)

FFvec=rand(s,1);
Fvec=S0*FFvec;
Wvec=S0-Fvec;
R2starvec=0.5*rand(s,1);

%Concatenate vectors chosen for training
trainingParams=horzcat(FFvec,R2starvec);

%Define fB
fB = 0;

%Set echotimes
echotimes=[1.1:1.1:13.2]';

%Set field strength
tesla=3;

% (normalised) signal samples
Snoisefree = MultiPeakFatSingleR2(echotimes,3,Fvec,Wvec,R2starvec,fB);

%Create noise
SNR=60;
noiseSD=1/SNR;

realnoise=(noiseSD)*randn(s,numel(echotimes));
imagnoise=1i*(noiseSD)*randn(s,numel(echotimes));

% Create noisy signal
S = Snoisefree + realnoise + imagnoise; 

% Use magnitude for now 
S=abs(S);

%% 3.0 Find MLE values using MAGORINO to provide alternative labels (note that in some cases the MLE is a swapped value)

GT.p = [0 0 0 0];
GT.S= zeros(numel(echotimes));

parfor k=1:s 
    outparams = R2fitting (echotimes, 3, S(k,:), noiseSD, GT)

%3.1 Get MLE estimates of FF and R2star from fit
    mleFF(k,1)=outparams.Rician.F/(outparams.Rician.F+outparams.Rician.W);
    mleR2star(k,1)=outparams.Rician.R2;

%3.2 Also get water-dominant solution and fat-dominant solution

%Water dominant solution (pmin1): 
pmin1FF(k,1)=outparams.Rician.pmin1(1)/(outparams.Rician.pmin1(1)+outparams.Rician.pmin1(2));
pmin1R2(k,1)=outparams.Rician.pmin1(3);

%Fat dominant solution (pmin2): 
pmin2FF(k,1)=outparams.Rician.pmin2(1)/(outparams.Rician.pmin2(1)+outparams.Rician.pmin2(2));
pmin2R2(k,1)=outparams.Rician.pmin2(3);

end

%3.3 Specify potential training vectors

trainingParamsMLE=horzcat(mleFF,mleR2star);

trainingParamspmin1=horzcat(pmin1FF,pmin1R2);

trainingParamspmin2=horzcat(pmin2FF,pmin2R2);

%Visualise mle values against ground truth

figure
subplot(3,2,1)
scatter(FFvec,mleFF)
title('Ground truth FF vs mleFF')

subplot(3,2,2)
scatter(R2starvec,mleR2star)
title('Ground truth R2star vs mleR2star')

subplot(3,2,3)
scatter(FFvec,pmin1FF)
title('Ground truth FF vs pmin1 FF')

subplot(3,2,4)
scatter(R2starvec,pmin1R2)
title('Ground truth FF vs pmin1 R2')

subplot(3,2,5)
scatter(FFvec,pmin2FF)
title('Ground truth FF vs pmin2 FF')

subplot(3,2,6)
scatter(R2starvec,pmin2R2)
title('Ground truth R2 vs pmin2 R2')

%% 2.0 Split synthesised data into the training and validation set
%
% This is now done with matlab's built-in cvpartition tool set.  Initially,
% used setdiff, which orders the data by default.  This ends up corrupting
% the association between the input and the output set.  This could be
% fixed with using the 'stable' option of setdiff.

% percentage of the data to be held out as validation
hPercentage = 0.2;

% fix the random seed to ease comparison across multiple setups
rng(3);

% use matlab's built-in cvpartition
hPartition = cvpartition(s, 'Holdout', hPercentage);

% get indices of the training and validation set
idxTrain = training(hPartition);
idxValidation = test(hPartition);

% extract the training set
xTrain = S(idxTrain,:);
yTrain = trainingParams(idxTrain,:);
yTrainMLE = trainingParamsMLE(idxTrain,:);
yTrainpmin1 = trainingParamspmin1(idxTrain,:);
yTrainpmin2 = trainingParamspmin2(idxTrain,:);

% extract the validation set
xValidation = S(idxValidation,:);
yValidation = trainingParams(idxValidation,:);
yValidationMLE = trainingParamsMLE(idxValidation,:);
yValidationpmin1 = trainingParamspmin1(idxValidation,:);
yValidationpmin2 = trainingParamspmin2(idxValidation,:);

%% 4.0 Build a minimal DNN

% number of features
numOfFeatures = numel(echotimes);

% name of the input
inputName = 'Signal';

% number of output
numOfOutput = 2;

% name of the output
outputName = 'FF R2*';

% create the layers, including relu layer
layers = [
    featureInputLayer(numOfFeatures, 'Name', inputName);
    fullyConnectedLayer(numOfOutput, 'Name', 'fc1');
    fullyConnectedLayer(numOfOutput, 'Name', 'fc2');
    fullyConnectedLayer(numOfOutput, 'Name', 'fc3');
    fullyConnectedLayer(numOfOutput, 'Name', 'fc4');
    fullyConnectedLayer(numOfOutput, 'Name', 'fc5');
    fullyConnectedLayer(numOfOutput, 'Name', 'fc6');
    fullyConnectedLayer(numOfOutput, 'Name', 'fc7');
    regressionLayer('Name', outputName);
    ];

% number of layers
numOfLayers = size(layers, 1);

% visualise the layers
figure; plot(layerGraph(layers));

%% 5.0 Set up the training options

% set up the training options with Stochastic Gradient Descent
%
% mini-batch size changed from default (128) to 64
%
% Note that Matlab implementation appears to discard the last few training
% samples that do not completely fill up a mini-batch.
%
options = trainingOptions('sgdm', ...
    'MaxEpochs',2000, ...
    'InitialLearnRate',1e-2, ...
    'MiniBatchSize', 100, ...
    'Verbose',false, ...
    'Plots','training-progress',...
    'L2Regularization',0); %No regularisation as low FF values should not be preferred




%% 6 Training

% fix the random seed to ease comparison across multiple setups
rng(5);

% 6.0 Train on MLE from MAGORINO

% include the validation data
options.ValidationData = {xValidation, yValidationMLE};  %Try training and validation on results from one MAGORINO initialisation only

% run the training
net0 = trainNetwork(xTrain, yTrainMLE, layers, options);
% Note that this function sets up and initialises the layers, including its
% learnable parameters, before proceeding to the actual training
%
% The initialisation of learnable parameters occurs in the class
% TrainingNetworkAssembler within the function assemble


% 6.1 First train on water-dominant solutions (pmin1)

% include the validation data
options.ValidationData = {xValidation, yValidationpmin1};  %Try training and validation on results from one MAGORINO initialisation only

% run the training
net1 = trainNetwork(xTrain, yTrainpmin1, layers, options);
% Note that this function sets up and initialises the layers, including its
% learnable parameters, before proceeding to the actual training
%
% The initialisation of learnable parameters occurs in the class
% TrainingNetworkAssembler within the function assemble

% 6.2 First train on fat-dominant solutions (pmin2)

% include the validation data
options.ValidationData = {xValidation, yValidationpmin2};  %Try training and validation on results from one MAGORINO initialisation only

% run the training
net2 = trainNetwork(xTrain, yTrainpmin2, layers, options);
% Note that this function sets up and initialises the layers, including its
% learnable parameters, before proceeding to the actual training
%
% The initialisation of learnable parameters occurs in the class
% TrainingNetworkAssembler within the function assemble



%% 7.0 Visualise predicted values vs ground truth (use all data to ease visualisation)


%7.1 Predictions for net 0 (MLE training):
% Get prediction for all simulated values
predictionVec=net0.predict(S);
predictionVecFF=predictionVec(:,1);
predictionVecR2=predictionVec(:,2);

%Get errorgrids
FFerrorVec=predictionVecFF-FFvec;
R2starErrorVec=predictionVecR2-R2starvec;

figure('Name', 'FF')

% subplot(3,2,1)
% for k = 1:(size(Fgrid,2))
% scatter(FFgrid(:,k),predictionFFgrid(:,k))
% hold on
% end
% hold off
% legend
% 
% subplot(3,2,2)
% for k = 1:(size(R2stargrid,1))
% scatter(R2stargrid(k,:),predictionR2grid(k,:))
% hold on
% end
% hold off
% legend


tri=delaunay(R2starvec,FFvec);

s1=subplot(3,2,3)
trisurf(tri,R2starvec,FFvec,predictionVecFF,'LineStyle','none');
ax=gca;
ax.CLim=[0 1];
xticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('FF values')
colorbar
view(0,270)


s1=subplot(3,2,4)
trisurf(tri,R2starvec,FFvec,predictionVecR2,'LineStyle','none');
ax=gca;
ax.CLim=[-1 1];
xticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('R2* values')
colorbar
view(0,270)


s1=subplot(3,2,5)
trisurf(tri,R2starvec,FFvec,FFerrorVec,'LineStyle','none');
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('FF error')
colorbar
view(0,270)

s1=subplot(3,2,6)
trisurf(tri,R2starvec,FFvec,R2starErrorVec,'LineStyle','none');
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('R2* error')
colorbar
view(0,270)


%7.2 Predictions for net 1 (water dominant solution training):
% Get prediction for all simulated values
predictionVec=net1.predict(S);
predictionVecFF=predictionVec(:,1);
predictionVecR2=predictionVec(:,2);

%Get errorgrids
FFerrorVec=predictionVecFF-FFvec;
R2starErrorVec=predictionVecR2-R2starvec;

figure('Name', 'FF')

% subplot(3,2,1)
% for k = 1:(size(Fgrid,2))
% scatter(FFgrid(:,k),predictionFFgrid(:,k))
% hold on
% end
% hold off
% legend
% 
% subplot(3,2,2)
% for k = 1:(size(R2stargrid,1))
% scatter(R2stargrid(k,:),predictionR2grid(k,:))
% hold on
% end
% hold off
% legend


tri=delaunay(R2starvec,FFvec);

s1=subplot(3,2,3)
trisurf(tri,R2starvec,FFvec,predictionVecFF,'LineStyle','none');
ax=gca;
ax.CLim=[0 1];
xticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('FF values')
colorbar
view(0,270)


s1=subplot(3,2,4)
trisurf(tri,R2starvec,FFvec,predictionVecR2,'LineStyle','none');
ax=gca;
ax.CLim=[-1 1];
xticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('R2* values')
colorbar
view(0,270)


s1=subplot(3,2,5)
trisurf(tri,R2starvec,FFvec,FFerrorVec,'LineStyle','none');
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('FF error')
colorbar
view(0,270)

s1=subplot(3,2,6)
trisurf(tri,R2starvec,FFvec,R2starErrorVec,'LineStyle','none');
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('R2* error')
colorbar
view(0,270)

%7.3  Predictions for net2 (pmin2, i.e. fat dominant solution training)
% Get prediction for all simulated values
predictionVec=net2.predict(S);
predictionVecFF=predictionVec(:,1);
predictionVecR2=predictionVec(:,2);

%Get errorgrids
FFerrorVec=predictionVecFF-FFvec;
R2starErrorVec=predictionVecR2-R2starvec;

figure('Name', 'FF')

% subplot(3,2,1)
% for k = 1:(size(Fgrid,2))
% scatter(FFgrid(:,k),predictionFFgrid(:,k))
% hold on
% end
% hold off
% legend
% 
% subplot(3,2,2)
% for k = 1:(size(R2stargrid,1))
% scatter(R2stargrid(k,:),predictionR2grid(k,:))
% hold on
% end
% hold off
% legend


tri=delaunay(R2starvec,FFvec);

s1=subplot(3,2,3)
trisurf(tri,R2starvec,FFvec,predictionVecFF,'LineStyle','none');
ax=gca;
ax.CLim=[0 1];
xticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('FF values')
colorbar
view(0,270)


s1=subplot(3,2,4)
trisurf(tri,R2starvec,FFvec,predictionVecR2,'LineStyle','none');
ax=gca;
ax.CLim=[-1 1];
xticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('R2* values')
colorbar
view(0,270)


s1=subplot(3,2,5)
trisurf(tri,R2starvec,FFvec,FFerrorVec,'LineStyle','none');
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('FF error')
colorbar
view(0,270)

s1=subplot(3,2,6)
trisurf(tri,R2starvec,FFvec,R2starErrorVec,'LineStyle','none');
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('R2* error')
colorbar
view(0,270)

%7.4  Choose prediction from either net1 (water-dominant solution training)
%or net2 (fat-dominant solution training) depending on SSE

%Net1
predictionVec1=net1.predict(S);
[likVec1,sseVec1] = sseVecCalc (echotimes, tesla, predictionVec1, S, noiseSD);

%Net2
predictionVec2=net2.predict(S);
[likVec2,sseVec2] = sseVecCalc (echotimes, tesla, predictionVec2, S, noiseSD);

%Create binary vector to choose
choiceVec=(sseVec1<sseVec2)';

%Create predictionVec with best likelihood estimates:
predictionVec = choiceVec.*predictionVec1 + (1-choiceVec).*predictionVec2;

predictionVecFF=predictionVec(:,1);
predictionVecR2=predictionVec(:,2);

%Get errorgrids
FFerrorVec=predictionVecFF-FFvec;
R2starErrorVec=predictionVecR2-R2starvec;

figure('Name', 'FF')

% subplot(3,2,1)
% for k = 1:(size(Fgrid,2))
% scatter(FFgrid(:,k),predictionFFgrid(:,k))
% hold on
% end
% hold off
% legend
% 
% subplot(3,2,2)
% for k = 1:(size(R2stargrid,1))
% scatter(R2stargrid(k,:),predictionR2grid(k,:))
% hold on
% end
% hold off
% legend


tri=delaunay(R2starvec,FFvec);

s1=subplot(3,2,3)
trisurf(tri,R2starvec,FFvec,predictionVecFF,'LineStyle','none');
ax=gca;
ax.CLim=[0 1];
xticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('FF values')
colorbar
view(0,270)


s1=subplot(3,2,4)
trisurf(tri,R2starvec,FFvec,predictionVecR2,'LineStyle','none');
ax=gca;
ax.CLim=[-1 1];
xticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('R2* values')
colorbar
view(0,270)

s1=subplot(3,2,5)
trisurf(tri,R2starvec,FFvec,FFerrorVec,'LineStyle','none');
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('FF error')
colorbar
view(0,270)

s1=subplot(3,2,6)
trisurf(tri,R2starvec,FFvec,R2starErrorVec,'LineStyle','none');
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('R2* error')
colorbar
view(0,270)
%% 7.0 Inspect the trained network

% % layer index
% idxOfLayer = 2;
% 
% % weight(s) and bias of a layer
% net.Layers(idxOfLayer)
% 
% % activation of a layer
% activations(net, xTrain, idxOfLayer)
% 
% % plot the activations
% figure;
% hold on;
% xlabel('Signal');
% ylabel('Activations');
% 
% % names of layers
% namesOfLayers = cell(numOfLayers,1);
% 
% for idxOfLayer = 1:numOfLayers
%     scatter(xTrain, activations(net, xTrain, idxOfLayer), '.');
%     namesOfLayers{idxOfLayer} = net.Layers(idxOfLayer).Name;
% end
% 
% legend(namesOfLayers);