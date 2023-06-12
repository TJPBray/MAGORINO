%% FW-MRI forward model demo

%% 1. Generate the noise-free forward model

   
%Choose whether to show single peak or multi (0 for single, 1 for multi)
multiPeak = 1;

% 1.1 set the tissue parameters
% [Sf(au),  Sw(au), R2*(kHz), fB(kHz)]
tissueChoices = [3]


for l = 1:numel(tissueChoices)

%Define S0
    S0=100;

    %1. Pure water, low R2*
    params(1,:) =    [0, S0, 0, 0];

    %2. Low FF, low R2*
    params(2,:  )=   [0.2*S0, 0.8*S0, 0, 0];
    %3. Middle FF, low R2*
    params(3,:)  =   [0.5*S0, 0.5*S0, 0.2, 0.1];
    %4. High FF, low R2*
    params(4,:)  =   [0.8*S0, 0.2*S0, 0, 0];
    %4. Pure fat, 0 R2*
    params(5,:)  =   [1*S0, 0*S0, 0, 0];
    %5. Zero FF, high R2*
    params(6,:)  =   [0*S0, 1*S0, 0.5, 0];
    %6. Low FF, high R2*
    params(7,:)  =   [0.2*S0, 0.8*S0, 0.5, 0];
    %7. Middle FF, high R2*
    params(8,:)  =   [0.5*S0, 0.5*S0, 0.2, 0];
    %8. Pure fat, 0 R2*
    params(9,:)   =  [S0, 0, 0, 0];

    %Pick tissue type
    tissue=tissueChoices(l);
    
    %Define parameter vector
    p=params(tissue,:)';
    
    %Add ground truth parameters to GT structure to provide to fitting
    GT.p=p;
    

% 1.2 set the acquisition parameters

% scanner field strength (Tesla)
fieldStrength = 3;

% echo times (ms) - densely sampled here for visualisation purposes
denseEchoTimes = (0:0.1:11)';

%Sampling scheme
sampling=[12:11:111];

% Sampled echo times
echoTimes = denseEchoTimes(sampling);

% number of measurements
numOfMeas = length(echoTimes);

% 1.3 generate the noise-free measured signal with Fatfunction
signalNoiseFreeDense = MultiPeakFatSingleR2_IllustrationVersion(denseEchoTimes, fieldStrength, p(1), p(2), p(3), p(4));
signalNoiseFree = MultiPeakFatSingleR2_IllustrationVersion(echoTimes, fieldStrength, p(1), p(2), p(3), p(4));

% add noise-free signal to ground truth structure 
GT.S=signalNoiseFree;

% 1.3 Choose the signal for display
if multiPeak == 1
signalNoiseFreeDense.S = signalNoiseFreeDense.Smulti;
signalNoiseFree.S = signalNoiseFree.Smulti;

elseif multiPeak == 0
signalNoiseFreeDense.S = signalNoiseFreeDense.Ssingle;
signalNoiseFree.S = signalNoiseFree.Ssingle;
end

% 1.4 visualise the signal
figure;
subplot(2, 1, 1);
hold on;
plot(denseEchoTimes, abs(signalNoiseFreeDense.S), 'r-','LineWidth',2);
xlabel('Echo time (ms)');
ylabel('Signal');
ylim([0 1.1*S0])

signalPhaseNoiseFree = angle(signalNoiseFreeDense.S);

% 1.5 visualise in 3d
subplot(2,1,2)
plot3(denseEchoTimes,real(signalNoiseFreeDense.S),imag(signalNoiseFreeDense.S),'r-','LineWidth',2)
xlabel('Echo time (ms)')
ylabel('x')
zlabel('y')
zlim([-100 100])
ylim([-100 100])
hold on

%% 2. Create video 

% create the video writer object
video = VideoSetup('test');
video.open();

