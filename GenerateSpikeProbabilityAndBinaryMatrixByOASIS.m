function [populationSpikeMatrix, populationSpikeProbability] = GenerateSpikeProbabilityAndBinaryMatrixByOASIS(deltaff)

%GenerateSpikeProbabilityAndBinaryMatrixByOASIS
%This function takes in the df/f values and evaluates the spike
%probabilities based on the OASIS module and the generates a binary 1/0
%matrix corresponding to the spikes.


w = waitbar(0, 'Starting');
totalCells = size(deltaff,1);
oasis_setup

for cellIndex = 1:size(deltaff,1)
    
    waitbar(cellIndex/totalCells, w, sprintf('Progress (OASIS)', floor(cellIndex/totalCells*100)));
    
    [c, s, options] = deconvolveCa(deltaff(cellIndex,:), 'foopsi', 'ar1', 'smin', -3, 'optimize_pars', true, 'optimize_b', true);
    
    populationSpikeProbability(cellIndex,:) = s;
    
    clear c s options
                
end

close(w)

%Generate 1/0 spike matrix for the population
w = waitbar(0, 'Starting');

for cellIndex = 1:size(populationSpikeProbability,1)
    
    waitbar(cellIndex/totalCells, w, sprintf('Progress (spikes)', floor(cellIndex/totalCells*100)));
    
    for frameIndex = 1:size(populationSpikeProbability,2)
        
        if populationSpikeProbability(cellIndex,frameIndex) > 0
            
            populationSpikeMatrix(cellIndex,frameIndex) = 1;
                
        else
                
            populationSpikeMatrix(cellIndex,frameIndex) = 0;
                
        end
    end
end

close(w)