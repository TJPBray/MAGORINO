%Function describing interactions of water and multiple fat components

function S=MultiPeakFatSingleR2(t,tesla,F,W,R2star,fB);
%function S=MultiPeakFatSingleR2(t,tesla,F,W,v,fB);

%Inputs:
%t is T-by-1 vector of echo times in milliseconds, where T is the total number of echotimes
%W is water density (can be a single value or an m-by-1 vector, where m is the number of examples)
%F is fat density (can be a single value or an m-by-1 vector, where m is the number of examples)
%R2star is system R2* (single term for both fat and water; can be a single value or an m-by-1 vector, where m is the number of examples)
%fB is field imhomogeneity in Hz

%Model:
%Multipeak fat spectrum with frequency shifts and amplitudes as detailed
%below and single R2* term

%Outputs:
%S is an m-by-T vector of complex-valued signal intensities

%% Specify field strength
%At 3T the Larmor frequency is 128MHz. Fat-water shift (Hz) is 128MHz x ppm (x10^-6). 
%At 1.5T the Larmor freq is 64Mhz. Fat water shift (Hz) is 64MHz x ppm (x10^-6).

gyro=42.58*10^6; %MHz/Tesla
larmor=tesla*gyro;

%% Specify fat shifts and amplitudes, calculate signal

%Spectrum based on on Karampinos et al. MRM 2014;71(3):1158-1165:

%F1: Methyl peak at 0.9ppm has relative magnitude 0.087: for w in ms, w=0.9*128*2*pi/1000
%F2: Methylene peak at 1.3ppm has relative magnitude 0.568: for w in ms, w=1.3*128*2*pi/1000
%F3: Beta carboxyl peak at 1.59ppm has relative magnitude 0.058: for w in ms, w=1.59*128*2*pi/1000
%F4: Alpha olefinic peak at 2.00ppm has relative magnitude 0.092: for w in ms, w=2.00*128*2*pi/1000
%F5: Alpha carboxyl peak at 2.25ppm has relative magnitude 0.058: for w in ms, w=2.25*128*2*pi/1000
%F6: Diacyl peak at 2.77ppm has relative magnitude 0.027: for w in ms, w=2.77*128*2*pi/1000
%F7: Glycerol peak at 4.20ppm has relative magnitude 0.038: for w in ms, w=2.77*128*2*pi/1000
%F8: Olefinic peak at 5.31ppm has relative magnitude 0.073: for w in ms, w=5.31*128*2*pi/1000
%Water: Water peak at 4.9ppm : for w in ms, w=4.9*128*2*pi/1000

%NB: 2pi converts to angular frequency, division by 1000 converts to kHz (as echo times are in ms)

% S=F*0.087*exp((i*0.72)*t)+...
% F*0.568*exp((i*1.05)*t)+...
% F*0.058*exp((i*1.28)*t)+...
% F*0.092*exp((i*1.61)*t)+...
% F*0.058*exp((i*1.81)*t)+...
% F*0.027*exp((i*2.23)*t)+...
% F*0.038*exp((i*2.23)*t)+...
% F*0.073*exp((i*4.27)*t)+...
% W*exp((i*3.94)*t)

% Fatamps = [0.087; 0.568; 0.058; 0.092; 0.058; 0.027; 0.038; 0.073]; %relative fat amplitudes
% Fatshift = [0.9; 1.3; 1.59; 2.00; 2.25; 2.77; 4.20; 5.31];
% Fatw= Fatshift*larmor*2*pi/1000; %Fatw is angular frequency
% 
% Watershift = 4.9;
% Waterw=Watershift*larmor*2*pi/1000; %Waterw is angular frequency

%Spectrum based on Hernando et al. multisite: 

Fatamps = [0.087; 0.694; 0.128; 0.004; 0.039; 0.048]; %relative fat amplitudes
Fatshift = [-3.9; -3.5; -2.7; -2.04; -0.49; 0.50 ]; %in parts per million
FatFreqs = Fatshift*larmor*10^(-6); %Fat frequencies in Hz (note parts per million conversion)
FatFreqs = FatFreqs/1000; %Fat frequencies in cycles / ms 
Fatw= FatFreqs*2*pi; %Fatw is angular frequency

Watershift = 0;
WaterFreq = Watershift*larmor; %Fat frequencies in MHz
WaterFreq = WaterFreq/1000; %Fat frequencies in cycles / ms 
Waterw=WaterFreq*2*pi; %Waterw is angular frequency


S=  F*Fatamps(1)*exp((i*Fatw(1))*t')+...
    F*Fatamps(2)*exp((i*Fatw(2))*t')+...
    F*Fatamps(3)*exp((i*Fatw(3))*t')+...
    F*Fatamps(4)*exp((i*Fatw(4))*t')+...
    F*Fatamps(5)*exp((i*Fatw(5))*t')+...
    F*Fatamps(6)*exp((i*Fatw(6))*t')+...
    W*exp((i*Waterw)*t');

%% Multiply signal by R2* term 

S=S.*exp(-R2star*t'); %R2star term

%% Multiply signal by fB term 

%Convert fB to cycles / ms
fB = fB/1000;

S=S.*exp(i*2*pi*fB*t'); %B0 inhomogeneity

% Scomp(1,:)=real(S);
% Scomp(2,:)=imag(S);

end

%figure, plot(t,abs(S))

