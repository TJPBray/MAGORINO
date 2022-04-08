%% roiStats

function [meanVec, sdVec, nVec] = RoiStats(map,ROIs)
%% function [meanVec, sdVec, nVec] = RoiStats(map,ROIs)

%function to extract stats for each label in ROI map

%Inputs 
%map is n x m parameter map
%ROIs is n x m matrix with integer values for each label

%Outputs
% n x 1 vector of mean, sd and n (number of pixels in ROI) for each label

%1.1 Get number of ROIs
L = max(ROIs,[],'all');

%2.2 Loop through ROIs and extract FF and R2* measurements for each 

for l = 1:(L-1) %Ignore last ROI as placed outside tubes

    maskedMap = map(ROIs==l);

    nVec(l,1)=sum(ROIs==l,'all');

    meanVec(l,1) = sum(maskedMap,'all')/nVec(l,1);

    sdVec(l,1) =std(double(nonzeros(maskedMap)));

end

end

