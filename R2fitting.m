function outparams = R2fitting (echotimes, tesla, Smeasured, sig) %noise SD needed for Rician fit

%R2* fitting

Scomplex=Smeasured; %retain complex data for use in complex fitting
Smeasured=abs(Smeasured); %otherwise use magnitude

%% Set up the optimisation framework for standard magnitude fitting

% define the objective function
R2fitting.objective = @(p) R2Obj(p,echotimes,tesla,Smeasured);

% set the solver 
R2fitting.solver = 'fmincon';

% use interior-point
R2fitting.options = optimoptions('fmincon', 'Algorithm', 'interior-point');

% set the parameter lower bound
R2fitting.lb = [0, 0, -0.01, 0]'; %Set R2* < 0 as R2*=0 is used in simulations (?penalisation at boundary)

% % set the parameter upper bound
R2fitting.ub = [5*max(abs(Smeasured)), 5*max(abs(Smeasured)), 1, 0]'; %constrain fB0 to 0 for now

%% Set constant for S initialisation
%This constant accounts for lack of true in-phase echo and R2* decay to
%approximate S0; can be set separately if desired
%C1 for Gaussian
C1=exp(0.01); %C1=exp(R2* initialisation);
%C2 for Rician
C2=exp(0.01); %C2=exp(R2* initialisation);

%% Implement standard magnitude fitting for both water-dominant and fat-dominant initialisations
% [F W R2* fB0]

% First assume WATER DOMINANT TISSUE (Use first echo to provide water guess)
R2fitting.x0 = [0, C1*max(abs(Smeasured)), 0.01, 0]'; 

%[0, max(abs(Smeasured)), 0.01, 0]';

% run the optimisation
[pmin1_mag, fmin1_mag] = fmincon(R2fitting); %fmin is the minimised SSE

% Next assume FAT DOMINANT TISSUE (Use first echo to provide water guess)
R2fitting.x0 = [C1*max(abs(Smeasured)), 0, 0.01, 0]'; 

% run the optimisation
[pmin2_mag, fmin2_mag] = fmincon(R2fitting); %fmin is the minimised SSE

%Add the two solutions to outparams
outparams.standard.pmin1=pmin1_mag;
outparams.standard.pmin2=pmin2_mag;

outparams.standard.fmin1=fmin1_mag;
outparams.standard.fmin2=fmin2_mag;

% Choose the estimates from the best residual and add those to the
% outparams structure
if fmin1_mag<=fmin2_mag
    
outparams.standard.F = pmin1_mag(1);
outparams.standard.W = pmin1_mag(2);
outparams.standard.R2 = pmin1_mag(3);

outparams.standard.SSE = fmin1_mag;

else
    
outparams.standard.F = pmin2_mag(1); %swap fat and water from lines above
outparams.standard.W = pmin2_mag(2);
outparams.standard.R2 = pmin2_mag(3);

outparams.standard.SSE = fmin2_mag;

end

%% Set up the optimisation framework for  magnitude fitting with Rician noise modelling

% Replicate settings from above
R2Ricianfitting.solver=R2fitting.solver;
R2Ricianfitting.options=R2fitting.options;
R2Ricianfitting.lb=R2fitting.lb;
R2Ricianfitting.ub=R2fitting.ub;
R2Ricianfitting.x0=R2fitting.x0;

% define the objective function
R2Ricianfitting.objective = @(p) -R2RicianObj(p,echotimes,tesla,Smeasured,sig); 

%% Implement Rician fitting for both water-dominant and fat-dominant initialisations
% [F W R2* fB0]

% First assume WATER DOMINANT TISSUE (Use first echo to provide water guess)
R2Ricianfitting.x0 = [0, C2*max(abs(Smeasured)), 0.01, 0]'; 

% run the optimisation
[pmin1_Ric, fmin1_Ric] = fmincon(R2Ricianfitting); %fmin is the minimised SSE

% Next assume FAT DOMINANT TISSUE (Use first echo to provide water guess)
R2Ricianfitting.x0 = [C2*max(abs(Smeasured)), 0, 0.01, 0]'; 

% run the optimisation
[pmin2_Ric, fmin2_Ric] = fmincon(R2Ricianfitting); %fmin is the minimised SSE

%Add the two solutions to outparams
outparams.Rician.pmin1=pmin1_Ric;
outparams.Rician.pmin2=pmin2_Ric;

outparams.Rician.fmin1=fmin1_Ric;
outparams.Rician.fmin2=fmin2_Ric;

% Choose the estimates from the best residual and add to outparams

if fmin1_Ric<=fmin2_Ric
    
outparams.Rician.F = pmin1_Ric(1);
outparams.Rician.W = pmin1_Ric(2);
outparams.Rician.R2 = pmin1_Ric(3);

outparams.Rician.SSE = fmin1_Ric;

else
    
outparams.Rician.F = pmin2_Ric(1);
outparams.Rician.W = pmin2_Ric(2);
outparams.Rician.R2 = pmin2_Ric(3);

outparams.Rician.SSE = fmin2_Ric;

end



%% Set up the optimisation framework for  complex fitting

% Replicate settings from above
R2complexfitting.solver=R2fitting.solver;
R2complexfitting.options=R2fitting.options;
R2complexfitting.lb=R2fitting.lb;
R2complexfitting.ub=R2fitting.ub;
R2complexfitting.x0=R2fitting.x0;

% define the objective function
R2complexfitting.objective = @(p) R2ComplexObj(p,echotimes,tesla,Scomplex);

%% Implement complex fitting for both water-dominant and fat-dominant initialisations
% [F W R2* fB0]

% First assume WATER DOMINANT TISSUE (Use first echo to provide water guess)
R2complexfitting.x0 = [0, C2*max(abs(Smeasured)), 0.01, 0]'; 

%allow fB0 to vary:
% set the parameter lower bound
R2complexfitting.lb = [0, 0, -0.01, -1]'; %Set R2* < 0 as R2*=0 is used in simulations (?penalisation at boundary)
% % set the parameter upper bound
R2complexfitting.ub = [5*max(abs(Smeasured)), 5*max(abs(Smeasured)), 1, 1]'; 

% run the optimisation
[pmin1, fmin1] = fmincon(R2complexfitting); %fmin is the minimised SSE

% Next assume FAT DOMINANT TISSUE (Use first echo to provide water guess)
R2complexfitting.x0 = [C2*max(abs(Smeasured)), 0, 0.01, 0]'; 


% run the optimisation
[pmin2, fmin2] = fmincon(R2complexfitting); %fmin is the minimised SSE


%Add the two solutions to outparams
outparams.complex.pmin1=pmin1;
outparams.complex.pmin2=pmin2;

outparams.complex.fmin1=fmin1;
outparams.complex.fmin2=fmin2;

% Choose the estimates from the best residual

if fmin1<=fmin2
    
outparams.complex.F = pmin1(1);
outparams.complex.W = pmin1(2);
outparams.complex.R2 = pmin1(3);

outparams.complex.SSE = fmin1;

else
    
outparams.complex.F = pmin2(1);
outparams.complex.W = pmin2(2);
outparams.complex.R2 = pmin2(3);

outparams.complex.SSE = fmin2;

end

end


