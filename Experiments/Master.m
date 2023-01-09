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
    [outparams] = VisObjFun(0.2,0,40,1)
    %Show proportion of successful fits
    Fitsuccess(0.2,0,60,200)

%1.5.2 Combination 2 (Moderate R2*, Rician may outperform): 
    %Run likelihood function analysis
    [outparams] = VisObjFun(0.2,0.3,40,1)
    %Show proportion of successful fits
    Fitsuccess(0.2,0.3,60,200)
    
%1.5.3 Combination 3 (Large R2*, challenging case but Rician best): 
    %Run likelihood function analysis
    [outparams] = VisObjFun(0.2,0.5,40,1)
    %Show proportion of successful fits
    Fitsuccess(0.2,0.5,60,200) %Can use larger number of reps here as only one value pair / set

%1.5.4 Combination 4 (Largest R2*): 
    %Run likelihood function analysis
    [outparams] = VisObjFun(0.2,0.7,60,1)
    %Show proportion of successful fits
    Fitsuccess(0.2,0.7,60,200) %Can use larger number of reps here as only one value pair / set    

%1.4 Run simulations for varying FF and R2* with SNR = 60 and sigma
%overestimated by 30% (sigmaError = 0.3) corresponding to size of
%inaccuracy from earlier simulation
% [FFmaps,errormaps,sdmaps] = Simulate_Values(SNR,reps)

[FFmaps1,errormaps1,sdmaps1,residuals1] = Simulate_Values(60, 0.3, 1000);

%1.5 Run simulations for varying FF and R2* with SNR = 60 and sigma
%underestimated by 30% (sigmaError = -0.3) corresponding to size of
%inaccuracy from earlier simulation
% [FFmaps,errormaps,sdmaps] = Simulate_Values(SNR,reps)
[FFmaps2,errormaps2,sdmaps2,residuals2] = Simulate_Values(60, -0.3, 1000);

%1.6 Generate plots showing effect of sigma uncertainty on estimates
CreatefigUncertainty(errormaps,errormaps1,errormaps2)


%% 2a. Run  fitting for subject data (FW101)

%2a.1 Load data 
subjFolder='/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data/Subjects';
subjFileName='FW101_bipolar.mat';
load(fullfile(subjFolder,subjFileName));

%2a.2 Load ROI and add data to structure
roiFileName='FW101_bipolar_sigmaRoi.mat';
load(fullfile(subjFolder,roiFileName));

roi.mask=BW{1};
roi.slice=slice;
roi.size=sz_vol;

%2a.3 Specify indent (to avoid fitting dead space at edge of phantom) and
%add to imData
imDataParams.fittingIndent=2;

%2a.2 Run fitting to generate maps
maps = MultistepFitImage(imDataParams,roi);

%2a.3 Display / graphical analysis of in vivo distribution
indent=100;
[fittedSimFF,fittedSimR2] = InVivoAnalysis(imDataParams, maps, indent);

%% 2b. Run  fitting for subject data (FW111)

%2b.1 Load data 
subjFolder='/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data/Subjects';
subjFileName='FW111_monopolar.mat';
load(fullfile(subjFolder,subjFileName));

%2b.2 Load ROI and add data to structure
roiFileName='FW111_monopolar_sigmaRoi.mat';
load(fullfile(subjFolder,roiFileName));

roi.mask=BW{1};
roi.slice=slice;
roi.size=sz_vol;

%2b.3 Specify indent (to avoid fitting dead space at edge of phantom) and
%add to imData
imDataParams.fittingIndent=2;

%2b.4 Run fitting to generate maps
maps = MultistepFitImage(imDataParams,roi);

%2b.5 Display / graphical analysis of in vivo distribution
indent=100;
[fittedSimFF,fittedSimR2] = InVivoAnalysis(imDataParams, maps,indent);

%% 2c. Run  fitting for subject data (LegsSwapData)

%2c.1 Load data 
subjFolder='/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data/Subjects';
subjFileName='LegsSwapData.mat';
load(fullfile(subjFolder,subjFileName));

%2c.2 Load ROI and add data to structure
roiFileName='LegsSwapData_sigmaRoi.mat';
load(fullfile(subjFolder,roiFileName));

roi.mask=BW{1};
roi.slice=slice;
roi.size=sz_vol;

%2c.3 Specify indent (to avoid fitting dead space at edge of phantom) and
%add to imData
imDataParams.fittingIndent=2;

%2c.2 Run fitting to generate maps
maps = MultistepFitImage(imDataParams,roi);

%2c.3 Display / graphical analysis of in vivo distribution
% [fittedSimFF,fittedSimR2] = InVivoAnalysis(imDataParams, maps,indent);


%% 3. Run  fitting for Hernando phantom data

%3.1 Define folders for import of multiecho data and ROIs
imageFolder='/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data/Hernando data';
roiFolder='/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data/Hernando ROIs';

%Folder for saving
saveFolder='/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data/Hernando results Revision2';

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
for n=1:28

%3.5 Define filenames for multiecho data and ROIs
dataFileName = imageFolderInfo(n+2).name
roiFileName = roiFolderInfo(n+2).name;

%3.6 Import data
struct=load(fullfile(imageFolder,dataFileName));
imData=struct.imDataAll;
fwmc_ff=struct.fwmc_ff;
fwmc_r2star=struct.fwmc_r2star;

%3.7 Import ROIs
mask = niftiread(fullfile(roiFolder,roiFileName));
roi.mask=mask(:,:,sl);
roi.slice=sl;

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
imData.fittingIndent=30;

%3.9 Perform multistep fitting
maps = MultistepFitImage(imData,roi);

%3.10 Save variables (mapsWithSigma,filteredSigma,maps)
%Specify folder name
saveFileName = strcat('MAPS_', dataFileName);
save(fullfile(saveFolder,saveFileName), 'maps');

end

%% 3. Hernando phantom data ROI analysis (split off to enable rapid modification of figures)

%Folder for analysis
saveFolder='/Users/tjb57/Dropbox/MATLAB/Fat-water MAGORINO/Data/Hernando results Revision2';
saveFolderInfo=dir(saveFolder);

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
imshow(maps.FFstandard(50:200,50:200),[0 1])
a=colorbar
colormap('parula')
ylabel(a,'Gaussian PDFF','FontSize',12)

subplot(1,3,2)
imshow(maps.FFrician(50:200,50:200),[0 1])
a=colorbar
colormap('parula')
ylabel(a,'Rician PDFF','FontSize',12)

subplot(1,3,3)
imshow(maps.FFrician(50:200,50:200) - maps.FFstandard(50:200,50:200),[-0.1 0.1])
a=colorbar
ylabel(a,'Rician PDFF - Gaussian PDFF','FontSize',12)
else ;
end

%3.5 Phantom ROI analysis
[ff{n},regressionModels{n}] = PhantomRoiAnalysis(maps,phantomROIs(:,:,sl),ReferenceValues,fwmc_ff,fwmc_r2star);
end


%3.7 Tabulate coefficients and get figures
site = [1 1 1 1 7 7 7 7 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6 6 6 6];
protocol = [1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4];

[tableGaussian, tableRician] = tabulateCoeffs(ff,regressionModels,site, protocol,ReferenceValues,saveFolderInfo);
