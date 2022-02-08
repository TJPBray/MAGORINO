%Get ROI
%Use newanal2 to create ROI to find sigma for fitting

% Author:
% Tim Bray, t.bray@ucl.ac.uk
% January 2022

%% 1. Load imDataParams structure

%% 2. Call newanal to analyse

newanal2(abs(imDataParams.images))

% Export ROI in BW cell variable (single slice)
% Slice specified in 'slice'

% Once added to workspace, call FitImage

%3. Create ROI variable
ROI=BW{1,1};