%2.1 Create figure
h = figure;
set(gcf,'color','w');

    %Create subplot 1
    h1 = subplot(2,2,1);
    hold on
    xlim([min(imag(signalNoiseFreeDense.S)) max(imag(signalNoiseFreeDense.S))]);
    ylim([min([real(signalNoiseFreeDense.S) 0]) max(real(signalNoiseFreeDense.S))]); %lower ylim set so that it is not above 0
    zlim([0 10]);
    set(h1,'FontSize',12)
    xlabel('M_x')
    ylabel('M_y')

    %Create subplot 2
    h2 = subplot(2,2,2);
    hold on
    xlim([0 10]);
    ylim([0 1.1*S0])
    set(h2,'FontSize',12)
    xlabel('Time (ms)')
    ylabel('|M|')

    %Create subplot 3
    h3 = subplot(2,2,4);
    hold on;
    xlim([-100 100]);
    ylim([-100 100]);
    zlim([0 10])
    xlabel('M_x')
    ylabel('M_y')
    zlabel('Time (ms)')
    set(h3,'FontSize',12)
    view([45 45])

% add a frame
VideoAddFrame(video, h);

pause;

for i = 1:numel(denseEchoTimes)
    pause(0.1);


    try cla(h1)
%         delete(p)
%         delete(p2)
%         delete(p3)

    catch ;
    end

    %2.2 Plot water vector
    wVec1 = [0 imag(signalNoiseFreeDense.Sw(i))];
    wVec2 = [0 real(signalNoiseFreeDense.Sw(i))];
    p2 = quiver(h1, 0,0,wVec1(2),wVec2(2),0,'b-','LineWidth',1.5);

    %2.3 Plot fat vector(s)

    if multiPeak == 1

        %Plot individual fat vectors
        %Loop over fat components
        for j=1:size(signalNoiseFreeDense.Sfmulti,1)

            %     fVec1 = [imag(signalNoiseFreeDense.Sw(i)), imag(signalNoiseFreeDense.Sw(i))+imag(signalNoiseFreeDense.Sfmulti(j,i))];
            %     fVec2 = [real(signalNoiseFreeDense.Sw(i)), real(signalNoiseFreeDense.Sw(i))+real(signalNoiseFreeDense.Sfmulti(j,i))];

            %     p3(j) = plot(h1,fVec1, fVec2, 'r-','LineWidth',1);
            p3(j) = quiver(h1, wVec1(2),wVec2(2),imag(signalNoiseFreeDense.Sfmulti(j,i)),real(signalNoiseFreeDense.Sfmulti(j,i)),0,'r-','LineWidth',1.5);

        end

        %Plot net fat vector over fat components
        fNetVec1 = [imag(signalNoiseFreeDense.Sw(i)), imag(signalNoiseFreeDense.Sw(i))+imag(signalNoiseFreeDense.SfmultiNet(i))];
        fNetVec2 = [real(signalNoiseFreeDense.Sw(i)), real(signalNoiseFreeDense.Sw(i))+real(signalNoiseFreeDense.SfmultiNet(i))];
        p3(j) = quiver(h1, fNetVec1(1),fNetVec2(1),fNetVec1(2)-fNetVec1(1),fNetVec2(2)-fNetVec2(1),0,'r:','LineWidth',1.5);

    elseif multiPeak == 0

        %Plot single fat vector
        p3 = quiver(h1, wVec1(2),wVec2(2),imag(signalNoiseFreeDense.Sfsingle(i)),real(signalNoiseFreeDense.Sfsingle(i)),0,'r-','LineWidth',1.5);

    end

    %2.4 Plot signal vector

    sVec1 = [0 imag(signalNoiseFreeDense.S(i))];
    sVec2 = [0 real(signalNoiseFreeDense.S(i))];
    ax = h1;
    p = quiver(h1, 0,0,sVec1(2),sVec2(2),0,'k-','LineWidth',1.5);

    %2.5 Plot signal on separate plot
    plot(h2,denseEchoTimes(i), abs(signalNoiseFreeDense.S(i)), 'k.','LineWidth',2)

    plot3(h3,real(signalNoiseFreeDense.S(i)),imag(signalNoiseFreeDense.S(i)),denseEchoTimes(i),'k.','LineWidth',2)

    view([45 45])

    %2.6 add a frame
    VideoAddFrame(video, h);
end

video.close();


end

hold off

%% 2. Simulate noisy measured signal from noise free data

% 2.1 fix the random seed

% 2.2 set the standard deviation of the Gaussian noise

% set the SNR (SNR = S0/sigma)
SNR = 40;

% set the sigma
sigma = S0/SNR;

%Fix the random seed
rng(2);

