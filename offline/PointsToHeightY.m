function h = PointsToHeightY(x,xdata)
% 
% (C) 2015 Shengzhe Li <lishengzhe@gmail.com>
% 
% This code is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License version 2 as
% published by the Free Software Foundation.

f=x(1);
theta=x(2);
c=x(3);

yf=xdata(:,1);
yh=xdata(:,2);

tt=tand(theta);

h = (f*tt^2*c+f*c).*(yf-yh)./(tt*yf.*yh+f*tt^2*yh-f*yf-f^2*tt);

% h = c .* (yh-yf) ./ (yf+f*tt);