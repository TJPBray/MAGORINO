%% Visualisation of effect of fB and FF variations on the likelihood function 

%% 1. Generate the noise-free forward model

% 1.1 set the tissue parameters

% R2* (kHz or ms^-1)
R2star = 0.1;

% field strength offset (kHz)
fieldStrengthOffset = 0;

% S0 (arbitrary unit) - corresponding to the theoretical signal at TE = 0
S0 = 1;

% fat fraction
fatFraction = 0.2;

% convert S0 and fat fraction to fat and water signals

% fat signal (arbitrary unit)
Sfat = S0*fatFraction;

% water signal (arbitrary unit)
Swater = S0*(1 - fatFraction);

% combine into ground truth parameter vector
GT.p = [Sfat; Swater; R2star];

% 1.2 set the acquisition parameters

% scanner field strength (Tesla)
fieldStrength = 3;

% echo times (ms) - densely sampled here for visualisation purposes
echoTimes = (0:1.1:11)';

% number of measurements
numOfMeas = length(echoTimes);

% 1.3 generate the signal with Fatfunction
signalNoiseFree = MultiPeakFatSingleR2(echoTimes, fieldStrength, Sfat, Swater, R2star, fieldStrengthOffset);


%% 2. Simulate noisy measured signal from noise free data

% 2.1 fix the random seed
rng(1);

% 2.2 set the standard deviation of the Gaussian noise

% set the SNR (SNR = S0/sigma)
SNR = 20;

% set the sigma
sigma = S0/SNR;

% 2.3 generate the real and imaginary noises
noiseReal = sigma*randn(1, numOfMeas);
noiseImag = sigma*randn(1, numOfMeas);
noise = noiseReal + 1i*noiseImag;

% 2.5 add noise to the noise-free signals
signalNoisy = signalNoiseFree + noise;
signalMagnNoisy = abs(signalNoisy);

%% 3. Generate grid of values for likelihood function computation
% 3.1 Generate fB values
fB=-1:0.01:1;

% 3.2 Generate parameter value grid
Sfat=0:(0.01*S0):S0;

% 3.3 Generate fB grid
fBgrid=repelem(fB',1,numel(Sfat));
Sfatgrid=repelem(Sfat,numel(fB),1);

% 3.4 Loop over grids to calculate likelihood at each point
for a=1:numel(fB)   
for b=1:numel(Sfat)
    
    p= [Sfatgrid(a,b); S0-Sfatgrid(a,b); R2star; fBgrid(a,b)];
    
loglik(a,b) = R2ComplexObj(p,echoTimes,3,signalNoisy,sigma);

end
end

% 3.5 Find index for swapped solution
[maxima] = FindCoords(loglik,Sfatgrid,fBgrid); %Note that fBgrid is a 'dummy' input here - normally R2* variation but in this case fB varies
swappedFF=maxima.localmax.values.FF;

% 3.6 Plot
figure('Name','Likelihood dependence on fB for varying PDFF')

subplot(2,2,1)
plot(fBgrid(Sfatgrid==fatFraction),loglik(Sfatgrid==fatFraction))
xlabel('fB (kHz)')
ylabel('Log likelihood')
title('Likelihood at true FF')
yl=ylim;

subplot(2,2,2)
plot(fBgrid(Sfatgrid==swappedFF),loglik(Sfatgrid==swappedFF))
xlabel('fB (kHz)')
ylabel('Log likelihood')
title('Likelihood at swapped FF')
ylim(yl)

subplot(2,2,3)
surf(fBgrid,Sfatgrid,loglik)
ylabel('Fat fraction')
xlabel('fB (kHz)')
zlabel('Log likelihood')
title('2D Likelihood function (oblique view)')

subplot(2,2,4)
surf(fBgrid,Sfatgrid,loglik,'LineStyle','none')
ylabel('Fat fraction')
xlabel('fB (kHz)')
zlabel('Log likelihood')
view(0,90)
title('2D Likelihood function (top-down view)')
colorbar;