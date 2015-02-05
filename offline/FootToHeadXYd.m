function ph = FootToHeadXYd(x,xdata,k)
% 
% (C) 2015 Shengzhe Li <lishengzhe@gmail.com>
% 
% This code is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License version 2 as
% published by the Free Software Foundation.

f=x(1);
theta=x(2);
c=x(3);
ku1=k(1);
ku2=k(2);
kd1=k(3);
kd2=k(4);

tt = tand(theta);

xf=xdata(:,1);
yf=xdata(:,2);
h =xdata(:,3);

%undistortion
rs = xf.^2+yf.^2;
xf = xf.*(1+ku1.*rs+ku2.*rs.^2);
yf = yf.*(1+ku1.*rs+ku2.*rs.^2);

%transform
xh=(f*c.*xf-tt*c.*xf.*yf)./ ...
    ((h-c)*tt.*yf+f*(h*tt^2+c));

yh=(f*(tt^2*c+h+c).*yf+f^2*tt*h)./ ...
(tt*h.*yf+f*(tt^2*h+tt^2*c+c));

%distortion
rs = xh.^2+yh.^2;
xh = xh.*(1+kd1.*rs+kd2.*rs.^2); 
yh = yh.*(1+kd1.*rs+kd2.*rs.^2);

ph = [xh yh]; 
