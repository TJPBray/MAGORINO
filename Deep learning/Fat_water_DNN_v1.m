%% Fat-water deep neural network (DNN) w/ Matlab Deep Learning Toolbox
%
% Version 1: Larger network, ground truth labels
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

% extract the validation set
xValidation = S(idxValidation,:);
yValidation = trainingParams(idxValidation,:);



%% 3.0 Build a minimal DNN

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

%% 4.0 Set up the training options

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

% include the validation data
options.ValidationData = {xValidation, yValidation};

%% 5.0 Training

% fix the random seed to ease comparison across multiple setups
rng(5);

% run the training
%
% Note that this function sets up and initialises the layers, including its
% learnable parameters, before proceeding to the actual training
%
% The initialisation of learnable parameters occurs in the class
% TrainingNetworkAssembler within the function assemble
%
net = trainNetwork(xTrain, yTrain, layers, options);


%% 6.0 Visualise predicted values vs ground truth (use all data to ease visualisation)

%Get prediction for all simulated values
predictionVec=net.predict(S);
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
view(0,90)

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
view(0,90)


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
view(0,90)

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
view(0,90)

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