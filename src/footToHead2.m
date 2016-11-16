function yh = footToHead2(x,xdata,h)
f=x(1);
theta=x(2);
c=x(3);
yf=xdata;
tt = tand(theta);

yh=(f*(tt^2*c+h+c).*yf+f^2*tt*h)./ ...
    (tt*h.*yf+f*(tt^2*h+tt^2*c+c));

% st=sind(theta);
% ct=cosd(theta);
% 
% yh = (f*(st*st*c+h*ct*ct+c*ct*ct).*yf+f^2*st*ct*h)./ ...
%     (st*st*h.*yf+f*(st*st*h+st*st*c+c*ct*ct));

% yh = (1+h/c).*yf + h*f*tt/c;
