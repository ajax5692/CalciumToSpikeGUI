function CompileSpikeData

for layerIndex = 1:3
    
    [fileName filePath] = uigetfile;
    cd(filePath)
    load(fileName)
    
    spikeData(layerIndex).layer = populationSpikeMatrix;

    clearvars -except spikeData
    
end

saveLocation = uigetdir('','Select the folder location to save the pooled spike data');
cd(saveLocation)
clear saveLocation
allSpikeMatrix = [spikeData(1).layer; spikeData(2).layer; spikeData(3).layer];
save('layerWiseSpikeData.mat','spikeData')
save('allLayerSpikesPooled.mat','allSpikeMatrix')