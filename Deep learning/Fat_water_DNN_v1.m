%% Fat-water deep neural network (DNN) w/ Matlab Deep Learning Toolbox
%
% Version 1: Larger network, ground truth labels
%

%% 1.0 Synthesise training/validation data using multipeak fat model 

rng(2)

% 1.1 First try uniformly spaced samples over the parameter space (vary
% both FF and R2*)

%Specify dataset size
s=1000;

% Specify S0 (au)
S0 = 1;

%Specify ff and R2* range
r2range = [0 0.5];

% 1.2 Specify whether to use single range of ff values or dual range
dualRange = 0;

if dualRange == 0

    % ffRange = [0 1];
    ffRange = [0 1];
    FFvec=ffRange(1) + (ffRange(2)-ffRange(1))*rand(s,1);

elseif dualRange == 1

    ffRange = [0 0.53];
    FFvec=ffRange(1) + (ffRange(2)-ffRange(1))*rand(s/2,1);

    ffRange2 = [0.73 1];
    FFvec2 = ffRange2(1) + (ffRange2(2)-ffRange2(1))*rand(s/2,1);

    FFvec = vertcat(FFvec,FFvec2);

else ;
end

Fvec=S0*FFvec;
Wvec=S0-Fvec;
R2starvec=r2range(2)*rand(s,1);

%Concatenate vectors chosen for training
trainingParams=horzcat(FFvec,R2starvec);

%Define fB
fB = 0;

%Set echotimes
echotimes=[1.1:1.1:13.2]';

% (normalised) signal samples
sNoiseFree = MultiPeakFatSingleR2(echotimes,3,Fvec,Wvec,R2starvec,fB);

% Generate noise-free training data
Sreal = real(sNoiseFree);
Simag = imag(sNoiseFree);

sCompNoiseFree = horzcat(Sreal,Simag);
sMagNoiseFree = abs(sNoiseFree);

%Create noise
SNR=70;
noiseSD=1/SNR;

realnoise=(noiseSD)*randn(s,numel(echotimes));
imagnoise=1i*(noiseSD)*randn(s,numel(echotimes));

% Add noise to signal to create noisy signal
sCompNoisy = sNoiseFree + realnoise + imagnoise; 

%Get noise magnitude data
sMagNoisy=abs(sCompNoisy);

%Reformat complex data for DL
sCompNoisy = horzcat(real(sCompNoisy),imag(sCompNoisy));

%Choose which data to use for training
S = sMagNoiseFree;

%% 2.0 Split synthesised data into the training and validation set
%
% This is now done with matlab's built-in cvpartition tool set.  Initially,
% used setdiff, which orders the data by default.  This ends up corrupting
% the association between the input and the output set.  This could be
% fixed with using the 'stable' option of setdiff.

%2.1 Create randomly spaced training and validation datasets

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

% create a separate test set with values on a grid 

%% 3.  Create test dataset with constant spacing of FF values and R2* values (to add visualisation)
%Select values
S0=1;
FFvals = (0:0.01:1)';
R2vals = (0:(0.05*r2range(2)):r2range(2));

%Call helper function (sVecFixedSpacing) to generate vectors of values with
%fixed spacing
[paramVec, sVec] = sVecFixedSpacing(S0,FFvals,R2vals);

%Create noise
realnoise=(noiseSD)*randn(size(sVec,1),numel(echotimes));
imagnoise=1i*(noiseSD)*randn(size(sVec,1),numel(echotimes));

%Add noise to signal 
% rng(3)
% sVec = sVec + realnoise + imagnoise;

%Use these vectors to create test dataset
yTest = paramVec;

%Magnitude
xTest = abs(sVec);

% Complex
% xTest = horzcat(real(sVec),imag(sVec));

%% 3.0 Build a minimal DNN

% number of features
numOfFeatures = size(S,2);

% name of the input
inputName = 'Signal';

% number of output
numOfOutput = 2;

% name of the output
outputName = 'FF R2*';

% create the layers, including relu layer
layers = [
    featureInputLayer(numOfFeatures, 'Name', inputName);
    fullyConnectedLayer(numOfFeatures, 'Name', 'fc1');
    fullyConnectedLayer(numOfFeatures, 'Name', 'fc2');
    fullyConnectedLayer(numOfFeatures, 'Name', 'fc3');
    fullyConnectedLayer(numOfFeatures, 'Name', 'fc4');
    fullyConnectedLayer(numOfOutput, 'Name', 'fc5');
    regressionLayer('Name', outputName);
    ];

% layers = [
%     featureInputLayer(numOfFeatures, 'Name', inputName);
%     fullyConnectedLayer(numOfOutput, 'Name', 'fc1');
%     regressionLayer('Name', outputName);
%     ];

