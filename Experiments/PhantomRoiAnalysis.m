%% Extract values from PDFF maps and phantom ROIs and generate agreement plots against reference standard
% Author:
% Tim Bray, t.bray@ucl.ac.uk
% January 2022

function PhantomRoiAnalysis(maps,phantomROIs,ReferenceValues,ffVendor,r2starVendor)


%% 2. Get measurements for each ROI

%2.1 For FF measurements
[ff.standard.mean, ff.standard.sd, ff.standard.n] = RoiStats(maps.FFstandard,phantomROIs);
[ff.rician.mean, ff.rician.sd, ff.rician.n] = RoiStats(maps.FFrician,phantomROIs);
[ff.complex.mean, ff.complex.sd, ff.complex.n] = RoiStats(maps.FFcomplex,phantomROIs);
[ff.vendor.mean, ff.vendor.sd, ff.vendor.n] = RoiStats(ffVendor,phantomROIs);

%2.2 For R2* measurements
[r2.standard.mean, r2.standard.sd, r2.standard.n] = RoiStats(maps.R2standard,phantomROIs);
[r2.rician.mean, r2.rician.sd, r2.rician.n] = RoiStats(maps.R2rician,phantomROIs);
[r2.complex.mean, r2.complex.sd, r2.complex.n] = RoiStats(maps.R2complex,phantomROIs);
[r2.vendor.mean, r2.vendor.sd, r2.vendor.n] = RoiStats(r2starVendor,phantomROIs);

%% 3. Reshape for visualisation

%3.1 For FF measurements
ff.standard.meangrid = reshape(ff.standard.mean,[4,5]);
ff.rician.meangrid = reshape(ff.rician.mean,[4,5]);
ff.complex.meangrid = reshape(ff.complex.mean,[4,5]);
ff.vendor.meangrid = reshape(ff.vendor.mean,[4,5]);

%3.2 For R2* measurements
r2.standard.meangrid = reshape(r2.standard.mean,[4,5]);
r2.rician.meangrid = reshape(r2.rician.mean,[4,5]);
r2.complex.meangrid = reshape(r2.complex.mean,[4,5]);
r2.vendor.meangrid = reshape(r2.vendor.mean,[4,5]);

%% 4. Display phantom images

figure
subplot(1,4,1)
imshow(maps.FFstandard,[0 1])
title('Fat fraction, Gaussian/MAGO')
colormap('parula')
colorbar

subplot(1,4,2)
imshow(maps.FFrician,[0 1])
title('Fat fraction, Rician/MAGORINO')
colormap('parula')
colorbar

subplot(1,4,3)
imshow(maps.FFcomplex,[0 1])
title('Fat fraction, Complex MAGO-equivalent')
colormap('parula')
colorbar

subplot(1,4,4)
imshow(ffVendor,[0 1])
title('Fat fraction, Vendor')
colormap('parula')
colorbar

figure

subplot(2,3,1)
imshow(maps.R2standard,[0 0.3])
title('R2*, Gaussian MAGO')
colorbar

subplot(2,3,2)
imshow(maps.R2rician,[0 0.3])
title('R2*, MAGORINO')
colorbar

subplot(2,3,3)
imshow(maps.R2complex,[0 0.3])
title('R2* complex MAGO-equivalent')
colorbar

subplot(2,3,5)
imshow(maps.R2rician - maps.R2standard,[-0.01 0.01])
title('R2* Rician/MAGORINO - Gaussian/MAGO')
colorbar

subplot(2,3,6)
imshow(maps.R2complex - maps.R2standard,[-0.01 0.01])
title('R2* complex MAGO-equivalent - Gaussian/MAGO')
colorbar

%% 5. Display values as grids

% 5.1 For FF
figure('Name', 'FF')

s1=subplot(2,4,1)
image(ReferenceValues.FF,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5]);
xticklabels({'0','20', '40', '50', '60'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 2 3 4]);
yticklabels({'150','100','50','0'});
ylabel('Bone mineral density','FontSize',12)
title('Reference FF')
colorbar

s1=subplot(2,4,2)
image(ff.standard.meangrid,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5]);
xticklabels({'0','20', '40', '50', '60'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 2 3 4]);
yticklabels({'150','100','50','0'});
ylabel('Bone mineral density','FontSize',12)
title('Gaussian FF')
colorbar

