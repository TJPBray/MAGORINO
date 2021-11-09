function [loglik,sse] = R2ComplexObj(p,echotimes,tesla,Smeasured,sig)
%function [loglik,sse] = R2ComplexObj(p,echotimes,tesla,Smeasured,sig)

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
%   Smeasured - the 1-by-m vector of measured signals for each echo time 
%
%   sig is the standard deviation of the Gaussian distributions.
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

%Supply 3 or 4 parameters to model function depending on input

if length(p)==3
    
Spredicted = MultiPeakFatSingleR2(echotimes,tesla,p(1),p(2),p(3),0);

elseif length(p)==4
    
Spredicted = MultiPeakFatSingleR2(echotimes,tesla,p(1),p(2),p(3),p(4));

else
    error('Incorrect number of parameters for R2ComplexObj')
    
end

%% Calculate SSE

errors = Smeasured - Spredicted;

sse = errors'*errors; %NB for complex matrices the transpose operation given the conjugate transpose (Hermitian transpose) - i.e. the complex conjugate of each element in the transpose - this dictates that the products of the individual imaginary components are positive

%% Calculate likelihood

%For real component of signals
loglik_real = GaussianLogLik(real(Smeasured), real(Spredicted), sig);

%For imaginary component of signals
loglik_imag = GaussianLogLik(imag(Smeasured), imag(Spredicted), sig);

%Overall likelihood given by sum of real and imaginary components:
loglik=loglik_real+loglik_imag;

end

