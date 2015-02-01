close all
clear all

%% load and show original image
src = imread('cam2.png');
figure,subplot(1,3,1),imshow(src),title('Original(distorted)');

%% undistort image
kd1 = -0.6
kd2 = 0.4
scale=1.5;

dst = UndistortImage(src,scale,kd1,kd2); 
subplot(1,3,2),imshow(dst),title('Undistorted');

%% distort image
[ ku ] = ComputeKu( [kd1 kd2] );
ku1 = ku(1)
ku2 = ku(2)

src2 = DistortImage(dst,scale,ku1,ku2);
subplot(1,3,3),imshow(src2),title('Distorted');
