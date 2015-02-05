function ftc = CalibrateFromFileY(filename,imageWidth,imageHeight, ftc0)
% 
% (C) 2015 Shengzhe Li <lishengzhe@gmail.com>
% 
% This code is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License version 2 as
% published by the Free Software Foundation.

options = optimset('Algorithm','trust-region-reflective',...
'MaxFunEvals', 1e5, ...
'MaxIter', 1e4);


rawPoints = dlmread(filename,'\t',1);

yf = 0.5 - rawPoints(:,5)/imageHeight;
yh = 0.5 - rawPoints(:,3)/imageHeight;

f2h = @(x,xdata)FootToHeadY(x,xdata,rawPoints(1,6)/100.);

[ftc,r,J,cov,mse] = nlinfit(yf,yh,f2h,ftc0);