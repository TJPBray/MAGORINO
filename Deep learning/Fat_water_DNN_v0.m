%% Fat-water deep neural network (DNN) w/ Matlab Deep Learning Toolbox
%
% Version 0: Small network, ground truth labels
%

%% 1.0 Synthesise training/validation data using multipeak fat model 

% 1.1 First try uniformly spaced samples over the parameter space

% fat fraction samples (0:1)
FF = (0:0.01:1)';

% number of samples
numOfSamples = length(FF);

% S0 (au)
S0 = 1;

% R2* (ms-1)
R2star=0;

% Define F and W
F=S0*FF;
W=S0*(1-FF);

%Define fB
fB = 0;

%Set echotimes
echotimes=[1.1:0.1:13.2]';

% (normalised) signal samples
S=MultiPeakFatSingleR2(echotimes,3,F,W,R2star,fB);

% Use magnitude for now 
S=abs(S);

%% 2.0 Split synthesised data into the training and validation set
%
% This is now done with matlab's built-in cvpartition tool set.  Initially,
% used setdiff, which orders the data by default.  This ends up corrupting
% the association between the input and the output set.  This could be
% fixed with using the 'stable' option of setdiff.
%

% percentage of the data to be held out as validation
hPercentage = 0.2;

% fix the random seed to ease comparison across multiple setups
rng(3);

% use matlab's built-in cvpartition
hPartition = cvpartition(numOfSamples, 'Holdout', hPercentage);

% get indices of the training and validation set
idxTrain = training(hPartition);
idxValidation = test(hPartition);

% extract the training set
xTrain = S(idxTrain,:);
yTrain = FF(idxTrain);

% extract the validation set
xValidation = S(idxValidation,:);
yValidation = FF(idxValidation);

%% 3.0 Build a minimal DNN

% number of features
numOfFeatures = numel(echotimes);

% name of the input
inputName = 'Signal';

% number of output
numOfOutput = 1;

% name of the output
outputName = 'FF';

% create the layers, including relu layer
layers = [
    featureInputLayer(numOfFeatures, 'Name', inputName);
    fullyConnectedLayer(numOfOutput, 'Name', 'fc1');
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
    'MiniBatchSize', 64, ...
    'Verbose',false, ...
    'Plots','training-progress');

% include the validation data
options.ValidationData = {xValidation, yValidation};

%% 5.0 Training

% fix the random seed to ease comparison across multiple setups
rng(3);

% run the training
%
% Note that this function sets up and initialises the layers, including its
% learnable parameters, before proceeding to the actual training
%
% The initialisation of learnable parameters occurs in the class
% TrainingNetworkAssembler within the function assemble
%
net = trainNetwork(xTrain, yTrain, layers, options);

%% 6.0 Visualise predicted values vs ground truth

figure;
scatter(yTrain, net.predict(xTrain));
xlabel('Ground truth FF');
ylabel('Predicted fat fraction');
hold on;
scatter(yTrain, yTrain, '.');
legend('Predicted FF','Ground truth FF');
ylim([-0.1 1.1])

figure;
scatter(yTrain, net.predict(xTrain));
xlabel('Ground truth FF');
ylabel('Predicted fat fraction');
hold on;
scatter(yTrain, yTrain, '.');
legend('Predicted FF','Ground truth FF');
ylim([-0.1 1.1])

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