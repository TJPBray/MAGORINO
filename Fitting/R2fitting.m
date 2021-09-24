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
vmax=1;
vmin=0; %negative value for min to avoid penalisation at boundary

%Set signal initialisation for fat and water: Sinit
C=exp(vinit);
Sinit=C*max(Smagnitude); %partially compensates for R2* to improve initialisation
% Sinit=100;

%% Set up the optimisation framework for standard magnitude fitting

% define the objective function
R2fitting.objective = @(p) -R2Obj(p,echotimes,tesla,Smagnitude,sig);

% set the solver 
R2fitting.solver = 'fmincon';

% use interior-point
R2fitting.options = optimoptions('fmincon', 'Algorithm', 'interior-point','InitBarrierParam',100000,'ScaleProblem',true,'FiniteDifferenceType','central');
%Barrier parameter might reduce step size and avoid bypassing of correct
%minimum; can include 'InitBarrierParam',100, in options
%'FiniteDifferenceType','central' might improve accuracy of derivative
%estimation

% set the parameter lower bound
R2fitting.lb = [0, 0, vmin]'; 

% % set the parameter upper bound
R2fitting.ub = [3*Sinit, 3*Sinit, vmax]'; %constrain fB0 to 0 for now


%% Implement standard magnitude fitting for both water-dominant and fat-dominant initialisations
% [F W R2* fB0]

% First assume LOW FF (WATER DOMINANT) TISSUE (Use first echo to provide water guess)
R2fitting.x0 = [0.001, Sinit, vinit]'; 

% run the optimisation
[pmin1_mag, fmin1_mag] = fmincon(R2fitting); %fmin is the minimised SSE

% Next assume HIGH FF (FAT DOMINANT) TISSUE (Use first echo to provide water guess)
R2fitting.x0 = [Sinit, 0.001, vinit]'; 

% run the optimisation
[pmin2_mag, fmin2_mag] = fmincon(R2fitting); %fmin is the minimised SSE

% Next INITIALISE WITH GROUND TRUTH
R2fitting.x0 = GT; 

% run the optimisation
[pmin3_mag, fmin3_mag] = fmincon(R2fitting); %fmin is the minimised SSE

%Add the two solutions to outparams
outparams.standard.pmin1=pmin1_mag;
outparams.standard.pmin2=pmin2_mag;
outparams.standard.pmin3=pmin3_mag;

outparams.standard.fmin1=fmin1_mag;
outparams.standard.fmin2=fmin2_mag;
outparams.standard.fmin3=fmin3_mag;

% Choose the estimates from the best residual and add those to the
% outparams structure
if fmin1_mag<=fmin2_mag
    
outparams.standard.F = pmin1_mag(1);
outparams.standard.W = pmin1_mag(2);
outparams.standard.R2 = pmin1_mag(3);

outparams.standard.fmin = fmin1_mag;
outparams.standard.chosenmin=1;

% Calculate SSE for standard (Gaussian) fitting (NB this is different to fmin above, which corresponds to likelihood)
[~,outparams.standard.SSE]=R2Obj(pmin1_mag,echotimes,tesla,Smeasured,sig)

else
    
outparams.standard.F = pmin2_mag(1); %swap fat and water from lines above
outparams.standard.W = pmin2_mag(2);
outparams.standard.R2 = pmin2_mag(3);

outparams.standard.fmin = fmin2_mag;
outparams.standard.chosenmin=2;

% Calculate SSE for standard (Gaussian) fitting (NB this is different to fmin above, which corresponds to likelihood)
[~,outparams.standard.SSE]=R2Obj(pmin2_mag,echotimes,tesla,Smeasured,sig)
end



%% Set up the optimisation framework for  magnitude fitting with Rician noise modelling

% Replicate settings from above
R2Ricianfitting.solver=R2fitting.solver;
R2Ricianfitting.options=R2fitting.options;
R2Ricianfitting.lb=R2fitting.lb;
R2Ricianfitting.ub=R2fitting.ub;
R2Ricianfitting.x0=R2fitting.x0;

% define the objective function
R2Ricianfitting.objective = @(p) -R2RicianObj(p,echotimes,tesla,Smagnitude,sig); 

%% Implement Rician fitting for both water-dominant and fat-dominant initialisations
% [F W R2* fB0]

% First assume LOW FF (WATER DOMINANT) TISSUE (Use first echo to provide water guess)
R2Ricianfitting.x0 = [0.001, Sinit, vinit]'; 

% run the optimisation
[pmin1_Ric, fmin1_Ric] = fmincon(R2Ricianfitting); %fmin is the minimised SSE

% Next assume HIGH FF (FAT DOMINANT) TISSUE (Use first echo to provide water guess)
R2Ricianfitting.x0 = [Sinit, 0.001, vinit]'; 

% run the optimisation
[pmin2_Ric, fmin2_Ric] = fmincon(R2Ricianfitting); %fmin is the minimised SSE

% Next INITIALISE WITH GROUND TRUTH
R2Ricianfitting.x0 = GT; 

% run the optimisation
[pmin3_Ric, fmin3_Ric] = fmincon(R2Ricianfitting); %fmin is the minimised SSE

