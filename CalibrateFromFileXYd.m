function ftc = CalibrateFromFileXYd(filename,imageWidth, imageHeight,ftc0, k)

options = optimset('Algorithm','trust-region-reflective',...
'MaxFunEvals', 1e5, ...
'MaxIter', 1e4);

rawPoints = dlmread(filename,'\t',1);
xf = (rawPoints(:,4) - 0.5*imageWidth)/imageWidth;
xh = (rawPoints(:,2) - 0.5*imageWidth)/imageWidth;

yf = (0.5*imageHeight - rawPoints(:,5))/imageWidth;
yh = (0.5*imageHeight - rawPoints(:,3))/imageWidth;

ku1=k(1);
ku2=k(2);

h = rawPoints(:,6)/100;

f2h = @(x,xdata)FootToHeadXYd(x,xdata, k);

[ftc,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(f2h,ftc0,[xf yf h],[xh yh],[],[],options);
