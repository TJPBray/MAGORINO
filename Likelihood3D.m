%Visualise likelihood in 3D

%% Specify parametersfor signal simulation

%Choose parameters
FF=30;
v=0.3;
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
% marrow. 

SNR=60;

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

%Add S0 variations 
for s=50:200
    
    Fgrid3d(:,:,s)=Fgrid*s/100;
    Wgrid3d(:,:,s)=Wgrid*s/100;
    vgrid3d(:,:,s)=vgrid;
    
end


%Loop through combinations

for y=1:size(Fgrid3d,1)
    for x=1:size(Fgrid3d,2)
        for z=1:size(Fgrid3d,3)
            
        phat(1)=Fgrid3d(y,x,z);
        phat(2)=Wgrid3d(y,x,z);
        phat(3)=vgrid3d(y,x,z);
        phat(4)=0;
        
        loglikRic(y,x,z) = R2RicianObj(phat,echotimes,tesla,Snoisy,noiseSD);
        SSE(y,x,z)= R2Obj(phat,echotimes,tesla,Snoisy);
    end
    end
    end

%Show in 3D
newanal2(exp(loglikRic))
colormap('parula')
    