% number of layers
numOfLayers = size(layers, 1);

% visualise the layers
analyzeNetwork(layers)

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
    'Plots','training-progress'); %No regularisation as low FF values should not be preferred

% include the validation data
options.ValidationData = {xValidation, yValidation};

%% 5.0 Training

% fix the random seed to ease comparison across multiple setups
rng(1);

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
predictionVec=net.predict(xTest);
predictionVecFF=predictionVec(:,1);
predictionVecR2=predictionVec(:,2);


%Get errorgrids
ffErrorVec=predictionVecFF-yTest(:,1);
r2ErrorVec=predictionVecR2-yTest(:,2);

% Reshape prediction data for plotting
ffPredictions = reshape(predictionVecFF,[numel(FFvals) numel(R2vals)]);
r2Predictions = reshape(predictionVecR2,[numel(FFvals) numel(R2vals)]);
ffError = reshape(ffErrorVec,[numel(FFvals) numel(R2vals)]);
r2Error = reshape(r2ErrorVec,[numel(FFvals) numel(R2vals)]);

%Plot 

figure('Name', 'FF')

subplot(2,2,1)
image(ffPredictions,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
colorbar
xticks([1:2:21]);
xticklabels({'0','.05', '.1', '.15', '.2', '.25', '.3', '.35', '.4', '.45','.5'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([0 10 20 30 40 50 60 70 80 90 100]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('FF values')
colorbar
view(0,90)


subplot(2,2,2)
image(r2Predictions,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
colorbar
xticks([1:2:21]);
xticklabels({'0','.05', '.1', '.15', '.2', '.25', '.3', '.35', '.4', '.45','.5'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([0 10 20 30 40 50 60 70 80 90 100]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('R2* values')
colorbar
view(0,90)

subplot(2,2,3)
image(ffError,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-0.1 0.1];
FigLabels;
colorbar
xticks([1:2:21]);
xticklabels({'0','.05', '.1', '.15', '.2', '.25', '.3', '.35', '.4', '.45','.5'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([0 10 20 30 40 50 60 70 80 90 100]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('FF error')
colorbar
view(0,90)

subplot(2,2,4)
image(r2Error,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-0.1 0.1];
FigLabels;
colorbar
xticks([1:2:21]);
xticklabels({'0','.05', '.1', '.15', '.2', '.25', '.3', '.35', '.4', '.45','.5'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([0 10 20 30 40 50 60 70 80 90 100]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('R2* error')
colorbar
view(0,90)


%%  Plot for random values 
% 
% tri=delaunay(yTest(:,2),yTest(:,1));
% 
% s1=subplot(3,2,3)
% trisurf(tri,yTest(:,2),yTest(:,1),predictionVecFF,'LineStyle','none');
% ax=gca;
% ax.CLim=[0 1];
% xticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
% xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
% xlabel('R2* (ms^-^1)','FontSize',12)
% yticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
% yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
% ylabel('Fat fraction (%)','FontSize',12)
% title('FF values')
% colorbar
% view(0,90)
% 
% s1=subplot(3,2,4)
% trisurf(tri,yTest(:,2),yTest(:,1),predictionVecR2,'LineStyle','none');
% ax=gca;
% ax.CLim=[-1 1];
% xticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
% xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
% xlabel('R2* (ms^-^1)','FontSize',12)
% yticks([0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0]);
% yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
% ylabel('Fat fraction (%)','FontSize',12)
% title('R2* values')
% colorbar
% view(0,90)
% 
% 
% s1=subplot(3,2,5)
% trisurf(tri,yTest(:,2),yTest(:,1),FFerrorVec,'LineStyle','none');
% ax=gca;
% ax.CLim=[-1 1];
% xticks([1 2 3 4 5 6 7 8 9 10 11]);
% xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
% xlabel('R2* (ms^-^1)','FontSize',12)
% yticks([1 6 11 16 21 26 31 36 41 46 51]);
% yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
% ylabel('Fat fraction (%)','FontSize',12)
% title('FF error')
% colorbar
% view(0,90)
% 
% s1=subplot(3,2,6)
% trisurf(tri,yTest(:,2),yTest(:,1),R2starErrorVec,'LineStyle','none');
% ax=gca;
% ax.CLim=[-1 1];
% xticks([1 2 3 4 5 6 7 8 9 10 11]);
% xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
% xlabel('R2* (ms^-^1)','FontSize',12)
% yticks([1 6 11 16 21 26 31 36 41 46 51]);
% yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
% ylabel('Fat fraction (%)','FontSize',12)
% title('R2* error')
% colorbar
% view(0,90)

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