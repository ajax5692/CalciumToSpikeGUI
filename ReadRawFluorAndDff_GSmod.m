function [deltaff,PSNR] = ReadRawFluorAndDff(calciumToSpikeParams)

%ReadRawFluorAndDff_MOD
%This function reads the raw cell fluorescence data (neuropil subtracted)
%from the Fall.mat file generated by Suite2p and then creates a matrix
%containing all the df/f data by 

%The Fall.mat file from Suite2p has the variable F and Fneu corresponding to
%the raw fluorescence and the neuropil fluorescence data respectively.


[matFilename matFilepath] = uigetfile('','Open the fluorescence data from Suite2p');
cd(matFilepath)
load(matFilename);

warning off

%This section now evaluates the df/f by the (F-Fneu)/Fneu method
%There are several conditions, which if met, would lead to df/f
%calculation: (1)It has to be a cell, (2)It has to have values of cell
%probability higher than the threshold value what was set in the suite2p
%classifier(generally 0.5)


f = waitbar(0, 'Starting');
n = sum(isCell(:,1));
counter = 0;
cellCounter = 1;
newCounter = 0;

for cellIndex = 1:size(F,1)
    
    switch calciumToSpikeParams.cellProbThres
        
        case 1
            
            waitbar(cellCounter/n, f, sprintf('Progress', floor(cellCounter/n*100)));
            
            if isCell(cellIndex,1) == 1 & isCell(cellIndex,2) >= calciumToSpikeParams.cellClassifierThreshold
                
                counter = counter + 1;
                
                %Applying 18db PSNR filter
                PSNR(counter) = 20 * log10(max(F(cellIndex,:)-Fneu(cellIndex,:))/std(Fneu(cellIndex,:)));

                if PSNR(counter) > 18

                     avgFneu = imgaussfilt(Fneu(cellIndex,:),50);
                     temp = F(cellIndex,:) - 0.7*avgFneu;
                     bl = mode(int16(temp));
                     deltaff(cellCounter,:) = temp/double(bl) - 1;
                     cellCounter = cellCounter + 1;

                else
                    continue
                end

            else
                continue
            end

            
             case 0
                 
                 if isCell(cellIndex,1) == 1
                     
                     newCounter = newCounter + 1;
                     
                     waitbar(newCounter/n, f, sprintf('Progress', floor(cellCounter/n*100)));

                     %Applying 18db PSNR filter
                     PSNR(newCounter) = 20 * log10(max(F(cellIndex,:)-Fneu(cellIndex,:))/std(Fneu(cellIndex,:)));

                     if PSNR(newCounter) > 18

                         avgFneu = imgaussfilt(Fneu(cellIndex,:),50);
                         temp = F(cellIndex,:) - 0.7*avgFneu;
                         bl = mode(int16(temp));
                         deltaff(cellCounter,:) = temp/double(bl) - 1;
                         cellCounter = cellCounter + 1;
                    
                    else
                        continue
                    end

                else
                    continue
                end

    end
                 
                 
end

close(f)

deltaff = double(deltaff);



warning on
    