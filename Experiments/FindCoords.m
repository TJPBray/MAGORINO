function [maxima] = FindCoords(likelihoodGrid,FFgrid,vgrid)
%[globalmax,localmax] = FindCoords(likelihoodgrid)

%Finds coordinates of maximum likelihood in grid of simulate likelihood values 

%Inputs:
%likelihoodgrid, FFgrid, vgrid

%Outputs:
%ff and r2* values corresponding to maximum likelihood

%% Find max likelihood values and corresponding indices and coordinates
[max1,ind1] = max(likelihoodGrid,[],'all','linear');

globalmax.values.FF=FFgrid(ind1);
globalmax.values.R2=vgrid(ind1);

% Find corresponding coordinates
[globalmax.coords.FF globalmax.coords.R2] = find(likelihoodGrid==max1);

%% Find likelihood values for non-global optimum

%Specify switching point
sw = 0.58;

%First clone likelihood grid
smallLikGrid=likelihoodGrid;

%If fat-dominant max likelihood
if globalmax.values.FF>=sw

%Set values to -inf for upper half to 'crop' likelihood grid
smallLikGrid(FFgrid>=0.68)=-Inf;

%Search 'cropped' likelihood grid
[max2,ind2] = max(smallLikGrid,[],'all','linear');

localmax.values.FF=FFgrid(ind2);
localmax.values.R2=vgrid(ind2);

% Find corresponding coordinates
[localmax.coords.FF localmax.coords.R2] = find(smallLikGrid==max2);

%If water-dominant max likelihood
elseif globalmax.values.FF<sw
    
%Set values to -inf for upper half to 'crop' likelihood grid
smallLikGrid(FFgrid<0.68)=-Inf;

%Search 'cropped' likelihood grid
[max2,ind2] = max(smallLikGrid,[],'all','linear');

localmax.values.FF=FFgrid(ind2);
localmax.values.R2=vgrid(ind2);

% Find corresponding coordinates
[localmax.coords.FF localmax.coords.R2] = find(smallLikGrid==max2);    

else 
    error('Problem with likelhood grid local optimum calculation')
    
end

maxima.globalmax=globalmax;
maxima.localmax=localmax;

end


