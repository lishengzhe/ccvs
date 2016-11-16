function h = pointsToHeight2(f,theta,c,yf,yh)

tt=tand(theta);

h = (f*tt^2*c+f*c).*(yf-yh)./ ...
    (tt*yf.*yh+f*tt^2*yh-f*yf-f^2*tt);
% 
% 
% st=sind(theta);
% ct=cosd(theta);
% 
% h = (f*st^2*c+f*c*ct^2).*(yf-yh)./ ...
%     (st*ct*yf.*yh+f*st^2*yh-f*yf*ct^2-f^2*st*ct);

% h = c .* (yh-yf) ./ (yf+f*tt);