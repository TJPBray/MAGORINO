function [loglik, logliks] = GaussianLogLik(measurements, predictions, sigma)
% function [loglik, logliks] = GaussianLogLik(measurements, predictions, sigma)
% 
% Computes the log likelihood of the measurements given the model
% predictions for the Gaussian noise model with the noise standard
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
% Author: Gary Zhang (gary.zhang@ucl.ac.uk)
%

% squared errors between the measurements and the predictions from a model
squaredErrors = (measurements - predictions).^2;

% sigma squared
sigmaSquared = sigma.^2;

% chi-square errors - by normalising squared errors by sigma squared
chiSquaredErrors = squaredErrors./sigmaSquared;

% log likelihoods (of each measurement)
logliks = -0.5*log((2*pi)*sigmaSquared) - 0.5*chiSquaredErrors;

% total log likelihood
loglik = sum(logliks,2);
