function CompileROIData

%This function creates a matrix containing all the ROI coordinate
%information across the different layers.

for layerIndex = 1:3
    
    [fileName filePath] = uigetfile;
    cd(filePath)
    load(fileName)
    
    roiCoordData(layerIndex,1).layer = xCoord;
    roiCoordData(layerIndex,2).layer = yCoord;

    clearvars -except roiCoordData
    
end

saveLocation = uigetdir('','Select the folder location to save the pooled ROI coordinate data');
cd(saveLocation)
clear saveLocation
allROIMatrix = [roiCoordData(1,1).layer roiCoordData(2,1).layer roiCoordData(3,1).layer ;...
                    roiCoordData(1,2).layer roiCoordData(2,2).layer roiCoordData(3,2).layer];

save('layerWiseRoiCoordData.mat','roiCoordData')
save('allLayerROIsPooled.mat','allROIMatrix')