function [tableGaussian,tableRician] = tabulateCoeffs(regressionModels,saveFolderInfo)
% function table = tabulateCoeffs[regressionModels,saveFolderInfo]

for n = 1:numel(regressionModels)

%% 1. For Gaussian 

%Rsquared
Rsquared.gaussian(n,1)=regressionModels{n}.ffGaussian.Rsquared.Ordinary;

%Coefficients
slope.gaussian(n,1)=table2array(regressionModels{n}.ffGaussian.Coefficients(2,1));
intercept.gaussian(n,1)=table2array(regressionModels{n}.ffGaussian.Coefficients(1,1));
    
%95% CIs
cis = coefCI(regressionModels{n}.ffGaussian);
slopeLowerCI.gaussian(n,1)=cis(2,1);
slopeUpperCI.gaussian(n,1)=cis(2,2);
interceptLowerCI.gaussian(n,1)=cis(1,1);
interceptUpperCI.gaussian(n,1)=cis(1,2);

%% 2. For Rician

%Rsquared
Rsquared.rician(n,1)=regressionModels{n}.ffRician.Rsquared.Ordinary;

%Coefficients
slope.rician(n,1)=table2array(regressionModels{n}.ffRician.Coefficients(2,1));
intercept.rician(n,1)=table2array(regressionModels{n}.ffRician.Coefficients(1,1));
    
%95% CIs
cis = coefCI(regressionModels{n}.ffRician);
slopeLowerCI.rician(n,1)=cis(2,1);
slopeUpperCI.rician(n,1)=cis(2,2);
interceptLowerCI.rician(n,1)=cis(1,1);
interceptUpperCI.rician(n,1)=cis(1,2);

%% 3. Protocol name
protocolInfo = saveFolderInfo(n+2,1);
protocol{n}=protocolInfo.name;

end


%% 3. Create table with regression values for export
varNames= {'Protocol','R^2', 'Slope', 'Slope 95% lower', 'Slope 95% upper', 'Intercept', 'Intercept 95% lower', 'Intercept 95% upper'}
tableGaussian = table(protocol',Rsquared.gaussian,slope.gaussian,slopeLowerCI.gaussian,slopeUpperCI.gaussian,intercept.gaussian,interceptLowerCI.gaussian,interceptUpperCI.gaussian,'VariableNames',varNames)
tableRician = table(protocol',Rsquared.rician,slope.rician,slopeLowerCI.rician,slopeUpperCI.rician,intercept.rician,interceptLowerCI.rician,interceptUpperCI.rician,'VariableNames',varNames)
end

