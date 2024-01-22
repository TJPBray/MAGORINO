function filtMaps = filterMaps(maps)
% function filtMaps = filterMaps(maps)

%Performs spatial smoothing of likelihood difference map then generates
%PDFF and R2* maps accordingly

% Spatial smoothing of likelihood difference image with box filter
filtMaps.likDiff1 = imboxfilt(maps.likDiff);

filtMaps.PDFF.box = zeros([320 320]);
filtMaps.R2.box = zeros([320 320]);

filtMaps.PDFF.box(filtMaps.likDiff1<0) = maps.FFricianOpt1(filtMaps.likDiff1<0);
filtMaps.PDFF.box(filtMaps.likDiff1>=0) = maps.FFricianOpt2(filtMaps.likDiff1>=0);

filtMaps.R2.box(filtMaps.likDiff1<0) = maps.R2ricianOpt1(filtMaps.likDiff1<0);
filtMaps.R2.box(filtMaps.likDiff1>=0) = maps.R2ricianOpt2(filtMaps.likDiff1>=0);

% Spatial smoothing of likelihood difference image with larger filter size (5)
filtMaps.likDiff2 = imboxfilt(maps.likDiff,5);

filtMaps.PDFF.box5 = zeros([320 320]);
filtMaps.R2.box5 = zeros([320 320]);

filtMaps.PDFF.box5(filtMaps.likDiff2<0) = maps.FFricianOpt1(filtMaps.likDiff2<0);
filtMaps.PDFF.box5(filtMaps.likDiff2>=0) = maps.FFricianOpt2(filtMaps.likDiff2>=0);

filtMaps.R2.box5(filtMaps.likDiff2<0) = maps.R2ricianOpt1(filtMaps.likDiff2<0);
filtMaps.R2.box5(filtMaps.likDiff2>=0) = maps.R2ricianOpt2(filtMaps.likDiff2>=0);

% Spatial smoothing of likelihood difference image with Gaussian filter
filtMaps.likDiff3 = imgaussfilt(maps.likDiff,0.5); %0.5 is default sigma

filtMaps.PDFF.gauss = zeros([320 320]);
filtMaps.R2.gauss = zeros([320 320]);

filtMaps.PDFF.gauss(filtMaps.likDiff3<0) = maps.FFricianOpt1(filtMaps.likDiff3<0);
filtMaps.PDFF.gauss(filtMaps.likDiff3>=0) = maps.FFricianOpt2(filtMaps.likDiff3>=0);

filtMaps.R2.gauss(filtMaps.likDiff3<0) = maps.R2ricianOpt1(filtMaps.likDiff3<0);
filtMaps.R2.gauss(filtMaps.likDiff3>=0) = maps.R2ricianOpt2(filtMaps.likDiff3>=0);

% Spatial smoothing of likelihood difference image with Gaussian filter
filtMaps.likDiff4 = imgaussfilt(maps.likDiff,(0.5*5)/3,'FilterSize',5); %Scale sigma with filter size (default 3)

filtMaps.PDFF.gauss5 = zeros([320 320]);
filtMaps.R2.gauss5 = zeros([320 320]);

filtMaps.PDFF.gauss5(filtMaps.likDiff4<0) = maps.FFricianOpt1(filtMaps.likDiff4<0);
filtMaps.PDFF.gauss5(filtMaps.likDiff4>=0) = maps.FFricianOpt2(filtMaps.likDiff4>=0);

filtMaps.R2.gauss5(filtMaps.likDiff4<0) = maps.R2ricianOpt1(filtMaps.likDiff4<0);
filtMaps.R2.gauss5(filtMaps.likDiff4>=0) = maps.R2ricianOpt2(filtMaps.likDiff4>=0);

end



