close all
clear all

src = imread('cam123.png');
figure,imshow(src);

%% undistort image
kd1 = -0.5;
kd2 = kd1*kd1;
scale=1.5;

dst = UndistortImage(src,scale,kd1,kd2); 
figure,imshow(dst);

%% distort image
[ ku ] = ComputeKu( [kd1 kd2] );
ku1 = ku(1);
ku2 = ku(2);

src2 = DistortImage(dst,scale,ku1,ku2);
figure,imshow(src2);
