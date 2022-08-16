function algoparams = setAlgoparams (S,sigmaEstimateFromRoi,opt) 
% function algoparams = setAlgoparams (S,SNRest,opt) 

% Description: Creates a standard set of fitting options
%
% Inputs: 
% S - the 1-by-m vector of measured signals for each echo time (used
% to calculate initial value for S0)
%
% SNRest - very rough estimate of SNR (based on knowledge of field strength and tissue) to generate bounds
% for sigma
%       
% opt - 1 for conventional fitting with 3 parameters, 2 for
%        fitting with four parameters (where the fourth parameter is
%        sigma), 3 for fitting with four parameters (where the fourth
%        parameter is fB), 4 for fitting with four parameters (where the fourth
%        parameter, fB, is fixed to 0),

%% 1. Set constants for initialisation

%1.1 Set initialisation value for R2*: vinit
vinit=0.1;
algoparams.vinit=0.1;

vmax=2;
vmin=0;

%1.2 Set signal initialisation for fat and water: Sinit
C=exp(vinit);
Sinit=C*max(S); %partially compensates for R2* to improve initialisation
algoparams.Sinit=Sinit;

%1.3 Calculate bounds for sigma based on SNR and Sinit
% Calculate rough sigma
algoparams.sigEst = sigmaEstimateFromRoi;
sigLB=sigmaEstimateFromRoi*0.2;
sigUB=sigmaEstimateFromRoi*2;


%% Set optimisation options

algoparams.solver = 'fmincon';

algoparams.options=optimoptions('fmincon', 'Algorithm', 'interior-point','InitBarrierParam',100000,'ScaleProblem',true,'FiniteDifferenceType','central');
   
%% Set lower bounds for parameters depending on opt

if opt==1

% set the parameter lower bound
algoparams.lb = [0, 0, vmin]';
% % set the parameter upper bound
algoparams.ub = [3*Sinit, 3*Sinit, vmax]'; 

elseif opt==2

% set the parameter lower bound
algoparams.lb = [0, 0, vmin, sigLB]';

% % set the parameter upper bound
algoparams.ub = [3*Sinit, 3*Sinit, vmax, sigUB]'; 

elseif opt==3

% set the parameter lower bound
algoparams.lb = [0, 0, vmin, -Inf]';

% % set the parameter upper bound
algoparams.ub = [3*Sinit, 3*Sinit, vmax, Inf]'; 

elseif opt==4

% set the parameter lower bound
algoparams.lb = [0, 0, vmin, 0]';

% % set the parameter upper bound
algoparams.ub = [3*Sinit, 3*Sinit, vmax, 0]'; 

end

end



