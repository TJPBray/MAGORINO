function video = VideoSetup (videoName)
% function video = VideoSetup (videoNname)
%
% INPUT:
%
% videoName: name of the video without the suffix
%
% OUTPUT:
%
% video: a VideoWriter object for writing a mp4 video file
%

% create the VideoWriter object with the right type
video = VideoWriter([videoName, '.mp4'], 'MPEG-4');

% set the frame rate
frameRate = 5;
video.set('FrameRate', frameRate);
