clear all
% close all

%% load
path = '..\data\ruler';

subjectName = {'160'; '170'; '180'; '190'; '200';...
    '210'};
subjectHeight = [1.60; 1.7; 1.8; 1.9; 2.0;...
    2.1];
cameraName = {'04'};
cameraWH = {[1280 720]};

caliSubjectID = '160';

all_mean = cell(length(subjectName), length(cameraName));
all_std = cell(length(subjectName), length(cameraName));
all_error =[];
all_eh =[];
all_h =[];


for camIdx = 1:length(cameraName)
    %% load cam parameters
    camID = cameraName{camIdx};
    WH = cameraWH{camIdx};
    width = WH(1);
    height = WH(2);
    paraFileName = [path '\' camID '\' caliSubjectID '.mat'];
    load(paraFileName);
    
    
    %% compute for each subject
    for subjectIdx = 1:length(subjectName)
        testSubjectID = subjectName{subjectIdx};
        ptFileName = [path '\' camID '\' testSubjectID '.txt'];
        
        if ~exist(ptFileName,'file')
            continue;
        end
        
        rawPoints = dlmread(ptFileName,'\t',1);
        xf = (rawPoints(:,4) - 0.5*width)/width;
        xh = (rawPoints(:,2) - 0.5*width)/width;
        
        yf = (0.5*height - rawPoints(:,5))/width;
        yh = (0.5*height - rawPoints(:,3))/width;
        
        % undistort all points
        ku1=k(1);
        ku2=k(2);
        
        % undistortion foot points
        rs = xf.^2+yf.^2;
        % xf = xf.*(1+ku1.*rs+ku2.*rs.^2);
        yf = yf.*(1+ku1.*rs+ku2.*rs.^2);
        
        % undistortion head points
        rs = xh.^2+yh.^2;
        % xh = xh.*(1+ku1.*rs+ku2.*rs.^2);
        yh = yh.*(1+ku1.*rs+ku2.*rs.^2);

        estimatedHeights = pointsToHeight(ftc,[yf yh]);
        
        all_error = [all_error;estimatedHeights*100 - rawPoints(:,6) rawPoints(:,6)];
        
        all_eh = [all_eh;estimatedHeights*100];
        all_h = [all_h;rawPoints(:,6)];
        
        all_mean{subjectIdx,camIdx} = mean(estimatedHeights);
        all_std{subjectIdx,camIdx} = std(estimatedHeights);
        
    end 
end


mae = mean(abs(all_eh-all_h))
me = mean(all_eh-all_h)
stdev = std(all_eh-all_h)
% 
% figure;
% axes('FontSize',13);
% hist(all_eh-all_h, 50);
% title({'Distribition of estimated height error (cm)';'in ruler based evaluation'})
% xlabel('Height error (cm)')
% ylabel('Number of measurements')
% 
% figure;
% axes('FontSize',13);
% scatter((all_eh+all_h)/2, all_eh-all_h, '.');
% hold on;
% title({'Limits of agreement';'in ruler based evaluation'})
% xlabel('Average of ruler and estimated height (cm)')
% ylabel('Difference between ruler and estimated height (cm)')
% 
% me = mean(all_eh-all_h);
% ub= me + stdev*1.96;
% lb= me - stdev*1.96;
% 
% line([150 220], [me me], 'LineStyle','-')
% line([150 220], [ub ub], 'LineStyle','--')
% line([150 220], [lb lb], 'LineStyle','--')
% text(220, me+0.1,'mean','HorizontalAlignment','right', 'FontSize', 13);
% text(220, ub-0.1,'-1.96SD','HorizontalAlignment','right', 'FontSize', 13);
% text(220, lb+0.1,'+1.96SD','HorizontalAlignment','right', 'FontSize', 13);


figure;
axes('FontSize',13);
scatter(all_h, all_eh-all_h, '.');
hold on;
title({'Limits of agreement';'in ruler based evaluation'})
xlabel('Ruler height (cm)')
ylabel('Difference between ruler and estimated height (cm)')

me = mean(all_eh-all_h);
ub= me + stdev*1.96;
lb= me - stdev*1.96;

line([150 220], [me me], 'LineStyle','-')
line([150 220], [ub ub], 'LineStyle','--')
line([150 220], [lb lb], 'LineStyle','--')
text(220, me+0.1,'mean','HorizontalAlignment','right', 'FontSize', 13);
text(220, ub-0.1,'-1.96SD','HorizontalAlignment','right', 'FontSize', 13);
text(220, lb+0.1,'+1.96SD','HorizontalAlignment','right', 'FontSize', 13);
