close all;
clear all;

fnamer = @(dp, sn, cn, date, ss)[dp '\' sn '\CC-' sn '-' cn '-' date '-' ss '.txt'];


dbPath = 'data';
subjectName = {'001'; '002'; '003'; '004'; '005'; '006'};
subjectHeight = [1.70; 1.72; 1.82; 1.73; 1.78; 1.73];
cameraName = {'01'; '02'; '04'; '08'; '10'};
date = '20131107';
session = '01';
imageHeight = 720;
imageWidth = 1280;
ftc0 = [2,-30,-3];


allPoints = cell(length(subjectName), length(cameraName));
parameters = cell(length(subjectName), length(cameraName));
heights = cell(length(subjectName), length(cameraName));
heights_mean = cell(length(subjectName), length(cameraName)*(length(subjectName)));
heighterrors_mean = cell(length(subjectName), length(cameraName)*(length(subjectName)-1));
heighterrors_median = cell(length(subjectName), length(cameraName)*(length(subjectName)-1));
heighterrors_trimmean = cell(length(subjectName), length(cameraName)*(length(subjectName)-1));


% parameter estimation for every subject-camera
for j=1:length(cameraName)
    ftc = ftc0;
    for i=1:length(subjectName)
        rawPoints = dlmread(fnamer(dbPath, subjectName{i}, cameraName{j}, date, session),'\t',1);

        yf = (0.5*imageHeight - rawPoints(:,5))/imageWidth;
        yh = (0.5*imageHeight - rawPoints(:,3))/imageWidth;
        
        f2h = @(x,xdata)FootToHeadY(x,xdata,subjectHeight(i));
        
        h = rawPoints(:,6)/100;
        
        [ftc,r,J,cov,mse] = nlinfit(yf,yh,f2h,ftc);
        allPoints{i,j} = [yf yh];
        parameters{i,j} = ftc;
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

% cross validation by subject
heights_mean = cell2mat(heights_mean);
heights_mean_3d = reshape(heights_mean,length(subjectName), length(subjectName),length(cameraName));

cv_mean = mean(heights_mean_3d,3);
cv_std = std(heights_mean_3d,0,3);

