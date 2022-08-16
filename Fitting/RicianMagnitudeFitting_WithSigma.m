function results = RicianMagnitudeFitting_WithSigma (echotimes, tesla, Smagnitude, sigmaInit, GT, algoparams) 
%function outparams = RicianMagnitudeFitting_WithSigma (echotimes, tesla, Smagnitude, sigmaInit, GT, algoparams)

% Description: Implements complex fitting with specified bounds
%
% Input:
% echotimes as an m-by-1 vector
% tesla is scalar-valued field strength
% Smagnitude is n-by-1 measured signal vector
% sigmaInit is the INITIALISATION value for sigma, since the value of sigma
% itself is estimated in the function
% GT is ground truth value to enable ground truth initialisation
% algoparams contains information on solver, optimoptions and
% initialisation

% Note that sigma is not an input, as it is estimated within the function

% Output:
% results structure, including fat density, water density, R2*, and
% sigma

% Specify optimisation algorithm options and solver
Ricianfitting.solver=algoparams.solver;
Ricianfitting.options=algoparams.options;

% Define the objective function
Ricianfitting.objective = @(p) -R2RicianObj_WithSigma(p,echotimes,tesla,Smagnitude);


%% Implement fitting for both water-dominant and fat-dominant initialisations
% [F W R2* fB0]

%allow fB0 to vary:
% set the parameter lower bound
Ricianfitting.lb = algoparams.lb;

% % set the parameter upper bound
Ricianfitting.ub = algoparams.ub; 

% First assume LOW FF (WATER DOMINANT) TISSUE (Use first echo to provide water guess)
% Initalise sigma to a reasonable value (initially try 30)
Ricianfitting.x0 = [0.001, algoparams.Sinit, algoparams.vinit, sigmaInit]'; 

% run the optimisation
[pmin1, fmin1] = fmincon(Ricianfitting); %fmin is the minimised SSE

% Next assume HIGH FF (FAT DOMINANT) TISSUE (Use first echo to provide water guess)
Ricianfitting.x0 = [algoparams.Sinit, 0.001, algoparams.vinit, sigmaInit]'; 

% run the optimisation
[pmin2, fmin2] = fmincon(Ricianfitting); %fmin is the minimised SSE

% Next INITIALISE WITH GROUND TRUTH
Ricianfitting.x0 = GT.p(1:3); %Use all four params for complex fitting
Ricianfitting.x0(4) = sigmaInit;

% run the optimisation
[pmin3, fmin3] = fmincon(Ricianfitting); %fmin is the minimised SSE

%Add the solutions to outparams
results.pmin1=pmin1;
results.pmin2=pmin2;
results.pmin3=pmin3;

results.fmin1=fmin1;
results.fmin2=fmin2;
results.fmin3=fmin3;

% Choose the estimates from the best residual

if fmin1<=fmin2
    
results.F = pmin1(1);
results.W = pmin1(2);
results.R2 = pmin1(3);
results.sig=pmin1(4)

results.fmin = fmin1;
results.chosenmin=1;

% Calculate SSE for complex fitting
[~,results.SSE]=R2Obj(pmin1,echotimes,tesla,Smagnitude,sigmaInit);

% Calculate SSE for complex fitting relative to noise-free signal
[~,results.SSEtrue]=R2Obj(pmin1,echotimes,tesla,abs(GT.S),sigmaInit);

else
    
results.F = pmin2(1);
results.W = pmin2(2);
results.R2 = pmin2(3);
results.sig=pmin2(4)

results.fmin = fmin2;
results.chosenmin=2;

% Calculate SSE for complex fitting
[~,results.SSE]=R2Obj(pmin2,echotimes,tesla,Smagnitude,sigmaInit);

% Calculate SSE for complex fitting relative to noise-free signal
[~,results.SSEtrue]=R2Obj(pmin2,echotimes,tesla,abs(GT.S),sigmaInit);

end

% Calculate SSE for standard (Gaussian) for ground-truth initialised
% parameters
% [~,results.SSEgtinit]=R2Obj(pmin3,echotimes,tesla,Smagnitude,sig); %Relative to measured signal
% [~,results.SSEtrue_gtinit]=R2Obj(pmin3,echotimes,tesla,abs(GT.S),sig); %Relative to ground-truth noise-free signal

end



