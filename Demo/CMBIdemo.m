
%% 1. Specify parameters 

%Specify echotimes
t=1:0.1:10;

%Specify pw and pf
pw=1;
pf=1;

%Specify R2*
R2=0.01;

% Specify known fat amplitudes and frequencies
r= [ 0.087; 0.694; 0.128; 0.004; 0.039; 0.048];
freqs= [-0.498; -0.447; -0.345; -0.261; -0.063; 0.064];

%% 2. Calculate signal from each fat peak (could also vectorise)

Sf1=f*r(1)*exp(i*2*pi*freqs(1)*t);
Sf2=f*r(2)*exp(i*2*pi*freqs(2)*t);
Sf3=f*r(3)*exp(i*2*pi*freqs(3)*t);
Sf4=f*r(4)*exp(i*2*pi*freqs(4)*t);
Sf5=f*r(5)*exp(i*2*pi*freqs(5)*t);
Sf6=f*r(6)*exp(i*2*pi*freqs(6)*t);

%% 3. Single peak model 

%Pick dominant fat peak only
Sf=Sf2;

S=pw+Sf;

plot(t,abs(S))

%% Multipeak model

%Include signal from all fat peaks
Sf = Sf1+Sf2+Sf3+Sf4+Sf5+Sf6;

S=pw+Sf;

plot(t,abs(S))

%% Multipeak model with R2*

%Add R2* decay to signal model 
S=S.*exp(-t*R2)

plot(t,abs(S))

