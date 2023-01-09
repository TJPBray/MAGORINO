%% Fat-water deep neural network (DNN) w/ Matlab Deep Learning Toolbox
%
% v2 - try separate networks for high and low FF values
%

%% 1.0 Synthesise training/validation data using multipeak fat model 

rng(4)

%Specify dataset size
sz = 1000;

%Specify curtail factor to restrict R2* values (avoids ambiguity at higher
%R2* due to increased peak width) 
curtail = 1; %1 = no restriction of training range

%Specify dataset size for reduced dataset 
sz(2) = sz*curtail; 

% Create loop to enable training twice (with two different ffRanges)
for k = 1:2

% 1.1 First try uniformly spaced samples over the parameter space (vary
% both FF and R2*)

% Specify S0 (au)
S0 = 1;

%Specify field strength 
tesla = 3;

%Specify SNR
SNR=60;

% 1.2 Specify ff Range

    %If using two sets of values, specify switch point
    switchPoint = 0.63;
    ffRanges = [0 switchPoint; switchPoint 1];

    %Select range depending on value of k 
    ffRange = ffRanges(k,:);
    
    %Create vector of ff values
    FFvec=ffRange(1) + (ffRange(2)-ffRange(1))*rand(sz(k),1);


% 1.3 Specify R2* range
r2max=0.5;

    %If using two sets of values, specify switch point
    r2Ranges = [0 r2max; 0 curtail*r2max]; %Restrict high FF R2* values to plausible range

    %Select range depending on value of k 
    r2Range = r2Ranges(k,:);

    %Create vector of R2* values
    R2starvec=r2Range(2)*rand(sz(k),1);

%Specify F, W and R2* values
Fvec=S0*FFvec;
Wvec=S0-Fvec;

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
noiseSD=1/SNR;

realnoise=(noiseSD)*randn(sz(k),numel(echotimes));
imagnoise=1i*(noiseSD)*randn(sz(k),numel(echotimes));

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

% use matlab's built-in cvpartition
hPartition = cvpartition(sz(k), 'Holdout', hPercentage);

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

% Run the training

% Name networks according to the loop value (net1 for low FF training, net2
% for high FF training)
if k == 1
    net1 = trainNetwork(xTrain, yTrain, layers, options);

elseif k == 2
    net2 = trainNetwork(xTrain, yTrain, layers, options);

else ;
end


end %End loop over FF training range values

%% 6.  Create separate test dataset with constant spacing of FF values and R2* values (to aid visualisation)

%Select values for test dataset
r2max=0.5;

S0=1;
FFvals = (0:0.01:1)';
R2vals = (0:0.05*r2max:r2max);

%Select number of repetitions

%Call helper function (sVecFixedSpacing) to generate vectors of values with
%fixed spacing
[paramVec, sVecNoiseFree] = sVecFixedSpacing(S0,FFvals,R2vals);

%Create yTest parameter vector
yTest = paramVec;

%Loop over noise instantiations 

reps = 100;

for r = 1:reps

%Create noise
realnoise=(noiseSD)*randn(size(sVecNoiseFree,1),numel(echotimes));
imagnoise=1i*(noiseSD)*randn(size(sVecNoiseFree,1),numel(echotimes));

%Add noise to signal 
sVec = sVecNoiseFree + realnoise + imagnoise;

%Magnitude
xTest(:,:,r) = abs(sVec);

% Complex
% xTest(:,:,r) = horzcat(real(sVec),imag(sVec));

end

%% 7. Train a third network to choose between the first two
% 
% %7.1 Generate new training dataset with full range
% 
% ffRange = [0 1];
% FFvec=ffRange(1) + (ffRange(2)-ffRange(1))*rand(s,1);
% 
% %Specify F, W and R2* values
% Fvec=S0*FFvec;
% Wvec=S0-Fvec;
% R2starvec=max(r2Ranges,[],'all')*rand(s,1);
% 
% %Concatenate vectors chosen for training
% trainingParams=horzcat(FFvec,R2starvec);
% 
% %Define fB
% fB = 0;
% 
% %Set echotimes
% echotimes=[1.1:1.1:13.2]';
% 
% % (normalised) signal samples
% sNoiseFree = MultiPeakFatSingleR2(echotimes,3,Fvec,Wvec,R2starvec,fB);
% 
% % Generate noise-free training data
% Sreal = real(sNoiseFree);
% Simag = imag(sNoiseFree);
% 
% sCompNoiseFree = horzcat(Sreal,Simag);
% sMagNoiseFree = abs(sNoiseFree);
% 
% %Create noise
% SNR=60;
% noiseSD=1/SNR;
% 
% realnoise=(noiseSD)*randn(s,numel(echotimes));
% imagnoise=1i*(noiseSD)*randn(s,numel(echotimes));
% 
% % Add noise to signal to create noisy signal
% sCompNoisy = sNoiseFree + realnoise + imagnoise; 
% 
% %Get noise magnitude data
% sMagNoisy=abs(sCompNoisy);
% 
% %Reformat complex data for DL
% sCompNoisy = horzcat(real(sCompNoisy),imag(sCompNoisy));
% 
% %Choose which data to use for training
% S = sMagNoiseFree;
% 
% %7.1.2 Generate training and test datasets
% 
% % extract the training set
% xTrain = S;
% yTrain = trainingParams;
% 
% %7.2.1  Get net1 and net2 predictions for training data 
% 
% %Net1
% predictionVec1=net1.predict(xTrain);
% [likVec1,sseVec1] = sseVecCalc (echotimes, tesla, predictionVec1, xTrain, noiseSD);
% 
% %Net2
% predictionVec2=net2.predict(xTrain);
% [likVec2,sseVec2] = sseVecCalc (echotimes, tesla, predictionVec2, xTrain, noiseSD);
% 
% %Generate new xTrain to take the place of the signals
% xTrain2 = horzcat(sseVec1', sseVec2', predictionVec1, predictionVec2);
% 
% % 7.3 Build net3
% 
% % number of features
% numOfFeatures = size(xTrain2,2);
% 
% % number of output
% numOfOutput = 2;
% 
% % name of the output
% outputName = 'FF R2*';
% 
% % create the layers, including relu layer
% layers = [
%     featureInputLayer(numOfFeatures, 'Name', inputName);
%     fullyConnectedLayer(2*numOfFeatures, 'Name', 'fc1');
%     fullyConnectedLayer(2*numOfFeatures, 'Name', 'fc2');
%     fullyConnectedLayer(2*numOfFeatures, 'Name', 'fc3');
%     fullyConnectedLayer(2*numOfFeatures, 'Name', 'fc4');
%     fullyConnectedLayer(numOfOutput, 'Name', 'fc5');
%     regressionLayer('Name', outputName);
%     ];
% 
% % 7.4 Train net3
% 
% options = trainingOptions('sgdm', ...
%     'MaxEpochs',2000, ...
%     'InitialLearnRate',1e-2, ...
%     'MiniBatchSize', 100, ...
%     'Verbose',false, ...
%     'Plots','training-progress');
% 
% net3 = trainNetwork(xTrain2, yTrain, layers, options);
% 
% %Clear unwanted variables
% clear likVec1 likVec2 sseVec1 sseVec2 predictionVec1 predictionVec2


