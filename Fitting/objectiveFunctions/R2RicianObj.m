function [loglik] = R2RicianObj(p,echotimes,tesla,Smeasured,sig)
%function [loglik] = R2RicianObj(p,echotimes,Smeasured)

% Description: Gives the log likelihood of measuring the signals Smeasured
% given the model parameters and the noise standard deviation sigma. This
% likelihood can be optimised in the fitting by ...
%
% Input:
%   p - the n-by-m model parameter vector, where n is the number of parameters and 
%   m is the number of examples (note that this was extended from n-by-1 to allow vectorised implementations): 
%   p(1,:) is fat density
%   p(2,:) is water density
%   p(3,:) is R2*
%   p(4,:) is fB0
%
%   echotimes - the T-by-1 echo times, wherre T is the total number of echo
%   times
%
%   Smeasured - the m-by-T vector of measured signals for each echo time 
%
%   sig is the standard deviation of the Gaussian distributions underlying
%   the Rician distribution.
%
% Model:
% Rician noise
%
% Output:
%   loglik - either a scalar value (optimised by fmincon) or an m-by-1 parameter vector
%
% Author: Tim Bray t.bray@ucl.ac.uk


%% Compute predicted outcomes from model parameters and the parameters
% Spredicted is computed from the fat model (amplitudes and frequencies) given in fatfunction

Spredicted = abs(MultiPeakFatSingleR2(echotimes,tesla,p(1,:)',p(2,:)',p(3,:)',0)); %take magnitude of output from fatfunction

%% Take magnitude of S measured

Smeasured = abs(Smeasured);

%% Calculate log likelihood

loglik = RicianLogLik(Smeasured, Spredicted, sig);

end

