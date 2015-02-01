function yh = FootToHeadY(x,xdata,h)
f=x(1);
theta=x(2);
c=x(3);
yf=xdata;
tt = tand(theta);

yh=(f*(tt^2*c+h+c).*yf+f^2*tt*h)./ ...
    (tt*h.*yf+f*(tt^2*h+tt^2*c+c));
