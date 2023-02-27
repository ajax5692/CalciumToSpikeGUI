function [deltaff,PSNR] = ReadRawFluorAndDff_original(calciumToSpikeParams)

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

% timeStamp = (1:numel(F(1,:))).*(1/calciumToSpikeParams.frameRate); %This is in seconds

% %Sanity check of the fluorescence trace
% figure
% plot(timeStamp,F(1,:))
% xlabel('Time(s)')
% ylabel('Raw fluorescence (AU)')
% xlim([0 timeStamp(end)])


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

                    for frameIndex = 1:size(F,2)

                        %Calculating df/f by (F-Fneu)/avgFneu (avgFneu is calculated by taking the average of 100 frames of Fneu)
                        if (frameIndex+99) <= frameIndex
                            avgFneu = mean(Fneu(cellIndex,frameIndex+99));
                            deltaff(cellCounter,frameIndex) = (F(cellIndex,frameIndex) - Fneu(cellIndex,frameIndex))/avgFneu;
                        elseif (frameIndex+99) > frameIndex
                            avgFneu = mean(Fneu(cellIndex,end-99:end));
                            deltaff(cellCounter,frameIndex) = (F(cellIndex,frameIndex) - Fneu(cellIndex,frameIndex))/avgFneu;
                        end

                    end

                    deltaff(cellCounter,:) = deltaff(cellCounter,:)/max(deltaff(cellCounter,:)); %Normalizing the df/f
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

                         for frameIndex = 1:size(F,2)

                             %Calculating df/f by (F-Fneu)/avgFneu (avgFneu is calculated by taking the average of 100 frames of Fneu)
                             if (frameIndex+99) <= frameIndex
                                 avgFneu = mean(Fneu(cellIndex,frameIndex+99));
                                 deltaff(newCounter,frameIndex) = (F(cellIndex,frameIndex) - Fneu(cellIndex,frameIndex))/avgFneu;
                             elseif (frameIndex+99) > frameIndex
                                 avgFneu = mean(Fneu(cellIndex,end-99:end));
                                 deltaff(newCounter,frameIndex) = (F(cellIndex,frameIndex) - Fneu(cellIndex,frameIndex))/avgFneu;
                             end

                         end

                        deltaff(newCounter,:) = deltaff(newCounter,:)/max(deltaff(newCounter,:)); %Normalizing the df/f
                    
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

% %Sanity check of the interpolated fluorescence trace
% figure
% for ii = 1:size(dffByMedian,1)
%     plot(timeStamp,dffByMedian(ii,:))
%     xlabel('Time(s)')
%     ylabel('Raw fluorescence (AU)')
%     xlim([0 timeStamp(end)])
%     pause
% end



    
