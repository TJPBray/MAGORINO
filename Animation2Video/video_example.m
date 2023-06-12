%% create the video writer object
video = VideoSetup('test');
video.open();

%% create the content

%Create figure
h = figure;

    %Create subplot 1
    h1 = subplot(2,2,1);
    hold on;
    xlim([0 10]);
    ylim([-1 1]);
    
    %Create subplot 2
    h2 = subplot(2,2,2);
    hold on;
    xlim([-1 1]);
    ylim([-1 1]);
    zlim([0 10])


% add a frame
VideoAddFrame(video, h);

pause;

for i = 1:1000
    pause(0.1);
    plot(h1,i/100, sin(2*pi*i/100), 'r.');
    

    j=(1:1:i);
    
    plot3(h2,sin(2*pi*j/100), cos(2*pi*j/100),j/100,'r.');
    view([45 45])
    % add a frame
    VideoAddFrame(video, h);
end

video.close();
