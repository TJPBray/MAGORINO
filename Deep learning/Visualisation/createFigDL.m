function  createFigDL(predictionVec,yTest,FFvals,R2vals,figTitle)
% function  createFigDL(predictionVec,ytest)

%Helper function for visualising performance of DL methods over a range of
%FF values

%Written by Dr Tim Bray
%t.bray@ucl.ac.uk
%November 2022

%Inputs
% predictionVec is an nx2 prediction of FF and R2* values
% yTest is an nx2 matrix of ground truth FF and R2* values
% FFvals is an nx1 vector of FF values used for testing
% R2vals is an nx1 vector of R2* values used for testing
% title is a string specifying the title of the figure

%Split prediction vector into FF and R2*
predictionVecFF=predictionVec(:,1);
predictionVecR2=predictionVec(:,2);

%Get errorgrids
ffErrorVec=predictionVecFF-yTest(:,1);
r2ErrorVec=predictionVecR2-yTest(:,2);

% Reshape prediction data for plotting
ffPredictions = reshape(predictionVecFF,[numel(FFvals) numel(R2vals)]);
r2Predictions = reshape(predictionVecR2,[numel(FFvals) numel(R2vals)]);
ffError = reshape(ffErrorVec,[numel(FFvals) numel(R2vals)]);
r2Error = reshape(r2ErrorVec,[numel(FFvals) numel(R2vals)]);

%Plot 

figure('Name', figTitle)

subplot(2,2,1)
image(ffPredictions,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
colorbar
xticks([1:2:21]);
xticklabels({'0','.50', '100', '150', '200', '250', '300', '350', '400', '450','500'});
xlabel('R2* (s^-^1)','FontSize',12)
yticks([0 10 20 30 40 50 60 70 80 90 100]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('FF values')
colorbar
view(0,90)


subplot(2,2,2)
image(r2Predictions,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
FigLabels;
colorbar
xticks([1:2:21]);
xticklabels({'0','.50', '100', '150', '200', '250', '300', '350', '400', '450','500'});
xlabel('R2* (s^-^1)','FontSize',12)
yticks([0 10 20 30 40 50 60 70 80 90 100]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('R2* values')
colorbar
view(0,90)

subplot(2,2,3)
image(ffError,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-01 01];
FigLabels;
colorbar
xticks([1:2:21]);
xticklabels({'0','.50', '100', '150', '200', '250', '300', '350', '400', '450','500'});
xlabel('R2* (s^-^1)','FontSize',12)
yticks([0 10 20 30 40 50 60 70 80 90 100]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('FF error')
colorbar
view(0,90)

subplot(2,2,4)
image(r2Error,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-01 01];
FigLabels;
colorbar
xticks([1:2:21]);
xticklabels({'0','.50', '100', '150', '200', '250', '300', '350', '400', '450','500'});
xlabel('R2* (s^-^1)','FontSize',12)
yticks([0 10 20 30 40 50 60 70 80 90 100]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('R2* error')
colorbar
view(0,90)

end