s1=subplot(2,4,3)
image(ff.rician.meangrid,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5]);
xticklabels({'0','20', '40', '50', '60'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 2 3 4]);
yticklabels({'150','100','50','0'});
ylabel('Bone mineral density','FontSize',12)
title('Rician FF')
colorbar

s1=subplot(2,4,4)
image(ff.complex.meangrid,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex FF')
colorbar


s1=subplot(2,4,6)
image(ff.standard.meangrid-ReferenceValues.FF,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5]);
xticklabels({'0','20', '40', '50', '60'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 2 3 4]);
yticklabels({'150','100','50','0'});
ylabel('Bone mineral density','FontSize',12)
title('Gaussian FF error')
colorbar

s1=subplot(2,4,7)
image(ff.rician.meangrid-ReferenceValues.FF,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Rician FF error')
colorbar

s1=subplot(2,4,8)
image(ff.complex.meangrid-ReferenceValues.FF,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-1 1];
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'0','.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9','1.0'});
xlabel('R2* (ms^-^1)','FontSize',12)
yticks([1 6 11 16 21 26 31 36 41 46 51]);
yticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Fat fraction (%)','FontSize',12)
title('Complex FF error')
colorbar

% 5.1 For R2star

figure('Name', 'R2*')
s1=subplot(2,3,1)
image(r2.standard.meangrid,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 0.3];
xticks([1 2 3 4 5]);
xticklabels({'0','20', '40', '50', '60'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 2 3 4]);
yticklabels({'150','100','50','0'});
ylabel('Bone mineral density','FontSize',12)
title('R2* Gaussian/MAGO')
colorbar

s1=subplot(2,3,2)
image(r2.rician.meangrid,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 0.3];
xticks([1 2 3 4 5]);
xticklabels({'0','20', '40', '50', '60'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 2 3 4]);
yticklabels({'150','100','50','0'});
ylabel('Bone mineral density','FontSize',12)
title('R2* Rician/MAGORINO')
colorbar

s1=subplot(2,3,3)
image(r2.complex.meangrid,'CDataMapping','scaled')
ax=gca;
ax.CLim=[0 0.3];
xticks([1 2 3 4 5]);
xticklabels({'0','20', '40', '50', '60'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 2 3 4]);
yticklabels({'150','100','50','0'});
ylabel('Bone mineral density','FontSize',12)
title('R2* complex MAGO-equivalent')
colorbar

s1=subplot(2,3,5)
image(r2.rician.meangrid-r2.standard.meangrid,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-0.03 0.03];
xticks([1 2 3 4 5]);
xticklabels({'0','20', '40', '50', '60'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 2 3 4]);
yticklabels({'150','100','50','0'});
ylabel('Bone mineral density','FontSize',12)
title('R2* Rician/MAGORINO - Gaussian/MAGO')
colorbar

s1=subplot(2,3,6)
image(r2.complex.meangrid-r2.standard.meangrid,'CDataMapping','scaled')
ax=gca;
ax.CLim=[-0.03 0.03];
xticks([1 2 3 4 5]);
xticklabels({'0','20', '40', '50', '60'});
xlabel('Fat fraction (%)','FontSize',12)
yticks([1 2 3 4]);
yticklabels({'150','100','50','0'});
ylabel('Bone mineral density','FontSize',12)
title('R2* complex MAGO-equivalent - Gaussian/MAGO')
colorbar

% s1=subplot(1,4,3)
% image(r2.vendor.meangrid,'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[0 0.3];
% xticks([1 2 3 4 5]);
% xticklabels({'0','20', '40', '50', '60'});
% xlabel('Fat fraction (%)','FontSize',12)
% yticks([1 2 3 4]);
% yticklabels({'150','100','50','0'});
% ylabel('Bone mineral density','FontSize',12)
% title('R2* vendor')
% colorbar

% figure('Name', 'R2star')
% s1=subplot(1,3,1)
% image(ReferenceValues.R2,'CDataMapping','scaled')
% ax=gca;
% ax.CLim=[0 150];
% xticks([1 2 3 4 5]);
% xticklabels({'0','20', '40', '50', '60'});
% xlabel('Fat fraction (%)','FontSize',12)
% yticks([1 2 3 4]);
% yticklabels({'150','100','50','0'});
% ylabel('Bone mineral density','FontSize',12)
% title('BMD')
% colorbar

end


