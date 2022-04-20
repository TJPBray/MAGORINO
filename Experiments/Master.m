% Master script
% Runs the various simulations and generates figures
% Author: Tim Bray (t.bray@ucl.ac.uk)

%% 1. Simulations

% 1.1 Set number of reps across simulations
reps=1000;

% 1.2 Run simulations for varying FF and SNR with R2* = 0
% [FFmaps,errormaps,sdmaps] = Simulate_Values_SNR(v,reps)
[FFmaps,errormaps,sdmaps,residuals] = Simulate_Values_SNR(0,reps)

%1.3 Run simulations for varying FF and R2* with SNR = 60
% [FFmaps,errormaps,sdmaps] = Simulate_Values(SNR,reps)

[FFmaps,errormaps,sdmaps,residuals] = Simulate_Values(60,0,reps)

%1.4 Run simulations for varying FF and R2* with SNR = 20
% [FFmaps,errormaps,sdmaps] = Simulate_Values(SNR,reps)

[FFmaps,errormaps,sdmaps,residuals] = Simulate_Values(20,0,reps)

%1.5 Run likelihood function analysis for chosen FF, R2*, SNR
% [outparams] = Likelihood(FF,R2*,SNR,figshow) %Set figshow=1 for display

%1.5.1 Combination 1 (R2*=0, both methods likely to succeed): 
    %Run likelihood function analysis
    [outparams] = VisObjFun(0.2,0,60,1)
    %Show proportion of successful fits
    Fitsuccess(0.2,0,60,200)

%1.5.2 Combination 2 (Moderate R2*, Rician may outperform): 
    %Run likelihood function analysis
    [outparams] = VisObjFun(0.2,0.3,60,1)
    %Show proportion of successful fits
    Fitsuccess(0.2,0.3,60,200)
    
%1.5.3 Combination 3 (Large R2*, challenging case but Rician best): 
    %Run likelihood function analysis
    [outparams] = VisObjFun(0.2,0.5,60,1)
    %Show proportion of successful fits
    Fitsuccess(0.2,0.5,60,200) %Can use larger number of reps here as only one value pair / set

%1.5.4 Combination 4 (Largest R2*): 
    %Run likelihood function analysis
    [outparams] = VisObjFun(0.2,0.7,60,1)
    %Show proportion of successful fits
    Fitsuccess(0.2,0.7,60,200) %Can use larger number of reps here as only one value pair / set    

%1.4 Run simulations for varying FF and R2* with SNR = 60 and sigma
%overestimated by 30% (sigmaError = 1.3) corresponding to size of
%inaccuracy from earlier simulation
% [FFmaps,errormaps,sdmaps] = Simulate_Values(SNR,reps)

[FFmaps,errormaps,sdmaps,residuals] = Simulate_Values(60, 1.3, 1000);

%% 2. Run multistep fitting for subject data (FW111)

%2.1 Load data 
subjFolder='/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data/Subjects';
subjFileName='FW111_raw_monopolar.mat';
load(fullfile(subjFolder,subjFileName));

%2.3 Specify indent (to avoid fitting dead space at edge of phantom) and
%filtersize
indent=110;
sl=20;
filterSize=25;

%2.2 Run fitting to generate maps
[mapsWithSigma,maps,filteredSigma] = MultistepFitImage(imDataParams,sl,indent,filterSize);

%2.3 Display / graphical analysis of in vivo distribution
[fittedSimFF,fittedSimR2] = InVivoAnalysis(imDataParams, maps,indent);

%% 3. Run multistep fitting for Hernando phantom data

%3.1 Define folders for import of multiecho data and ROIs
imageFolder='/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data/Hernando data';
roiFolder='/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data/Hernando ROIs';

%Folder for saving
saveFolder='/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data/Hernando results';

%3.2 Get image and ROI folder info
imageFolderInfo=dir(imageFolder);
roiFolderInfo=dir(roiFolder);
saveFolderInfo=dir(saveFolder);

%3.3. Specify reference values in phantoms
% Create grid of reference values based on phantom structure
ReferenceValues.FF = ([0; 0.026; 0.053; 0.079; 0.105; 0.157; 0.209; 0.312; 0.413; 0.514; 1]);
% ReferenceValues.R2 = repelem([0; 0; 0; 0],1,5);

