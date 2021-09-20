% Used to generate synthetic images from FF and R2* maps

% Tim Bray
% t.bray@ucl.ac.uk

%% Specify parameters

% Add echotime values
echotimes=1.1:1.1:13.2;

%Define fB
fB=0;

%Slice
sl=20

%% Define noise parameters
SNR=60;
noiseSD=100/SNR; %here assume total signal is 100 for simplicity (since FF maps are used as input)

%% Derive example data for slice
FFsl=FF(:,:,sl);
R2sl=R2star(:,:,sl);

%% Loop through voxels for simulation of signal and then fitting
for y=1:size(FFsl,1)
    parfor x=1:size(FFsl,2)
        
        %Simulate noiseless signal
        SimSignal=Fatfunction(echotimes,FFsl(y,x),(100-FFsl(y,x)),R2sl(y,x),fB);
        
        %Add Rician noise
        SimSignalNoisy=SimSignal + normrnd(0,noiseSD,[1 numel(echotimes)]) + i*normrnd(0,noiseSD,[1 numel(echotimes)]);
        
        %Implement fitting
 
        outparams = R2fitting(echotimes, SimSignalNoisy, noiseSD); %Need to take magnitude here; NB fitting will still work without!

        %Create individual images:
        
        %For R2*
        R2standard(y,x)=outparams.standard.R2;
        R2Rician(y,x)=outparams.Rician.R2;
        R2complex(y,x)=outparams.complex.R2;
        
        %For FF
        FF_standard(y,x)=outparams.standard.F/(outparams.standard.W+outparams.standard.F);
        FF_Rician(y,x)=outparams.Rician.F/(outparams.Rician.W+outparams.Rician.F);
        FF_complex(y,x)=outparams.complex.F/(outparams.complex.W+outparams.complex.F);
    
    y
    end
end

figure
subplot(2,2,1)
imshow(R2sl,[0 3])
title('Ground truth')

subplot(2,2,2)
imshow(R2standard,[0 3])
title('Standard magnitude fitting')

subplot(2,2,3)
imshow(R2Rician,[0 3])
title('Rician magnitude fitting')

subplot(2,2,4)
imshow(R2complex,[0 3])
title('Complex fitting')


figure
subplot(2,2,1)
imshow(FFsl,[ ])
title('Ground truth')

subplot(2,2,2)
imshow(FF_standard,[ ])
title('Standard magnitude fitting')

subplot(2,2,3)
imshow(FF_Rician,[ ])
title('Rician magnitude fitting')

subplot(2,2,4)
imshow(FF_complex,[ ])
title('Complex fitting')
        
        