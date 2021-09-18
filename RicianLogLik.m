function [loglik, logliks] = RicianLogLik(measurements, predictions, sigma)
% function [loglik, logliks] = RicianLogLik(measurements, predictions, sigma)
% 
% Computes the log likelihood of the measurements given the model
% predictions for the Rician noise model with the noise standard
% deviation sigma.
%
%
% INPUT:
%
% 1. measurements - a N-by-1 array storing the measurements
%                    (inclusive of noise)
%
% 2. predictions  - a N-by-1 array, the same size as the measurements,
%                   storing the predictions computed from a model
%
% 3. sigma -  the standard deviation of the Gaussian distributions
%             underlying the Gaussian distribution. this can either be a
%             single (positive) value or a N-by-1 array.
%
% OUTPUT:
%
% 1. loglik - the total log likelihood
%
% 2. logliks - the log likelihood for individual measurements
%
%
% Author: Daniel C Alexander (d.alexander@ucl.ac.uk)
%
%         Gary Zhang (gary.zhang@ucl.ac.uk)
%

% squared sigma(s)
sigmaSquared = sigma.^2;

% sum of squared measurements and predictions, normalised by squared
% sigma(s) (halved)
sumsqsc = (measurements.^2 + predictions.^2)./(2*sigmaSquared);

% product of measurements and predictions, normalised by squared sigma(s)
scp = measurements.*predictions./sigmaSquared;

% logarithm of the product just computed
lb0 = logbesseli0(scp);

% log likelihoods (of each measurement)
logliks = log(predictions) - log(sigmaSquared) - sumsqsc + lb0;

% total log likelihood
loglik = sum(logliks);