%Add the  solutions to outparams
outparams.Rician.pmin1=pmin1_Ric;
outparams.Rician.pmin2=pmin2_Ric;
outparams.Rician.pmin3=pmin3_Ric;

outparams.Rician.fmin1=fmin1_Ric;
outparams.Rician.fmin2=fmin2_Ric;
outparams.Rician.fmin3=fmin3_Ric;

% Choose the estimates from the best residual and add to outparams

if fmin1_Ric<=fmin2_Ric
    
outparams.Rician.F = pmin1_Ric(1);
outparams.Rician.W = pmin1_Ric(2);
outparams.Rician.R2 = pmin1_Ric(3);

outparams.Rician.fmin = fmin1_Ric; %For Rician fitting, fmin corresponds to the maximum likelihood (i.e. lowest value of -fmin)
outparams.Rician.chosenmin=1;

% Calculate SSE for Rician fitting (NB this is different to fmin above, which corresponds to likelihood)
[~,outparams.Rician.SSE]=R2Obj(pmin1_Ric,echotimes,tesla,Smeasured,sig) %Can use R2Obj here to calculate SSE rather than R2RicianObj

else
    
outparams.Rician.F = pmin2_Ric(1);
outparams.Rician.W = pmin2_Ric(2);
outparams.Rician.R2 = pmin2_Ric(3);

outparams.Rician.fmin = fmin2_Ric; %For Rician fitting, fmin corresponds to the maximum likelihood (i.e. lowest value of -fmin)
outparams.Rician.chosenmin=2;

% Calculate SSE for Rician fitting (NB this is different to fmin above, which corresponds to likelihood)
[~,outparams.Rician.SSE]=R2Obj(pmin2_Ric,echotimes,tesla,Smeasured,sig) %Can use R2Obj here to calculate SSE rather than R2RicianObj

end

% Calculate SSE for Rician fitting (NB this is different to fmin above, which corresponds to likelihood)
% outparams.Rician.SSE = MultiPeakFatSingleR2([outparams.Rician.F, outparams.Rician.W, outparams.Rician.R2, 0],echotimes,tesla,Smeasured);


%% Set up the optimisation framework for  complex fitting

% Replicate settings from above
R2complexfitting.solver=R2fitting.solver;
R2complexfitting.options=R2fitting.options;
R2complexfitting.lb=R2fitting.lb;
R2complexfitting.ub=R2fitting.ub;
R2complexfitting.x0=R2fitting.x0;

% define the objective function
R2complexfitting.objective = @(p) -R2ComplexObj(p,echotimes,tesla,Scomplex,sig);

%% Implement complex fitting for both water-dominant and fat-dominant initialisations
% [F W R2* fB0]

% First assume LOW FF (WATER DOMINANT) TISSUE (Use first echo to provide water guess)
R2complexfitting.x0 = [0.001, Sinit, vinit]'; 

%allow fB0 to vary:
% set the parameter lower bound
R2complexfitting.lb = [0, 0, vmin]';
% % set the parameter upper bound
R2complexfitting.ub = [3*Sinit, 3*Sinit, vmax]'; 

% run the optimisation
[pmin1, fmin1] = fmincon(R2complexfitting); %fmin is the minimised SSE

% Next assume HIGH FF (FAT DOMINANT) TISSUE (Use first echo to provide water guess)
R2complexfitting.x0 = [Sinit, 0.001, vinit]'; 

% run the optimisation
[pmin2, fmin2] = fmincon(R2complexfitting); %fmin is the minimised SSE

% Next INITIALISE WITH GROUND TRUTH
R2complexfitting.x0 = GT; 

% run the optimisation
[pmin3, fmin3] = fmincon(R2complexfitting); %fmin is the minimised SSE


%Add the solutions to outparams
outparams.complex.pmin1=pmin1;
outparams.complex.pmin2=pmin2;
outparams.complex.pmin3=pmin3;

outparams.complex.fmin1=fmin1;
outparams.complex.fmin2=fmin2;
outparams.complex.fmin3=fmin3;

% Choose the estimates from the best residual

if fmin1<=fmin2
    
outparams.complex.F = pmin1(1);
outparams.complex.W = pmin1(2);
outparams.complex.R2 = pmin1(3);

outparams.complex.fmin = fmin1;
outparams.complex.chosenmin=1;

% Calculate SSE for Rician fitting (NB this is different to fmin above, which corresponds to likelihood)
[~,outparams.complex.SSE]=R2ComplexObj(pmin1,echotimes,tesla,Smeasured,sig) %Can use R2Obj here to calculate SSE rather than R2RicianObj

else
    
outparams.complex.F = pmin2(1);
outparams.complex.W = pmin2(2);
outparams.complex.R2 = pmin2(3);

outparams.complex.fmin = fmin2;
outparams.complex.chosenmin=2;

% Calculate SSE for Rician fitting (NB this is different to fmin above, which corresponds to likelihood)
[~,outparams.complex.SSE]=R2ComplexObj(pmin2,echotimes,tesla,Smeasured,sig) %Can use R2Obj here to calculate SSE rather than R2RicianObj

end

end



