function [likVec,sseVec] = sseVecCalc (echotimes, tesla, predictionVec, S, sigma) 
% function likVec,sseVec = sseVecCalc (echotimes, tesla, predictionVec, S) 

%Calculates a vector of SSE values from the predictions of neural network


% Input:
% echotimes as an m-by-1 vector
% tesla is scalar-valued field strength
% Smeasured is n-by-1 measured signal vector
% predictionVec is the n-by-2 predictions (FF and R2star)
% sigma (the standard deviation of the Gaussian distributions underlying
%   the Rician distribution

% Output:
% likVec is an output of likelihood values based on the above

% 1. Get n
n=size(predictionVec,1);



%2. Loop over n values
for k=1:n
    
    %2.1 First specify components of p
    p(1)=predictionVec(k,1);
    p(2)=1-p(1);
    p(3)=predictionVec(k,2);
    p(4)=0;

Smeasured=S(k,:);


    %2.2 Calculate likelihood (use Gaussian initially)
    [likVec(k),sseVec(k)] = R2Obj(p,echotimes,tesla,Smeasured,0);
   

end

end

