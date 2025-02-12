%Assigns PDFF and R2* labels to simulation grid 


function FigLabels(firstTeValues,deltaTeValues)
% xticks([1 3 5 7 9 11 13]);
xticks([1:1:numel(deltaTeValues)]);
xticklabels(num2cell(deltaTeValues));
xlabel('Delta TE values','FontSize',12)
% yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticks([1:1:numel(firstTeValues)]);
yticklabels(num2cell(firstTeValues));
ylabel('First TE values','FontSize',12)
end