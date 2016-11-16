function yHead = footToHead(x,xdata,H)
f=x(1);
theta=x(2);
C=x(3);
yFoot=xdata;


yHead = ((f.*C+f.*H.*tand(theta).^2+f.*C.*tand(theta).^2).*yFoot ...
    -f.^2.*H.*tand(theta))./(-H.*tand(theta)*yFoot+f.*C.*tand(theta).^2+f.*H+f.*C);

