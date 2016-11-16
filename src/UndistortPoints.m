function [ ydata ] = UndistortPoints( x, xdata)
%UNDISTORTPOINT Summary of this function goes here
%   Detailed explanation goes here

ku1=x(1);
ku2=x(2);
xd = xdata(:,:,1);
yd = xdata(:,:,2);

rs = xd.^2+yd.^2;
xu = xd.*(1+ku1.*rs+ku2.*rs.^2);
yu = yd.*(1+ku1.*rs+ku2.*rs.^2);

ydata(:,:,1)=xu;
ydata(:,:,2)=yu;

end

