function [loglik] = R2RicianObj(p,echotimes,tesla,Smeasured,sig)
%function [loglik] = R2RicianObj(p,echotimes,Smeasured)

% Description: Gives the log likelihood of measuring the signals Smeasured
% given the model parameters and the noise standard deviation sigma. This
% likelihood can be optimised in the fitting by ...
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
%   Log likelihood
%
% Author: Tim Bray t.bray@ucl.ac.uk


%% Compute predicted outcomes from model parameters and the parameters
% Spredicted is computed from the fat model (amplitudes and frequencies) given in fatfunction

Spredicted = abs(Fatfunction(echotimes,tesla,p(1),p(2),p(3),p(4))); %take magnitude of output from fatfunction

%% Take magnitude of S measured

Smeasured = abs(Smeasured);

%% Calculate log likelihood

sumsqsc = (Spredicted.^2 + Smeasured.^2)./(2*sig.^2);
scp = Smeasured.*Spredicted./(sig.^2);
lb0 = logbesseli0(scp)';  %transpose added here as I presume this should be a row vector (previously a column)
logliks = - 2*log(sig) - sumsqsc + log(Smeasured) + lb0;
loglik = sum(logliks);


end

