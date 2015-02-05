close all;
clear all;

fnamer = @(dp, sn, cn, date, ss)[dp '/' sn '/CC-' sn '-' cn '-' date '-' ss '.txt'];


dbPath = '../data';
subjectName = {'001'; '002'; '003'; '004'; '005'; '006'};
subjectHeight = [1.70; 1.72; 1.82; 1.73; 1.78; 1.73];
cameraKu = {[0.6322 0.5731];[0.6322 0.5731];[0.2575 0.5846];[0.4377 0.5507];[0.4377 0.5507];[0 0]};
% note cameraKu for cam3 = [0 0] cam5=[0.1890 0.1996]
cameraName = {'01'; '02'; '04'; '08'; '10'};
date = '20131107';
session = '01';
imageHeight = 720;
imageWidth = 1280;
ftc0 = [1,-30,-3];

allPoints = cell(length(subjectName), length(cameraName));
parameters = cell(length(subjectName), length(cameraName));
heights = cell(length(subjectName), length(cameraName));
heights_mean = cell(length(subjectName), length(cameraName)*(length(subjectName)));
heighterrors_mean = cell(length(subjectName), length(cameraName)*(length(subjectName)-1));
heighterrors_median = cell(length(subjectName), length(cameraName)*(length(subjectName)-1));
heighterrors_trimmean = cell(length(subjectName), length(cameraName)*(length(subjectName)-1));

options = optimset('Algorithm','trust-region-reflective',...
        'MaxFunEvals', 1e5, ...
        'MaxIter', 1e4);
    
        %'Display','iter-detailed',...   
        
% parameter estimation for every subject-camera
for j=1:length(cameraName)
    
    ftc = ftc0;
    xf = [];
    xh = [];
    yf = [];
    yh = [];
    h =  [];
    
    for i=1:length(subjectName)
        rawPoints = dlmread(fnamer(dbPath, subjectName{i}, cameraName{j}, date, session),'\t',1);
        xf = (rawPoints(:,4) - 0.5*imageWidth)/imageWidth;
        xh = (rawPoints(:,2) - 0.5*imageWidth)/imageWidth;
        
        yf = (0.5*imageHeight - rawPoints(:,5))/imageWidth;
        yh = (0.5*imageHeight - rawPoints(:,3))/imageWidth;

        %load k1 k2
        ku1  = cameraKu{j}(1);
        ku2  = cameraKu{j}(2);
                
        %undistortion
        rs = xf.^2+yf.^2;
        xf = xf.*(1+ku1.*rs+ku2.*rs.^2);
        yf = yf.*(1+ku1.*rs+ku2.*rs.^2);
        
        %undistortion
        rs = xh.^2+yh.^2;
        xh = xh.*(1+ku1.*rs+ku2.*rs.^2); %+k2.*rs.^2
        yh = yh.*(1+ku1.*rs+ku2.*rs.^2);

        h = rawPoints(:,6)/100;
        
        f2h = @(x,xdata)FootToHeadXY(x,xdata);
        [ftc,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(f2h,ftc0,[xf yf  h],[xh yh],[],[],options);
        allPoints{i,j} = [ yf  yh];
        parameters{i,j} = [ftc(1);ftc(2);ftc(3)];
    end
end


% cross validation of height error
tm_percent=30;
for j=1:length(cameraName)
    for i=1:length(subjectName)
        ftc = parameters{i,j};
        ind=1;
        for h=1:length(subjectName)
           
            H = PointsToHeightY(ftc,allPoints{h,j});
            
            yf = allPoints{h,j}(:,1);
            nPoints = length(yf);
            
            height_mean = mean(H);
            height_median = median(H);
            height_trimmean = trimmean(H,tm_percent);
            
            heights_mean{i,(length(subjectName))*(j-1)+h}=height_mean;
                        
            if (i==h)
                continue
            end
            
            heighterrors_mean{i,(length(subjectName)-1)*(j-1)+ind}=height_mean-subjectHeight(h);
            heighterrors_median{i,(length(subjectName)-1)*(j-1)+ind}=height_median-subjectHeight(h);
            heighterrors_trimmean{i,(length(subjectName)-1)*(j-1)+ind}=height_trimmean-subjectHeight(h);
            
            ind=ind+1;
        end
    end
end

he_mean = cell2mat(heighterrors_mean);
meanerror=mean(he_mean(:))
stderror=std(he_mean(:))

maxerror=max(he_mean(:))
minerror=min(he_mean(:))

meanabserror = mean(abs(he_mean(:)))
figure, hist(he_mean(:),50);
title('Height Estimation Error');
xlabel('Height Estimation Error (meter)');
ylabel('Number of subjects');

% he_median = cell2mat(heighterrors_median);
% mean(he_median(:))
% std(he_median(:))
% figure, hist(he_median(:),50);
% 
% he_trimmean = cell2mat(heighterrors_trimmean);
% mean(he_trimmean(:))
% std(he_trimmean(:))
% figure, hist(he_trimmean(:),50);
% mean(he(:))

% cross validation by subject
heights_mean = cell2mat(heights_mean);
heights_mean_3d = reshape(heights_mean,length(subjectName), length(subjectName),length(cameraName));

cv_mean = mean(heights_mean_3d,3);
cv_std = std(heights_mean_3d,0,3);


% anova on subjects