% 2.3 generate the real and imaginary noises
noiseReal = (sigma*randn(numOfMeas, 1))';
noiseImag = (sigma*randn(numOfMeas, 1))';
noise = noiseReal + 1i*noiseImag;

% 2.4 visualise the noises
h2 = subplot(2, 2, 2);
histogram(noiseReal, 10);
hold on;
histogram(noiseImag, 10);
xlabel('noise');
ylabel('count');
legend('real', 'imag');

% 2.5 add noise to the noise-free signals
signalNoisy = signalNoiseFree + noise;
signalMagnNoisy = abs(signalNoisy);

% 2.6 visualise the noisy signals
plot(h1, echoTimes, real(signalNoisy), 'r*');
hold on;
plot(h1, echoTimes, imag(signalNoisy), 'b*');
xlabel(h1, 'echo time (ms)');
ylabel(h1, 'noisy signal');
legend(h1, 'noise-free real', 'noise-free imag', 'noisy real', 'noisy imag');
plot(h3, echoTimes, signalMagnNoisy, 'r*');
legend(h3, 'noise-free magnitude', 'noisy magnitude');

% 2.7 rotate the complex noise by the phase angle of the corresponding
% measurements - to check Rician assumption
noiseRotated = noise.*exp(-1i*signalPhaseNoiseFree);
h4 = subplot(2, 2, 4);
histogram(real(noiseRotated));
hold on;
histogram(imag(noiseRotated));
xlabel('noise (rotated)');
ylabel('count');
legend('real', 'imag');

%% Visualise likelihood for each parameter


%% 3. Fit the model to the data

estimatedParas = FittingWrapper(echoTimes, fieldStrength, signalNoisy, sigma, GT);

%% Visualise predicted signal relative to ground truth and noisy measured signal 
figure
subplot(2,2,1)

hold on

%Noise-free signal
plot(denseEchoTimes, abs(signalNoiseFreeDense), 'k-','Linewidth',2);

%Noisy sampled signal
plot(echoTimes, abs(signalNoisy), 'k.','MarkerSize',20,'Linewidth',4);

%Gaussian fitted signal
gaussianPredictedSignal = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, estimatedParas.standard.F, estimatedParas.standard.W, estimatedParas.standard.R2, 0);
plot(denseEchoTimes, abs(gaussianPredictedSignal), 'r--','Linewidth',2)

%Rician fitted signal
ricianPredictedSignal = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, estimatedParas.Rician.F, estimatedParas.Rician.W, estimatedParas.Rician.R2, 0);
plot(denseEchoTimes, abs(ricianPredictedSignal), 'b--','Linewidth',2)

%Complex fitted signal
complexPredictedSignal = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, estimatedParas.complex.F, estimatedParas.complex.W, estimatedParas.complex.R2, 0);
plot(denseEchoTimes, abs(complexPredictedSignal), 'g--','Linewidth',2)

hold off 

legend('Noise-free signal','Noisy sampled signal', 'Gaussian fit','Rician fit', 'Complex fit')


%% Simple plot for figure generation

%Use initial guess for parameters to show that initial prediction does not match signal


predictedSignalGuess1 = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, 5, 95, 0.05, 0);
predictedSignalGuess2 = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, 10, 90, 0.1, 0);
predictedSignalGuess3 = MultiPeakFatSingleR2(denseEchoTimes, fieldStrength, 20, 80, 0.15, 0);

%Plot
figure 

subplot(1,3,1)
scatter(echoTimes, abs(signalNoisy),'filled','r');
ylabel('Signal')
xlabel('Echo time')
ylim([0 100])

subplot(1,3,2)
plot(denseEchoTimes, abs(predictedSignalGuess1), 'b-','Linewidth',2)
ylabel('Signal')
xlabel('Echo time')
ylim([0 100])

subplot(1,3,3)
scatter(echoTimes, abs(signalNoisy),'filled','r');
hold on
plot(denseEchoTimes, abs(predictedSignalGuess1), 'b--','Linewidth',0.5)
plot(denseEchoTimes, abs(predictedSignalGuess2), 'b--','Linewidth',1)
plot(denseEchoTimes, abs(predictedSignalGuess3), 'b--','Linewidth',1.5)
plot(denseEchoTimes, abs(ricianPredictedSignal), 'b-','Linewidth',2)
hold off
ylabel('Signal')
xlabel('Echo time')
ylim([0 100])
