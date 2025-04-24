function [tableGaussian,tableRician] = tabulateCoeffs(ff,regressionModels,site, protocol, ReferenceValues,saveFolderInfo)
% function table = tabulateCoeffs[regressionModels,saveFolderInfo]

%% Create subplots with reference values to plot on later
figure
% Gaussian subplots
g(1)=subplot(4,2,1)
plot(ReferenceValues.FF,ReferenceValues.FF,'k-','LineWidth',1)
title('1.5T protocol 1')

g(2)=subplot(4,2,3)
plot(ReferenceValues.FF,ReferenceValues.FF,'k-','LineWidth',1)
title('1.5T protocol 2')

g(3)=subplot(4,2,5)
plot(ReferenceValues.FF,ReferenceValues.FF,'k-','LineWidth',1)
title('3T protocol 3')

g(4)=subplot(4,2,7)
plot(ReferenceValues.FF,ReferenceValues.FF,'k-','LineWidth',1)
title('3T protocol 4')

% Rician subplots
r(1)=subplot(4,2,2)
plot(ReferenceValues.FF,ReferenceValues.FF,'k-','LineWidth',1)
title('1.5T protocol 1')

r(2)=subplot(4,2,4)
plot(ReferenceValues.FF,ReferenceValues.FF,'k-','LineWidth',1)
title('1.5T protocol 2')

r(3)=subplot(4,2,6)
plot(ReferenceValues.FF,ReferenceValues.FF,'k-','LineWidth',1)
title('3T protocol 3')

r(4)=subplot(4,2,8)
plot(ReferenceValues.FF,ReferenceValues.FF,'k-','LineWidth',1)
title('3T protocol 4')

%% Create colours and symbols for display in loops
colours = [1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 0; 0 0.4 0.7]; %red green blue cyan magenta yellow otherblue (semitransparent)
symbols = {'x','+','>','d','o','<','x'};
sizes = [8 6 5 5 4 3 2];

%% Loop over protocols/sites
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

% axes(g(protocol(n))) %Select axis for relevant site
% hold on 
% plot(ReferenceValues.FF,ff{n}.standard.mean,'--','LineWidth',1,'Color',colours(site(n),:),'Marker',symbols{site(n)},'MarkerSize',sizes(site(n)))
% xlabel('Reference FF','FontSize',12)
% ylabel('Gaussian PDFF','FontSize',12)
% xlim([0 1])
% ylim([0 1])
% % %Add legend at last protocol
% % if protocol(n)==4
% %     legend('ReferenceFF','Protocol 1','Protocol 2','Protocol 3', 'Protocol 4')
% % else ;
% % end
% hold off

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

axes(r(protocol(n))) %Select axis for relevant site
hold on 
plot(ReferenceValues.FF,ff{n}.rician.mean,'--','LineWidth',1,'Color',colours(site(n),:),'Marker',symbols{site(n)},'MarkerSize',sizes(site(n)))
xlabel('Reference FF','FontSize',12)
ylabel('Measured PDFF','FontSize',12)
xlim([0 1])
ylim([0 1])
%Add legend at last protocol
if site(n)==6 & protocol(n)==4
    legend('Unity','Site 1','Site 2','Site 3', 'Site 4', ' Site 5', 'Site 6', 'Site 7','FontSize',12)
else ;
end

hold off

%% 3. Protocol name
protocolInfo = saveFolderInfo(n+2,1);
protName{n}=protocolInfo.name;

end


%% 3. Create table with regression values for export

import mlreportgen.dom.*
setDefaultNumberFormat("%0.3f");

varNames= {'Protocol name','Protocol number','Site','R^2', 'Slope', 'Slope 95% lower', 'Slope 95% upper', 'Intercept', 'Intercept 95% lower', 'Intercept 95% upper'}
tableGaussian = table(protName',protocol',site',Rsquared.gaussian,slope.gaussian,slopeLowerCI.gaussian,slopeUpperCI.gaussian,intercept.gaussian,interceptLowerCI.gaussian,interceptUpperCI.gaussian,'VariableNames',varNames)
tableRician = table(protName',protocol',site',Rsquared.rician,slope.rician,slopeLowerCI.rician,slopeUpperCI.rician,intercept.rician,interceptLowerCI.rician,interceptUpperCI.rician,'VariableNames',varNames)

%Sort by protocol number before export
tableRician = sortrows(tableRician,2,'ascend');
tableGaussian = sortrows(tableGaussian,2,'ascend');


end

