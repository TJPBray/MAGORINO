function outparams = FittingWrapper (echotimes, tesla, Smeasured, sig, GT) %noise SD needed for Rician fit
%function outparams = FittingWrapper (echotimes, tesla, Smeasured, sig, GT)

% Description: Fitting 'wrapper' implements standard Gaussian, Rician and
% complex fitting and generates outputs for each
%
% Input:
% echotimes as an m-by-1 vector
% tesla is scalar-valued field strength
% Smeasured is n-by-1 measured signal vector
% sig is estimated noise sigma
% GT is ground truth value to enable ground truth initialisation

% Output:
% outparams structure

% Author: Tim Bray t.bray@ucl.ac.uk

%% Define signal for use
Scomplex=Smeasured; %retain complex data for use in complex fitting
Smagnitude=abs(Smeasured); %otherwise use magnitude

%% Decide which fitting to run
gaussianFitting = 0; 
ricianFitting = 1;
complexFitting = 0; 

%% Set algorithm parameters (initialisation values and bounds, choose optimiser)

% algoparams = setAlgoparams (S,sig,opt);
algoparams = setAlgoparams (Smagnitude,sig,1); % Choose 1 for standard fitting without sigma

%% Gaussian ('standard') magnitude fitting

if gaussianFitting == 1

% Call GaussianMagnitudeFitting
outparams.standard = GaussianMagnitudeFitting(echotimes, tesla, Smagnitude, sig, GT, algoparams);

else ; 
end

%% Rician magnitude fitting with sigma known a priori

if ricianFitting == 1

outparams.Rician = RicianMagnitudeFitting (echotimes, tesla, Smagnitude, sig, GT, algoparams);

else ; 
end

%% Complex fitting

if complexFitting == 1

% 1. Perform with variable fB
    %Set new algoparams
    algoparams = setAlgoparams (Smagnitude,sig,3); % Choose 3 for fitting including floating fB
    
    % Call ComplexFitting
    outparams.complex = ComplexFitting (echotimes, tesla, Scomplex, sig, GT, algoparams);

% % 2. Perform with fixed fB
% 
%     %Set new algoparams
%     algoparams = setAlgoparams (Smagnitude,tesla,4); % Choose 3 for fitting including floating fB
% 
%     % Call ComplexFitting
%     outparams.complexFixed = ComplexFitting (echotimes, tesla, Scomplex, sig, GT, algoparams);

else ; 
end

end



