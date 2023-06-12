function VideoAddFrame(video, figHandle)
% function VideoAddFrame(video, figHandle)
%
% INPUT:
%
% video: a VideoWriter object to write a frame into
%
% figHandle: a figure handle to extract a video frame from
%

if (video.IsOpen)
    frame = getframe(figHandle);
    video.writeVideo(frame);
end
