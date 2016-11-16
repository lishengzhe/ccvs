clear all
close all

width = 1280;
height = 720;

%% calibration
path = '..\data';

camID = '01';
subjectID = '001';
ptFileName = [path '\' camID '\' subjectID '.txt'];
fileName = [subjectID '.txt'];

% k = ku1 ku2 kd1 kd2

% manual set k
kd1 =-0.65;
kd2 = kd1*kd1;
[ ku ] = ComputeKu( [kd1 kd2] );
ku1 = ku(1);
ku2 = ku(2);
k = [ku1 ku2 kd1 kd2]
   
ftc0 = [1,-30,-3];

roll=-0.0;

% [ftc estimatedHeights] = CalibrateP2P(ptFileName,  width, height,ftc0, k)
[ftc estimatedHeights] = CalibrateP2H(ptFileName, width, height,ftc0, k, roll);


paraFileName = [path '\' subjectID '\' camID '.mat'];
% save(paraFileName,'ftc','k','roll');

%% result
k
ftc
roll
% estimatedHeights
mean_height = mean(estimatedHeights)
error_std = std(estimatedHeights)

% show distortion
imgFileName = [path '\' camID '.png'];
% imgFileName = '..\150123\170\cam01.png';
scale = 1.5;
src = imread(imgFileName);
dst = UndistortImage(src,scale,kd1,kd2);
figure,imshow(dst);
