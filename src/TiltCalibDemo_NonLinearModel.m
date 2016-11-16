clear all
close all

load points-001-02

% f=300, theta=100, c=300
x0=[1000,-30,-300];

% f = @(x,xdata)((x(1).*x(3)+x(1).*170.*tan(x(2).^2)+x(1).*x(3).*tan(x(2).^2)).*xdata ...
%     -x(1).^2.*170.*tan(x(2)))./(-170.*tan(x(2))*xdata+x(1).*x(3).*tan(x(2).^2)+x(1).*170+x(1).*x(3));
H1=170;
% f = @(x,xdata)footToHead2(x,xdata,H1);
% f = @(x,xdata)footToHead2(x,xdata,H1);
f = @(x,xdata)footToHead3(x,xdata);

xdata = [points(:,2) H1*ones(size(points(:,2),1),1)];
% xdata = points(:,2);
ydata = points(:,1);

% mdl = NonLinearModel.fit(xdata,ydata,f,x0)

% d
% ydata_est=f(x,xdata);
% 
% figure;hold on;
% scatter(xdata,ydata);
% scatter(xdata,ydata_est);
% 
% 
load points-003-02

% H2=180;
% xdata = [xdata; points(:,2) H2*ones(size(points(:,2),1),1)];
% ydata = [ydata; points(:,1)];

% [x,resnorm] = lsqcurvefit(f,x0,xdata,ydata);

mdl = NonLinearModel.fit(xdata,ydata,f,x0)

% mdl

plotResiduals(mdl)

plotSlice(mdl)

predict(mdl,xdata)

% 
% % f2 = @(x,xdata)((x(1).*x(3)+x(1).*180.*tan(x(2).^2)+x(1).*x(3).*tan(x(2).^2)).*xdata ...
% %     -x(1).^2.*180.*tan(x(2)))./(-180.*tan(x(2))*xdata+x(1).*x(3).*tan(x(2).^2)+x(1).*180+x(1).*x(3));
% H2=180
% f2 = @(x,xdata)footToHead2(x,xdata,H2);
% 
% ydata_est=f2(x,xdata);
% 
% 
% figure;hold on;
% scatter(xdata,ydata);
% scatter(xdata,ydata_est);
% 
% H2_est = mean(pointsToHeight2(x(1),x(2),x(3),xdata,ydata))