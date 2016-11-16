clear all
close all

width = 1280;
height = 720;

%% calibration
path = 'E:\Shengzhe\Documents\2014 VideoSrvl\Dataset\VSPSDBCalibration_v2';
camID = '02';
subjectID = '001';
ptFileName = [path '\' camID '\' subjectID '.txt'];

% k = ku1 ku2 kd1 kd2

% manual set k
kd1 = -0.0;
kd2 = kd1*kd1;
[ ku ] = ComputeKu( [kd1 kd2] );
ku1 = ku(1);
ku2 = ku(2);
k = [ku1 ku2 kd1 kd2]
   
ftc0 = [1,-30,-3];

% [ftc estimatedHeights] = CalibrateP2P(ptFileName,  width, height,ftc0, k)
[ftc estimatedHeights] = CalibrateP2H(ptFileName,  width, height,ftc0, k)

paraFileName = [path '\' camID '\' subjectID '.mat'];
% save(paraFileName,'ftc','k');

mean_height = mean(estimatedHeights)
error_std = std(estimatedHeights)

error =estimatedHeights-1.745;
figure;
hist(error,20);figure(gcf);
title('Calibration error without distortion correction');

% manual set k
kd1 = -0.5;
kd2 = kd1*kd1;
[ ku ] = ComputeKu( [kd1 kd2] );
ku1 = ku(1);
ku2 = ku(2);
k = [ku1 ku2 kd1 kd2]
   
ftc0 = [1,-30,-3];

% [ftc estimatedHeights] = CalibrateP2P(ptFileName,  width, height,ftc0, k)
[ftc estimatedHeights] = CalibrateP2H(ptFileName,  width, height,ftc0, k)

paraFileName = [path '\' camID '\' subjectID '.mat'];
% save(paraFileName,'ftc','k');

mean_height = mean(estimatedHeights)
error_std = std(estimatedHeights)

error2 =estimatedHeights-1.745;
hist(error2,20);figure(gcf);
title('Calibration error with distortion correction');



% %% show distortion
% imgFileName = [path '\' camID '.png'];
% scale = 1.5;
% src = imread(imgFileName);
% dst = UndistortImage(src,scale,kd1,kd2); 
% figure,imshow(dst);

figure, 
axes('FontSize',13);
boxplot([error*100 error2*100],{'without distortion correction', 'with distortion correction'})
ylabel('Error distrubution (cm)')
title('Calibration error without and with distortion correction'); 