%3.4 Specify slice (use 1 if only 1 slice)
sl=2;

%3.5 Loop over datasets to fit each dataset
for n=21:28

%3.5 Define filenames for multiecho data and ROIs
dataFileName = imageFolderInfo(n+2).name
roiFileName = roiFolderInfo(n+2).name;

%3.6 Import data
struct=load(fullfile(imageFolder,dataFileName));
imData=struct.imDataAll;
fwmc_ff=struct.fwmc_ff;
fwmc_r2star=struct.fwmc_r2star;

%3.7 Import ROIs
phantomROIs = niftiread(fullfile(roiFolder,roiFileName));
    % phantomImage = niftiread(fullfile(folder,dataFileName));

% % Show check image for alignment
% figure
% subplot(2,3,1)
% imshow(phantomROIs(:,:,1),[])
% title('ROIs')
% 
% subplot(2,3,2)
% imshow(abs(imData.images(:,:,sl,1,1)),[])
% title('Magnitude image of phantom (first echo)')
% 
% subplot(2,3,3)
% imshow(fwmc_ff(:,:,2),[0 100])
% title('PDFF map of phantom')
% 
% subplot(2,3,4)
% imshow(phantomROIs(:,:,sl),[0 12])
% title('Phantom ROIs')

% Perform fitting of multiecho data, using sigma estimate from phantom ROIs

%3.8 Specify indent (to avoid fitting dead space at edge of phantom) and
%filtersize
indent=30;
filterSize=5;

%3.9 Perform multistep fitting
[mapsWithSigma,filteredSigma,maps] = MultistepFitImage(imData,sl,indent,filterSize);


%3.10 Save variables (mapsWithSigma,filteredSigma,maps)
%Specify folder name
saveFileName = strcat('MAPS_', dataFileName);
save(fullfile(saveFolder,saveFileName), 'mapsWithSigma', 'filteredSigma', 'maps');

end

%% 3. Hernando phantom data ROI analysis (split off to enable rapid modification of figures)

for n=1:(numel(saveFolderInfo)-2)

%3.1 Define filenames for multiecho data and ROIs
dataFileName = imageFolderInfo(n+2).name
roiFileName = roiFolderInfo(n+2).name;

%3.2 Import data
struct=load(fullfile(imageFolder,dataFileName));
imData=struct.imDataAll;
fwmc_ff=struct.fwmc_ff;
fwmc_r2star=struct.fwmc_r2star;

%3.3 Import ROIs
phantomROIs = niftiread(fullfile(roiFolder,roiFileName));

%3.4 Load MAGORINO maps (created earlier) 
load(fullfile(saveFolder,strcat('MAPS_', dataFileName)));

%3.5 Generate example figure for site 1, 3T, protocol 2
if n==4
figure
subplot(1,3,1)
imshow(maps.FFrician(50:200,50:200),[0 1])
a=colorbar
colormap('parula')
ylabel(a,'MAGORINO PDFF','FontSize',12)

subplot(1,3,2)
imshow(0.01*fwmc_ff(50:200,50:200,2),[0 1])
a=colorbar
colormap('parula')
ylabel(a,'Hernando PDFF','FontSize',12)

subplot(1,3,3)
imshow(maps.FFrician(50:200,50:200) - 0.01*fwmc_ff(50:200,50:200,2),[-0.1 0.1])
a=colorbar
ylabel(a,'MAGORINO PDFF - Hernando PDFF','FontSize',12)
else ;
end

%3.5 Phantom ROI analysis
[ff{n},regressionModels{n}] = PhantomRoiAnalysis(maps,phantomROIs(:,:,sl),ReferenceValues,fwmc_ff,fwmc_r2star);

end



%3.7 Tabulate coefficients and get figures
site = [1 1 1 1 7 7 7 7 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6 6 6 6];
protocol = [1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4];

[tableGaussian, tableRician] = tabulateCoeffs(ff,regressionModels,site, protocol,ReferenceValues,saveFolderInfo);
