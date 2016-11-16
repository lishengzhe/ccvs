function yh = footToHead3(x,xdata)
f=x(1);
theta=x(2);
c=x(3);

yf=xdata(:,1);
h=xdata(:,2);
tt = tand(theta);

yh=(f*(tt^2*c+h+c).*yf+f^2*tt*h)./ ...
    (tt*h.*yf+f*(tt^2*h+tt^2*c+c));



