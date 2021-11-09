function [loglik,sse] = R2Obj(p,echotimes,tesla,Smeasured,sig)
%function [loglik,sse] = R2Obj(p,echotimes,tesla,Smeasured,sig)

% Description: Computes the sum of squared errors between the data and the
% predicted data based on the parameters and fat model 
%
% Input:
%   p - the n-by-1 model parameter vector: 
%   p(1) is fat density
%   p(2) is water density
%   p(3) is R2*
%   p(4) is fB0
%
%   echotimes - the n-by-1 echo times
%
%   Smeasured - the 1-by-m vector of measured signals for each echo time 
%
% Model:
%   
% Output:
% loglik - optimised by fmincon
% sse - should be ignored by fmincon but can be obtained in a separate call
% to the function
%
% Output:
%   SSE
%
% Author: Tim Bray t.bray@ucl.ac.uk


%% Compute predicted outcomes from model parameters and the parameters
% Spredicted is computed from the fat model (amplitudes and frequencies) given in fatfunction

Spredicted = MultiPeakFatSingleR2(echotimes,tesla,p(1),p(2),p(3),0);

%% Calculate SSE

errors = abs(Spredicted) - abs(Smeasured); %use magnitude

sse = sum(errors.^2);

%% Calculate likelihood

%For imaginary component of signals
loglik = GaussianLogLik(abs(Smeasured), abs(Spredicted), sig);

end

