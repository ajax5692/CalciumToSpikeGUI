function [xCoord,yCoord] = RoiCoordinateExporterFromSuite2p(stat,isCell,calciumToSpikeParams)

%This function exports the coordinates, i.e., the centroids of the ROIs
%detected by Suite2p and gives them an an x and y coordinate output

cellCounter = 1;
count = 0;

for cellIndex = 1:size(stat,2)
    
    switch calciumToSpikeParams.cellProbThres
        
        case 1
            
            if isCell(cellIndex,1) == 1 & isCell(cellIndex,2) >= calciumToSpikeParams.cellClassifierThreshold
                
                count = count + 1;
                
                if calciumToSpikeParams.PSNR(count) > 18                                                                   
        
                    xCoord(cellCounter) = double(stat{1,cellIndex}.med(1,1));
                    yCoord(cellCounter) = double(stat{1,cellIndex}.med(1,2));

                    cellCounter = cellCounter + 1;

                else
                    continue
                end
                
            else
                continue
            end                
                
            
        case 0
            
            if isCell(cellIndex,1) == 1
                
                count = count + 1;
                
                if calciumToSpikeParams.PSNR(count) > 18
        
                    xCoord(cellCounter) = double(stat{1,cellIndex}.med(1,1));
                    yCoord(cellCounter) = double(stat{1,cellIndex}.med(1,2));

                    cellCounter = cellCounter + 1;
                    
                else
                    continue
                end

            else
                continue
            end
            
    end
end