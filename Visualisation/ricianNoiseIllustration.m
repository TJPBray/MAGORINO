

%Pick number of signals
n=10000;

%Specify noise SD
noiseSD=1;

% Generate real and imaginary noises
noiseReal = noiseSD*randn(n,1);
noiseImag = noiseSD*randn(n,1);
noise = noiseReal + 1i*noiseImag;

%Scatterplot of data
figure

s=subplot(2,2,1)
hist(real(noise),50)
xlabel('Signal')
ylabel('Frequency')
set(s,'GridAlpha',0.3,'XGrid','on','XTick',0,'YGrid','on','YTick',0);


s=subplot(2,2,2)
hist(abs(noise),50)
set(s,'GridAlpha',0.3,'XGrid','on','XTick',0,'YGrid','on','YTick',0);
xlabel('Signal magnitude')
ylabel('Frequency')
yl=ylim(gca)


s=subplot(2,2,3)
scatter(real(noise),imag(noise))
set(s,'GridAlpha',0.3,'XGrid','on','XTick',0,'YGrid','on','YTick',0);
xlabel('Real signal component')
ylabel('Imaginary signal component')
xlim([-4 4])
ylim([-4 4])

s=subplot(2,2,4)
hist(abs(noise),50)
set(s,'GridAlpha',0.3,'XGrid','on','XTick',0,'YGrid','on','YTick',0);
xlabel('Signal magnitude')
ylabel('Frequency')
yl=ylim(gca)
% hold on
% plot([mean(abs(noise)) mean(abs(noise))],[yl],'LineWidth',2,'color','red','Linestyle',':')
% hold off
% hold on
% plot([0 0],[yl],'LineWidth',2,'color','green','Linestyle',':')
% hold off
% legend('Frequency','Gaussian', 'Rician')