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
%   normalisedSignals = exp(-p(1)*bValues + p(2)*bValues^2*p(1)^2/6)
%
%
% Output:
%   SSE
%
% Author: Tim Bray t.bray@ucl.ac.uk


%% Compute predicted outcomes from model parameters and the parameters
% Spredicted is computed from the fat model (amplitudes and frequencies) given in fatfunction

Spredicted = Fatfunction(echotimes,tesla,p(1),p(2),p(3),p(4));

Spred_comp(1,:)=real(Spredicted);
Spred_comp(2,:)=imag(Spredicted);

%%Convert S measured to two rows
Smeasured_comp(1,:)=real(Smeasured);
Smeasured_comp(2,:)=imag(Smeasured);

%% Calculate SSE

errors = abs(Spred_comp) - abs(Smeasured_comp); %use magnitude

sse = sum(errors.^2,'all');

end

