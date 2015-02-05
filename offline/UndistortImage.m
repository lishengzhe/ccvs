function [ dst ] = UndistortImage( src, scale, k1, k2 )
%UNDISTORT Summary of this function goes here
%   Detailed explanation goes here
if nargin < 4
    k2=0;
end

h = size(src,1);
w = size(src,2);

hu = h*scale;
wu = w*scale;

% dst = zeros(size(src),class(src));
dst = zeros(hu,wu,size(src,3),class(src));

for j = 1:hu
    for i=1:wu
        
        xu = (i - 0.5*wu)/w;
        yu = (0.5*hu - j)/w;

        rs = xu^2+yu^2;
        c = (k1*rs+k2*rs^2);
        xd = xu+xu*c;
        yd = yu+yu*c;
        
        id = int32(0.5*w + xd*w);
        jd = int32(0.5*h - yd*w);
        
        if (id<1 || id>w)
            continue;
        end
        if (jd<1 || jd>h)
            continue;
        end
        dst(j,i,:)=src(jd,id,:);
      
    end
end

end

