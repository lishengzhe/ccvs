clear all
close all

load points-001-02

points = points./360;

% f=300, theta=100, c=300
beta0 = [1,-30,-3];

% f = @(x,xdata)((x(1).*x(3)+x(1).*170.*tan(x(2).^2)+x(1).*x(3).*tan(x(2).^2)).*xdata ...
%     -x(1).^2.*170.*tan(x(2)))./(-170.*tan(x(2))*xdata+x(1).*x(3).*tan(x(2).^2)+x(1).*170+x(1).*x(3));
H1=1.7;
% f = @(x,xdata)footToHead2(x,xdata,H1);
f = @(x,xdata)footToHead2(x,xdata,H1);
% f = @(x,xdata)pointsToHeight3(x,xdata);

% xdata = [points(:,2) H1*ones(size(points(:,2),1),1)];
% ydata = H1*ones(size(points(:,2),1),1);

xdata = points(:,2);
ydata = points(:,1);

[beta,r,J,cov,mse]  = nlinfit(xdata,ydata,f,beta0);

beta

ci = nlparci(beta,r,'covar',cov)

% d
ydata_est=f(beta,xdata);
% 
figure;hold on;
scatter(xdata,ydata);
scatter(xdata,ydata_est);

pred = pointsToHeight3(beta,[xdata ydata]);
ci1 = pointsToHeight3(ci(:,1),[xdata ydata]);
ci2 = pointsToHeight3(ci(:,2),[xdata ydata]);

figure;hold on;
scatter(xdata,H1*ones(size(points(:,2),1),1),'o');
scatter(xdata,pred,'*');
scatter(xdata,ci1,'x');
scatter(xdata,ci2,'x');


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