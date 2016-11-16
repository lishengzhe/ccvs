function [ftc estimatedHeights] = CalibrateP2H(filename,imageWidth, imageHeight,ftc0,k,roll)

options = optimset('Algorithm','levenberg-marquardt',...
    'MaxFunEvals', 1e6, ...
    'MaxIter', 1e5, ...
    'TolFun', 1e-10);

rawPoints = dlmread(filename,'\t',1);
xf = (rawPoints(:,4) - 0.5*imageWidth)/imageWidth;
xh = (rawPoints(:,2) - 0.5*imageWidth)/imageWidth;

yf = (0.5*imageHeight - rawPoints(:,5))/imageWidth;
yh = (0.5*imageHeight - rawPoints(:,3))/imageWidth;

h = rawPoints(:,6)/100;

% undistort all points
ku1=k(1);
ku2=k(2);

% undistortion foot points
rs = xf.^2+yf.^2;
xf = xf.*(1+ku1.*rs+ku2.*rs.^2);
yf = yf.*(1+ku1.*rs+ku2.*rs.^2);

% undistortion head points
rs = xh.^2+yh.^2;
xh = xh.*(1+ku1.*rs+ku2.*rs.^2);
yh = yh.*(1+ku1.*rs+ku2.*rs.^2);

xhp = xh.* cosd(roll)-yh.*sind(roll);
yhp = xh.* sind(roll)+yh.*cosd(roll);

xfp = xf.* cosd(roll)-yf.*sind(roll);
yfp = xf.* sind(roll)+yf.*cosd(roll);

% f2h = @(x,xdata)footToHeadXYd(x,xdata, k);
hf2h = @(x,xdata)pointsToHeight(x,xdata);

% [ftc,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(hf2h,ftc0,[yf yh], h,[],[],options);
[ftc,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(hf2h,ftc0,[yfp yhp], h,[],[],options);

% estimatedHeights = pointsToHeight(ftc,[yf yh]);
estimatedHeights = pointsToHeight(ftc,[yfp yhp]);