function [ftc estimatedHeights resnorm] = CalibrateP2P(filename,imageWidth, imageHeight,ftc0, k)
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
xf = (rawPoints(:,4) - 0.5*imageWidth)/imageWidth;
xh = (rawPoints(:,2) - 0.5*imageWidth)/imageWidth;

yf = (0.5*imageHeight - rawPoints(:,5))/imageWidth;
yh = (0.5*imageHeight - rawPoints(:,3))/imageWidth;


h = rawPoints(:,6)/100;

f2h = @(x,xdata)footToHeadXYd(x,xdata,k);

[ftc,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(f2h,ftc0,[xf yf h],[xh yh],[],[],options);

ku1=k(1);
ku2=k(2);

% undistortion
rs = xh.^2+yh.^2;
yh = yh.*(1+ku1.*rs+ku2.*rs.^2);
rs = xf.^2+yf.^2;
yf = yf.*(1+ku1.*rs+ku2.*rs.^2);

estimatedHeights = pointsToHeightY(ftc,[yf yh]);