%% 8.  Generate prediction from either net1 (water-dominant solution training)
%or net2 (fat-dominant solution training) depending on SSE

%8.1 Get predictions

%Loop over noise instantiations
for r = 1:reps

%Net1
predictionVec1(:,:,r)=net1.predict(xTest(:,:,r));
[likVec1(:,:,r),sseVec1(:,:,r)] = sseVecCalc (echotimes, tesla, predictionVec1(:,:,r), xTest(:,:,r), noiseSD);

%Net2
predictionVec2(:,:,r)=net2.predict(xTest(:,:,r));
[likVec2(:,:,r),sseVec2(:,:,r)] = sseVecCalc (echotimes, tesla, predictionVec2(:,:,r), xTest(:,:,r), noiseSD);

%8.2 Create binary vector to choose between values
choiceVecRic(:,:,r)=(likVec1(:,:,r)>likVec2(:,:,r))';
choiceVecSSE(:,:,r)=(sseVec1(:,:,r)<sseVec2(:,:,r))';

choiceVec = choiceVecSSE;

%8.3 Create predictionVec with best likelihood estimates:
predictionVec3(:,:,r) = choiceVec(:,:,r).*predictionVec1(:,:,r) + (1-choiceVec(:,:,r)).*predictionVec2(:,:,r);

%8.4 Create predictionVec by using the third network 
% 
% xTest2(:,:,r) = horzcat(sseVec1(:,:,r)', sseVec2(:,:,r)', predictionVec1(:,:,r), predictionVec2(:,:,r));
% 
% predictionVec4(:,:,r) = net3.predict(xTest2(:,:,r));

end


%% 9. Visualise predicted values vs ground truth (use all data to ease visualisation)

dispSl = 1;

createFigDL(predictionVec1(:,:,dispSl), yTest,FFvals,R2vals, 'Low FF net, mean values');
createFigDL(predictionVec2(:,:,dispSl), yTest,FFvals,R2vals, 'High FF net, mean values');
createFigDL(predictionVec3(:,:,dispSl), yTest,FFvals,R2vals,'Likelihood combined nets, mean values');
% createFigDL(predictionVec4(:,:,dispSl), yTest,FFvals,R2vals,'Third network, mean values');

createFigDL(mean(predictionVec1,3), yTest,FFvals,R2vals, 'Low FF net, mean values');
createFigDL(mean(predictionVec2,3), yTest,FFvals,R2vals, 'High FF net, mean values');
createFigDL(mean(predictionVec3,3), yTest,FFvals,R2vals,'Likelihood combined nets, mean values');
% createFigDL(mean(predictionVec4,3), yTest,FFvals,R2vals,'Third network, mean values');

createFigDL(std(predictionVec1,0,3), yTest,FFvals,R2vals, 'Low FF net, std');
createFigDL(std(predictionVec2,0,3), yTest,FFvals,R2vals, 'High FF net, std');
createFigDL(std(predictionVec3,0,3), yTest,FFvals,R2vals,'Likelihood combined nets, std');
% createFigDL(std(predictionVec4,0,3), yTest,FFvals,R2vals,'Third network, std');

% Visualise comparison against conventional fitting
load('/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Experiments/experimentResults/Rev2_Simulation_Results_SNR60_R1000.mat')

figure('Name', 'MAGORINO parameter error')
subplot(2,2,1)
image(FFmaps.standard(:,1:6),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Gaussian magnitude FF maps')
colorbar

subplot(2,2,2)
image(FFmaps.Rician(:,1:6),'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
title('Rician magnitude FF maps')
colorbar

subplot(2,2,3)
image(errormaps.FFstandard(:,1:6),'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Gaussian magnitude FF error')
colorbar

subplot(2,2,4)
image(errormaps.FFRician(:,1:6),'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Rician magnitude FF error')
colorbar


