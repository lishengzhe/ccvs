clear all
close all

width = 1280;
height = 720;

%% load
path = 'E:\Shengzhe\Documents\2014 VideoSrvl\Dataset\VSPSDBCalibration_v2';
camID = '01';
caliSubjectID = '001';
testSubjectID = '001';

paraFileName = [path '\' camID '\' caliSubjectID '.mat'];
ptFileName = [path '\' camID '\' testSubjectID '.txt'];
load(paraFileName);

rawPoints = dlmread(ptFileName,'\t',1);
xf = (rawPoints(:,4) - 0.5*width)/width;
xh = (rawPoints(:,2) - 0.5*width)/width;

yf = (0.5*height - rawPoints(:,5))/width;
yh = (0.5*height - rawPoints(:,3))/width;

% undistort all points
ku1=k(1);
ku2=k(2);

% undistortion foot points
rs = xf.^2+yf.^2;
% xf = xf.*(1+ku1.*rs+ku2.*rs.^2);
yf = yf.*(1+ku1.*rs+ku2.*rs.^2);

% undistortion head points
rs = xh.^2+yh.^2;
% xh = xh.*(1+ku1.*rs+ku2.*rs.^2);
yh = yh.*(1+ku1.*rs+ku2.*rs.^2);


estimatedHeights = pointsToHeight(ftc,[yf yh])

mean_height = mean(estimatedHeights)
error_std = std(estimatedHeights)
