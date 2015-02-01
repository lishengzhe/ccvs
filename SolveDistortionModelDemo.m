
clear all

unit = 0.01;
[xu yu]=meshgrid(-0.5:unit:0.5,-0.5:unit:0.5);

kd1 = -0.6;
kd2 = 0.4;

[ ku ] = ComputeKu( [kd1 kd2] );

eku1=ku(1)
eku2=ku(2)

% compute distortion coordinates
rs = xu.^2+yu.^2;
xd = xu.*(1+kd1.*rs+kd2.*rs.^2);
yd = yu.*(1+kd1.*rs+kd2.*rs.^2);

% compute undistortion coordinates
rs = xd.^2+yd.^2;
exu = xd.*(1+eku1.*rs+eku2.*rs.^2);
eyu = yd.*(1+eku1.*rs+eku2.*rs.^2);

error = sqrt((xd-xu).^2 + (yd-yu).^2)/unit;
figure(gcf), hold on,subplot(2,1,1);
surf(error,'DisplayName','error');
title('Pixel location error before distortion correction');

error = sqrt((exu-xu).^2 + (eyu-yu).^2)/unit;
subplot(2,1,2),surf(error,'DisplayName','error');figure(gcf)
title('Pixel location error after distortion correction');
