function outparams = R2fitting (echotimes, tesla, Smeasured, sig, GT) %noise SD needed for Rician fit
%function outparams = R2fitting (echotimes, tesla, Smeasured, sig, GT)

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

Scomplex=Smeasured; %retain complex data for use in complex fitting
Smagnitude=abs(Smeasured); %otherwise use magnitude

%% Set constants for initialisation

%Set initialisation value for R2*: vinit
vinit=0.1;
algoparams.vinit=0.1;
vmax=1;
vmin=0; %negative value for min to avoid penalisation at boundary

%Set signal initialisation for fat and water: Sinit
C=exp(vinit);
Sinit=C*max(Smagnitude); %partially compensates for R2* to improve initialisation
algoparams.Sinit=Sinit;
% Sinit=100;

%% Set optimisation options
algoparams.options=optimoptions('fmincon', 'Algorithm', 'interior-point','InitBarrierParam',100000,'ScaleProblem',true,'FiniteDifferenceType','central');
algoparams.solver = 'fmincon';

%% Gaussian ('standard') magnitude fitting

% set the parameter lower bound
algoparams.lb = [0, 0, vmin]';

% % set the parameter upper bound
algoparams.ub = [3*Sinit, 3*Sinit, vmax]'; 

% Call GaussianMagnitudeFitting
outparams.standard = GaussianMagnitudeFitting (echotimes, tesla, Scomplex, sig, GT, algoparams);

%% Gaussian ('standard') magnitude fitting

% set the parameter lower bound
algoparams.lb = [0, 0, vmin]';

% % set the parameter upper bound
algoparams.ub = [3*Sinit, 3*Sinit, vmax]'; 

% Call RicianMagnitudeFitting
outparams.Rician = RicianMagnitudeFitting (echotimes, tesla, Scomplex, sig, GT, algoparams);

%% Complex fitting

% 1. Perform with variable fB

% set the parameter lower bound
algoparams.lb = [0, 0, vmin, -Inf]';

% % set the parameter upper bound
algoparams.ub = [3*Sinit, 3*Sinit, vmax, Inf]'; 

% Call ComplexFitting
outparams.complex = ComplexFitting (echotimes, tesla, Scomplex, sig, GT, algoparams);

% 2. Perform with fixed fB

% set the parameter lower bound
algoparams.lb = [0, 0, vmin, 0]';

% % set the parameter upper bound
algoparams.ub = [3*Sinit, 3*Sinit, vmax, 0]'; 

% Call ComplexFitting
outparams.complexFixed = ComplexFitting (echotimes, tesla, Scomplex, sig, GT, algoparams);


end



