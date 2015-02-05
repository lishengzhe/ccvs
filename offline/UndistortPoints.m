function [ ydata ] = UndistortPoints( x, xdata)
%UNDISTORTPOINT Undistort coordinates of points
% 
% (C) 2015 Shengzhe Li <lishengzhe@gmail.com>
% 
% This code is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License version 2 as
% published by the Free Software Foundation.


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

