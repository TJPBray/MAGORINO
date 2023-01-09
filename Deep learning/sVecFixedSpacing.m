function [paramVec, sVec] = sVecFixedSpacing(S0,FFvals,R2vals)
% function sVec = sVecFixedSpacing[FF,R2star]

%Creates a vector of signal values with fixed spacing on the FF / R2*
%parameter grid (to enable simple visualisation)

% Input:
% S0 is the signal intensity at t=0
% FFvalues is an ax1 vector of the chosen FF values
% R2 values is a 1xb vector o the chosen R2 values

% Output:
% paramVec is an nxm matrix of parameter values where n is the number of
% training examples and m is the number of parameters
% sVec is an nxp matrix of signal values where n is the number of training
% examples and s is the number of echotimes


%1.1 Create grids of ground truth values
FFgrid=repelem(FFvals,1,size(R2vals,2));

Fgrid=S0*FFgrid;

Wgrid=S0-Fgrid;

vgrid=repelem(R2vals,size(FFvals,1),1);%1ms-1 upper limit chosen to reflect Hernando et al. (went up to 1.2)

%1.2 Reshape into parameter vectors
FFvec = reshape(FFgrid,[],1);
R2vec = reshape(vgrid,[],1);

paramVec = horzcat(FFvec,R2vec);

%1.3 Create signal vectors from parameters
Fvec = FFvec * S0;
Wvec = S0 - Fvec;

%1.4 Set other parameters 
    
%Define fB
    fB = 0;

    %Set echotimes
    echotimes=[1.1:1.1:13.2]';

%1.5 Generate (normalised) signal samples
sVec=MultiPeakFatSingleR2(echotimes,3,Fvec,Wvec,R2vec,fB);

end

