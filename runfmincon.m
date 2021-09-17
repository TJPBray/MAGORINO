%function [xsol,fval,history,searchdir] = runfmincon

%Used to plot intermediate results from fmincon solver 

function [outparams,searchdir] = runfmincon(echotimes, tesla, Snoisy, sig)
 
% Set up shared variables with outfun
history.p = [];
history.f = [];
searchdir = [];
 
%% Set up the optimisation framework for standard magnitude fitting

Sinit=100;
vinit=0.1;
vmax=1;
vmin=0; %negative value for min to avoid penalisation at boundary

% define the objective function
R2fitting.objective = @(p) R2Obj(p,echotimes,tesla,Snoisy);

% set the solver 
R2fitting.solver = 'fmincon';

% set the parameter lower bound
R2fitting.lb = [0, 0, vmin, 0]'; %Set R2* < 0 as R2*=0 is used in simulations (?penalisation at boundary)

% % set the parameter upper bound
R2fitting.ub = [3*Sinit, 3*Sinit, vmax, 0]'; %constrain fB0 to 0 for now

%% Specify options, including output function (additional to standard fitting)

R2fitting.options = optimoptions('fmincon','OutputFcn',@outfun, 'Algorithm', 'interior-point','InitBarrierParam',100000,'ScaleProblem',true,'FiniteDifferenceType','central');
%Barrier parameter might reduce step size and avoid bypassing of correct
%minimum; can include 'InitBarrierParam',100, in options
%'FiniteDifferenceType','central' might improve accuracy of derivative
%estimation

%% Implement standard magnitude fitting for both water-dominant and fat-dominant initialisations

% First assume WATER DOMINANT TISSUE (Use first echo to provide water guess)
R2fitting.x0 = [0, Sinit, vinit, 0]'; 

% Run fmincon
[outparams.standard.pmin1, outparams.standard.fmin1] = fmincon(R2fitting); %fmin is the minimised SSE

% Calculate FF values at each iteration 
outparams.standard.FF1=100*history.p(1,:)./(history.p(1,:)+history.p(2,:));
outparams.standard.R2_1=history.p(3,:);

% Re-initialise history
history.p = [];
history.f = [];
searchdir = [];

% Next assume WATER DOMINANT TISSUE (Use first echo to provide water guess)
R2fitting.x0 = [Sinit, 0, vinit, 0]'; 

% Run fmincon
[outparams.standard.pmin2, outparams.standard.fmin2] = fmincon(R2fitting); %fmin is the minimised SSE

% Calculate FF values at each iteration 
outparams.standard.FF2=100*history.p(1,:)./(history.p(1,:)+history.p(2,:));
outparams.standard.R2_2=history.p(3,:);

 function stop = outfun(p,optimValues,state)
     stop = false;
 
     switch state
         case 'init'
             hold on
         case 'iter'
         % Concatenate current point and objective function
         % value with history. x must be a row vector.
           history.f = horzcat(history.f,optimValues.fval);
           history.p = horzcat(history.p, p);
           
%          % Concatenate current search direction with 
%          % searchdir.
%            searchdir = [searchdir;... 
%                         optimValues.searchdirection'];
%            plot(x(1),x(2),'o');
%          % Label points with iteration number and add title.
%          % Add .15 to x(1) to separate label from plotted 'o'.
%            text(x(1)+.15,x(2),... 
%                 num2str(optimValues.iteration));
%            title('Sequence of Points Computed by fmincon');
         case 'done'
             hold off
         otherwise
     end
 end
 
figure
subplot(1,2,1)
plot(outparams.standard.R2_1,outparams.standard.FF1,'Marker','o')
subplot(1,2,2)
plot(outparams.standard.R2_2,outparams.standard.FF2,'Marker','x')

xlabel('R2star')
ylabel('FF')
ylim([0 100])

%  function f = objfun(x)
%      f = exp(x(1))*(4*x(1)^2 + 2*x(2)^2 + 4*x(1)*x(2) +... 
%                     2*x(2) + 1);
%  end
%  
%  function [c, ceq] = confun(x)
%      % Nonlinear inequality constraints
%      c = [1.5 + x(1)*x(2) - x(1) - x(2);
%          -x(1)*x(2) - 10];
%      % Nonlinear equality constraints
%      ceq = [];
%  end
end