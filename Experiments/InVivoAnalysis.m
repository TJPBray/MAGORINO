function InVivoAnalysis(maps,indent)
%function InVivoAnalysis(maps)

%% Get image matrix size to enable choice of image region to evaluate
matSize=size(maps.FFrician,1);

%% Convert to vectors
FFrician=reshape(maps.FFrician(indent:matSize-indent,indent:matSize-indent),[],1);
R2rician=reshape(maps.R2rician(indent:matSize-indent,indent:matSize-indent),[],1);
FFgaussian=reshape(maps.FFstandard(indent:matSize-indent,indent:matSize-indent),[],1);
R2gaussian=reshape(maps.R2standard(indent:matSize-indent,indent:matSize-indent),[],1);
FFdiff=FFgaussian-FFrician;
R2diff=R2gaussian-R2rician;


%% Plot 

figure

subplot(4,4,1)
imshow(maps.FFstandard(indent:matSize-indent,indent:matSize-indent),[0 1])
title('PDFF Gaussian')
colormap('parula')

subplot(4,4,2)
imshow(maps.FFrician(indent:matSize-indent,indent:matSize-indent),[0 1])
title('PDFF Rician')
colormap('parula')

subplot(4,4,3)
imshow(maps.R2standard(indent:matSize-indent,indent:matSize-indent),[0 0.5])
title('R2* Gaussian')

subplot(4,4,4)
imshow(maps.R2rician(indent:matSize-indent,indent:matSize-indent),[0 0.5])
title('R2* Rician')

subplot(4,2,3)
scatter(FFrician,FFgaussian)
xlabel('PDFF Rician')
ylabel('PDFF Gaussian')
xlim([0 1])

subplot(4,2,4)
scatter(R2rician,R2gaussian)
xlabel('R2* Rician')
ylabel('R2* Gaussian')
xlim([0 1])
ylim([0 1])
hold on
plot([0 1],[0 1],'k--')
hold off

subplot(4,2,5)
scatter3(R2rician,FFrician,FFdiff,15,FFdiff,'filled')
xlabel('R2* Rician')
ylabel('PDFF Rician')
zlabel('PDFF Rician - PDFF Gaussian')
xlim([0 1])
title('PDFF bias')
c=colorbar;
c.Label.String=('PDFF Gaussian - PDFF Rician');
ax=gca;
ax.CLim=[-1 1];

subplot(4,2,6)
scatter3(R2rician,FFrician,R2diff,15,R2diff,'filled')
xlabel('R2* Rician')
ylabel('PDFF Rician')
zlabel('R2* Rician - R2* Gaussian')
xlim([0 1])
title('R2* bias')
c=colorbar;
c.Label.String=('R2* Gaussian - R2* Rician');
ax=gca;
ax.CLim=[-0.2 0.2];

subplot(4,2,7)
scatter3(R2rician,FFrician,FFdiff,15,FFdiff,'filled')
xlabel('R2* Rician')
ylabel('PDFF Rician')
zlabel('PDFF Rician - PDFF Gaussian')
xlim([0 1])
title('PDFF bias')
c=colorbar;
c.Label.String=('PDFF Gaussian - PDFF Rician');
view(0,90)
ax=gca;
ax.CLim=[-1 1];
set(gca, 'YDir','reverse')

subplot(4,2,8)
scatter3(R2rician,FFrician,R2diff,15,R2diff,'filled')
xlabel('R2* Rician')
ylabel('PDFF Rician')
zlabel('R2* Gaussian - R2* Rician')
xlim([0 1])
title('R2* bias')
colorbar
c=colorbar;
c.Label.String=('R2* Gaussian - R2* Rician');
view(0,90)
ax=gca;
ax.CLim=[-0.2 0.2];
set(gca, 'YDir','reverse')

end
