%Assigns PDFF and R2* labels to simulation grid 


function FigLabels
xticks([1 3 5 7 9 11]);
xticklabels({'0','200', '400', '600', '800','1000'});
xlabel('R2* (s^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
ylabel('PDFF','FontSize',12)
end