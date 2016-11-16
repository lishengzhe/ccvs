function [ ku ] = ComputeKu( kd, unit )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    unit = 0.01;
end

[xu yu]=meshgrid(-0.5:unit:0.5,-0.5:unit:0.5);

kd1 = kd(1);
kd2 = kd(2);
ku1 = -kd1;
ku2 = 0;

% compute distortion coordinates
rs = xu.^2+yu.^2;
xd = xu.*(1+kd1.*rs+kd2.*rs.^2);
yd = yu.*(1+kd1.*rs+kd2.*rs.^2);


xdata(:,:,1)=xd;
xdata(:,:,2)=yd;
ydata(:,:,1)=xu;
ydata(:,:,2)=yu;

x0=[ku1;ku2];

fun = @(x,xdata)UndistortPoints(x,xdata);
x = lsqcurvefit(fun,x0,xdata,ydata);

ku(1)=x(1);
ku(2)=x(2);

end

