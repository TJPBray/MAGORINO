%% Create figures

function Createfig(errormaps,errormaps1,errormaps2)
%function Createfig(errormaps,errormaps1,errormaps2)

% Input: errormaps, errormaps1, errormaps2

% This function takes the outputs from Simulate_Values as inputs and uses
% them to generate FF maps showing effect of different sigma estimations 

% Author:
% Tim Bray, t.bray@ucl.ac.uk


%% 1. Parameter error
% 1.1 FF error
figure('Name', 'Parameter error')
s1=subplot(2,4,1)
image(errormaps.FFstandard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Gaussian PDFF error')
colorbar

subplot(2,4,2)
image(errormaps2.FFRician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Rician PDFF error, sigma error -0.3')
colorbar

subplot(2,4,3)
image(errormaps.FFRician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Rician PDFF error, correct sigma')
colorbar

subplot(2,4,4)
image(errormaps1.FFRician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
FigLabels;
title('Rician PDFF error, sigma error +0.3')
colorbar

subplot(2,4,5)
image(1000*errormaps.R2standard,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1000 1000];
FigLabels;
title('Gaussian R2* error')
colorbar;

subplot(2,4,6)
image(1000*errormaps2.R2Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1000 1000];
FigLabels;
title('Rician R2* error, sigma error -0.3')
colorbar;

subplot(2,4,7)
image(1000*errormaps.R2Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1000 1000];
FigLabels;
title('Rician R2* error, correct sigma')
colorbar;

subplot(2,4,8)
image(1000*errormaps1.R2Rician,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1000 1000];
FigLabels;
title('Rician R2* error, sigma error +0.3')
colorbar;



end









