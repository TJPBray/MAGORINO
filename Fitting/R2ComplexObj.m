function [sse] = R2ComplexObj(p,echotimes,tesla,Smeasured)
%function [sse] = R2ComplexObj(p,echotimes,Smeasured)

% Description: Computes the sum of squared errors between the data and the
% predicted data based on the parameters and fat model 
%
% Input:
%   p - the n-by-1 model parameter vector: 
%   p(1) is fat density
%   p(2) is water density
%   p(3) is R2*
%   p(4) is fB0 - ignored for now
%
%   echotimes - the n-by-1 echo times
%
%   Smeasured - the measured signals for each echo time 
%
%   sig is the standard deviation of the Gaussian distributions underlying
%   the Rician distribution.
%
% Model:
%   
%
%
% Output:
%   SSE
%
% Author: Tim Bray t.bray@ucl.ac.uk


%% Compute predicted outcomes from model parameters and the parameters
% Spredicted is computed from the fat model (amplitudes and frequencies) given in fatfunction

Spredicted = ComplexFatSingleR2(echotimes,tesla,p(1),p(2),p(3),0);

%% Calculate SSE

errors = Smeasured - Spredicted;

sse = errors'*errors;

end

