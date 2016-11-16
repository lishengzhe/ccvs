function ftc = CalibrateXYFromFile(filename,imageWidth,imageHeight, ftc0)

options = optimset('Algorithm','trust-region-reflective',...
'MaxFunEvals', 1e5, ...
'MaxIter', 1e4);


rawPoints = dlmread(filename,'\t',1);

yf = 0.5 - rawPoints(:,5)/imageHeight;
yh = 0.5 - rawPoints(:,3)/imageHeight;

f2h = @(x,xdata)footToHead2(x,xdata,rawPoints(1,6)/100.);

[ftc,r,J,cov,mse] = nlinfit(yf,yh,f2h,ftc0);