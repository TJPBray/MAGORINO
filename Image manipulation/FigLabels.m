%Assigns PDFF and R2* labels to simulation grid 


function FigLabels
% xticks([1 3 5 7 9 11 13]);
xticks([1 5 9 13 17 21]);
xticklabels({'0','100', '200', '300', '400','500'});
xlabel('R2* (s^-^1)','FontSize',12)
% yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticks([1 11 21 31 41 51 61 71 81 91 101]);
yticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
ylabel('Fat fraction','FontSize',12)
end