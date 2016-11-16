
clear all

unit = 0.01;
[xu yu]=meshgrid(-0.5:unit:0.5,-0.5:unit:0.5);

kd1 = -0.6;
kd2 = kd1*kd1;

[ ku ] = ComputeKu( [kd1 kd2] );

eku1=ku(1)
eku2=ku(2)

% compute distortion coordinates
rs = xu.^2+yu.^2;
xd = xu.*(1+kd1.*rs+kd2.*rs.^2);
yd = yu.*(1+kd1.*rs+kd2.*rs.^2);

rs = xd.^2+yd.^2;
exu = xd.*(1+eku1.*rs+eku2.*rs.^2);
eyu = yd.*(1+eku1.*rs+eku2.*rs.^2);

error = sqrt((exu-xu).^2 + (eyu-yu).^2)/unit;
surf(error,'DisplayName','error');figure(gcf)

error = sqrt((xd-xu).^2 + (yd-yu).^2)/unit;
surf(error,'DisplayName','error');figure(gcf)
