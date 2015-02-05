function [ dst ] = DistortImage( src,scale, k1, k2 )
%UNDISTORT Summary of this function goes here
%   Detailed explanation goes here
if nargin < 4
    k2=0;
end

h = size(src,1);
w = size(src,2);

scale = 1/scale;
hd = h*scale;
wd = w*scale;

dst = zeros(size(src),class(src));

for j = 1:h
    for i=1:w
        
        xd =  (i - 0.5*w)/wd;
        yd = (0.5*h - j)/wd;
        
        rs = xd^2+yd^2;
        c = (k1*rs+k2*rs^2);
        xu = xd+xd*c;
        yu = yd+yd*c;
        
        iu = int32(wd*xu + 0.5*w);
        ju = int32((0.5*h - yu*wd));
        
        if (iu<1 || iu>w)
            continue;
        end
        if (ju<1 || ju>h)
            continue;
        end
        dst(j,i,:)=src(ju,iu,:);

    end
end

end

