function h = pointsToHeight3d(x,xdata)
f=x(1);
theta=x(2);
c=x(3);
k=x(4);

xf=xdata(:,1);
yf=xdata(:,2);
xh=xdata(:,3);
yh=xdata(:,4);

rs = xf.^2+yf.^2;
yf = yf.*(1+k.*rs);

rs = xh.^2+yh.^2;
yh = yh.*(1+k.*rs);

tt=tand(theta);

h = (f*tt^2*c+f*c).*(yf-yh)./(tt*yf.*yh+f*tt^2*yh-f*yf-f^2*tt);

% h = c .* (yh-yf) ./ (yf+f*tt);