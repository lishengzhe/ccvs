function h = pointsToHeight(x,xdata)
f=x(1);
theta=x(2);
c=x(3);
% ku1=x(4);
% ku2=x(5);


yf=xdata(:,1);
yh=xdata(:,2);
% xf=xdata(:,3);
% xh=xdata(:,4);

% undistortion
% rs = xh.^2+yh.^2;
% yh = yh.*(1+ku1.*rs+ku2.*rs.^2);
% rs = xf.^2+yf.^2;
% yf = yf.*(1+ku1.*rs+ku2.*rs.^2);

tt=tand(theta);

h = (f*tt^2*c+f*c).*(yf-yh)./(tt*yf.*yh+f*tt^2*yh-f*yf-f^2*tt);

% h = c .* (yh-yf) ./ (yf+f*tt);