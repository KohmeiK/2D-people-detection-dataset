clc
clf
% ptCloud = pcread('PCD_AK_Empty/1627588019.655621767.pcd');
% ptCloud2 = pcread('PCD_AK_Empty/1627588023.084883690.pcd');
% locs = ptCloud.Location;
% locs2 = ptCloud2.Location;

locationString = "FOISE";

mkdir('PCD_'+locationString+'_People');
mkdir('PCD_'+locationString+'_Enviroment');

%Create angle buckets
angles = linspace(-180,179.3591,897.53)';
buckets = NaN(897,1);

%% Find the closest value found for each angle in a empty room

Files=dir('PCD_'+locationString+'_Empty/*.pcd');
hold on
view([0.00 90.00])
grid off
box on 
for k=1:length(Files)
    %     disp("PCD_AK_Empty/"+(Files(k).name))
    ptCloud = pcread("PCD_"+locationString+"_Empty/"+(Files(k).name));
    pcshow(ptCloud);
    for i = 1:ptCloud.Count
        %       disp("Processing index "+i);
        
        %Find Angle
        angle = rad2deg(atan2(ptCloud.Location(i,2),ptCloud.Location(i,1)));
        %       disp(angleDegToIndex(angle));
        %       disp(angle)
        
        %Find distance
        distance = norm(ptCloud.Location(i,1:2));
        %       disp(distance)
        
        %Find corresponding bucket
        bucketIndex = angleDeg2Index(angle);
        
        %If distance is smaller than current value replace
        if isnan(buckets(bucketIndex)) || buckets(bucketIndex) > distance
            buckets(bucketIndex) = distance;
        end
        
    end
end

%Check if any buckets are emtpy

disp("Empty (Missing) Buckets that will be interpolated:")

for i=1:length(buckets)
    if isnan(buckets(i))
        disp(i);
    end
end

buckets = fillmissing(buckets,'nearest');

%Print buckets

disp("Read and processed "+k+" empty pcd files!");
disp("Now Labeling data with people...");

%% Now find points that are closer then the empty room


Files=dir('PCD_'+locationString+'_Both/*.pcd');
for k=1:length(Files)
    % for k=1:101
    
    % Let A be the array that i am going to use, Initialize to large number
    IndexesToSelectPOS = zeros(1,897);
    IndexesToSelectNEG = zeros(1,897);
    % assign a counter that tracks the actual size of your array
    counterPOS = 1;
    counterNEG = 1;
    
    %     disp("PCD_AK_Empty/"+(Files(k).name))
    ptCloud = pcread("PCD_"+locationString+"_Both/"+(Files(k).name));
    
    for i = 1:ptCloud.Count
        %       disp("Processing index "+i);
        
        %Find Angle
        angle = rad2deg(atan2(ptCloud.Location(i,2),ptCloud.Location(i,1)));
        %       disp(angleDegToIndex(angle));
        %       disp(angle)
        
        %Find distance
        distance = norm(ptCloud.Location(i,1:2));
        %       disp(distance)
        
        %Find corresponding bucket
        bucketIndex = angleDeg2Index(angle);
        
        %Manual Mask
%         x = ptCloud.Location(i,1);
%         y = ptCloud.Location(i,2);
%         
        makeFalse = 0;
%         if x > 16 && x < 16.6 && y > -0.5 && y < 0.5
%             makeFalse = 1;
%         end
        
        %If distance is smaller than current value replace
        if distance + 0.05 < buckets(bucketIndex) && makeFalse == 0
            %This point is a person
            IndexesToSelectPOS(counterPOS) = i;
            counterPOS = counterPOS + 1;
        else
            %This point is not a person
            IndexesToSelectNEG(counterNEG) = i;
            counterNEG = counterNEG + 1;
        end
        
    end
    
    IndexesToSelectPOS = IndexesToSelectPOS(1:counterPOS-1); % removes the rest of non used array
    IndexesToSelectNEG = IndexesToSelectNEG(1:counterNEG-1);
    
    ptCloudOut = select(ptCloud,IndexesToSelectPOS);
    pcwrite(ptCloudOut,"PCD_"+locationString+"_People/"+(Files(k).name));
    
    ptCloudOut = select(ptCloud,IndexesToSelectNEG);
    pcwrite(ptCloudOut,"PCD_"+locationString+"_Enviroment/"+(Files(k).name));
    
    %     disp("This file started with "+ptCloud.Count+" points and after BG-removal has "+ptCloudOut.Count+" points.")
    
end

disp("Labled "+k+" positive PCD files!");
disp("Now starting playback in figure...");


%% Test Area

clf

pause(10)

r = rateControl(2.5);

%Stop at frame number (Inf -> play till end)
limit = 20;

for k=1:min(length(Files),limit)
    ptCloud = pcread("PCD_"+locationString+"_Enviroment/"+(Files(k).name));
    ptCloudPOS = pcread("PCD_"+locationString+"_People/"+(Files(k).name));
    clf
    hold on
    plot(0,0,'ro')
    pcshowpair(ptCloud,ptCloudPOS);
    hold off
    xlim([-7 5])
    ylim([-3 2])
    view([0.00 90.00])
    grid off
    box on 
    drawnow
%     waitfor(r);
end

% player = pcplayer([-10 10],[-10 10],[-1 1]);
% while isOpen(player)
%     for k=1:length(Files)
%          ptCloud = pcread("PCD_AK_Positives/POS"+(Files(k).name));
%          view(player,ptCloud);
%     end
% end

%% Functions

function [index] = angleDeg2Index(angleDeg)
index = round(angleDeg / 0.40107033 + 449.5);
if index == 898
    %Special case since 180 = -180
    index = 1;
end
end