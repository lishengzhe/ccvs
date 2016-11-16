function phg = phgroup(xo,c)
%
% Input:
% x: data matrix with treatments in rows and observations in columns
% c: matrix of pairwise comparison results from multcompare test
% 
% WARNING: is indispensable that the means of x matrix are sorted in crescent order.
%


% Getting significant pairwise comparisons
gr=1;
for i=1:size(c,1)
if c(i,3)>0&&c(i,5)>0||c(i,3)<0&&c(i,5)<0
tt(c(i,2),c(i,1))=0;
gr=gr+1;
else
tt(c(i,1),c(i,1))=gr;
tt(c(i,2),c(i,1))=gr;
end
end

% Setting groups if all non-significant
if isempty(find(tt>0))==1
for i=1:size(tt,1)
    gr=gr+1;
    tt(i,i)=gr;
end
end

% Setting groups if some non-significant
for i=1:size(tt,1)
    if isempty(find(tt(i,:)>0))==1
        tt(i,i)=gr+1;
        gr=gr+1;
    end
end

% Correcting repeated groups
for i=1:size(tt,2)-1
    if max(find(tt(:,i+1)>0))==max(find(tt(:,i)>0))
        tt(find(tt(:,i+1)>0),i+1)=tt(i,i);
    end
end
mx=max(tt);
for i=1:size(tt,2)-1
    if max(tt(:,i+1))==mx(i)
        tt(find(tt(:,i+1)>0),i+1)=0;
    end
end

% Setting sequential groups
[B,IX] = sort(nonzeros(max(tt))');
for l=1:size(tt,1)
    for c=1:size(tt,2)
        if tt(l,c)>0
            for u=1:size(B,2)
                if tt(l,c)==B(u)
                    tt(l,c)=IX(u);
                end
            end
        end
    end
end

% Assigning letters to groups
gn=['a';'b';'c';'d';'e';'f';'g';'h';'i';'j';'k';'l';'m';'n';'o';'p';'q';'r';'t';'u';'v';'w';'x';'y';'z'];
for i=1:size(tt,1)
tg=[];
    ttu=nonzeros(unique(tt(i,:)))';
    for j=1:size(ttu,2)
            tg=[tg gn(ttu(1,j))];
            TG{i,1}=tg;
    end
end

% Getting output table
m1=[mean(xo);std(xo)]';
m1=[num2cell(m1) TG];
me1=['mean';m1(:,1)];
st=['std';m1(:,2)];
gr=['group';m1(:,3)];
phg=[me1 st gr];