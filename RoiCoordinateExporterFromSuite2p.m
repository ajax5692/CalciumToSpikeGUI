function [xCoord,yCoord] = RoiCoordinateExporterFromSuite2p(stat,isCell,calciumToSpikeParams)


cellCounter = 1;

for cellIndex = 1:size(stat,2)
    
    switch calciumToSpikeParams.cellProbThres
        
        case 1
            
            if isCell(cellIndex,1) == 1 & isCell(cellIndex,2) >= calciumToSpikeParams.cellClassifierThreshold
        
                xCoord(cellCounter) = double(stat{1,cellIndex}.med(1,1));
                yCoord(cellCounter) = double(stat{1,cellIndex}.med(1,2));

                cellCounter = cellCounter + 1;

            else
                continue
            end
            
        case 0
            
            if isCell(cellIndex,1) == 1
        
                xCoord(cellCounter) = double(stat{1,cellIndex}.med(1,1));
                yCoord(cellCounter) = double(stat{1,cellIndex}.med(1,2));

                cellCounter = cellCounter + 1;

            else
                continue
            end
            
    end
end