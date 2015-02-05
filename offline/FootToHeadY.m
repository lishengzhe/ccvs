function yh = FootToHeadY(x,xdata,h)
% 
% (C) 2015 Shengzhe Li <lishengzhe@gmail.com>
% 
% This code is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License version 2 as
% published by the Free Software Foundation.

f=x(1);
theta=x(2);
c=x(3);
yf=xdata;
tt = tand(theta);

yh=(f*(tt^2*c+h+c).*yf+f^2*tt*h)./ ...
    (tt*h.*yf+f*(tt^2*h+tt^2*c+c));
