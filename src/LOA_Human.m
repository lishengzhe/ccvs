clear all
close all

%% load
path = '..\data\human';

subjectName = {'001'; '002'; '003'; '004'; '005';...
    '006'; '008'; '009'; '010'; '011'; '012'};
subjectHeight = [1.7450; 1.7650; 1.6950; 1.8450; 1.7050;...
    1.7950; 1.7050; 1.7350; 1.7650; 1.7400; 1.7300];
cameraName = {'01'; '02'; '03';'04'; '05'; '08'; '10'; '11'; '12'};
% cameraName = {'01'; '02'; '03';'04'; '05'; '08'; '10'; '11'; };
cameraWH = {[1280 720];[1280 720];[1280 720];[1280 720];...
    [1280 720];[1280 720];[1280 720];[720 480];[720 480]};

caliSubjectID = '001';

all_mean = cell(length(subjectName), length(cameraName));
all_std = cell(length(subjectName), length(cameraName));

all_eh =[];
all_h =[];

all_e =[];
all_y =[];
all_x =[];

for camIdx = 1:length(cameraName)
% for camIdx = 1:1
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
                
        all_mean{subjectIdx,camIdx} = mean(estimatedHeights);
        all_std{subjectIdx,camIdx} = std(estimatedHeights);
        
        all_eh = [all_eh;mean(estimatedHeights)*100];
        all_h = [all_h;rawPoints(1,6)];
        
        all_e = [all_e;estimatedHeights*100-rawPoints(:,6)];
        all_y = [all_y;yf];
        all_x = [all_x;xf];
        
    end 
end


% Error distribution
figure;
axes('FontSize',13);
hist(all_eh-all_h, 30);

mae = mean(abs(all_eh-all_h))
mae_r = mae/mean(subjectHeight)
me = mean(all_eh-all_h)
maxe = max(abs(all_eh-all_h))
maxe_r = maxe/mean(subjectHeight)

stdev = std(all_eh-all_h)
stdev_r = stdev/mean(subjectHeight)

title({'Distribition of estimated height error (cm)';'in walking human based evaluation'})
xlabel('Height error (cm)')
ylabel('Number of subjects')
% 
% % LOA mean
% figure;
% % subplot(2,1,2);
% axes('FontSize',13);
% scatter((all_eh+all_h)/2, all_eh-all_h, '.');
% hold on;
% title({'Limits of agreement';'in walking human based evaluation'})
% xlabel('Average of ruler and estimated height (cm)')
% ylabel('Difference between ruler and estimated height (cm)')
% 
% me = mean(all_eh-all_h);
% ub=prctile(all_eh-all_h,2.5)
% lb=prctile(all_eh-all_h,97.5)
% 
% line([165 190], [me me], 'LineStyle','-')
% line([165 190], [ub ub], 'LineStyle','--')
% line([165 190], [lb lb], 'LineStyle','--')
% text(190, me+0.5,'mean','HorizontalAlignment','right', 'FontSize', 13);
% text(190, ub-0.5,'-1.96SD','HorizontalAlignment','right', 'FontSize', 13);
% text(190, lb+0.5,'+1.96SD','HorizontalAlignment','right', 'FontSize', 13);

% LOA true
figure;
% subplot(2,1,2);
axes('FontSize',13);
scatter(all_h, all_eh-all_h, '.');
hold on;
title({'Limits of agreement';'in walking human based evaluation'})
xlabel('Ruler height (cm)')
ylabel('Difference between ruler and estimated height (cm)')

me = mean(all_eh-all_h);
ub= me + stdev*1.96;
lb= me - stdev*1.96;

line([165 190], [me me], 'LineStyle','-')
line([165 190], [ub ub], 'LineStyle','--')
line([165 190], [lb lb], 'LineStyle','--')
text(190, me+0.5,'mean','HorizontalAlignment','right', 'FontSize', 13);
text(190, ub-0.5,'-1.96SD','HorizontalAlignment','right', 'FontSize', 13);
text(190, lb+0.5,'+1.96SD','HorizontalAlignment','right', 'FontSize', 13);

figure;
scatter(all_y*720, all_e);hold on
title({'Correlation between height estimation error (cm) ','and y-coordinates(foot position)'})
xlabel('y-coordinate in image')
ylabel('Height estimation error (cm)')


figure; hold on
scatter(all_x*1280, all_e);
title({'Correlation between height estimation error (cm)',' and x-coordinates(foot position)'})
xlabel('x-coordinate in image')
ylabel('Height estimation error (cm)')

accuracy = 1 - mae_r/100
