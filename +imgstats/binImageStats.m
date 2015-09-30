
function [binIndex, binCenters, binEdges] = binImageStats(statStruct, binEdges)
%% binImageStats.m
%
%       [binIndex, binCenters, binEdges] = binImagesStats(statStruct)
%
% Generate the 3D histogram of image statistics
%Input: 
%       statStruct  - structure containing the statistics of each image patch
%       binEdges - structure containing the edges for L, C and S bins
%Output: 
%       binIndex    - 3xN matrix of bin indicies
%       binCenters  - structure containing the L, C, and S bin centers
%       binEdges    - structure containing the L, C, and S bin edges


%% Set up

% Default edges for the natural masking project
if(~exist('binEdges', 'var') || isempty(binEdges))
    binEdges.L = [0, 6.1785, 7.7782, 9.7922, 12.3276, 15.5196, 19.5380, 24.5969, 30.9656, 38.9834, 49.0772, 61.7845, Inf];
    binEdges.C = [0, 0.0350, 0.0562, 0.0824, 0.1136, 0.1498, 0.1910 ,0.2372, 0.2885, 0.3447, 0.4059, 0.4721 Inf];
    binEdges.S = [0, 0.0426, 0.0723, 0.1021, 0.1319, 0.1617, 0.1915, 0.2213, 0.2511, 0.2809, 0.3106, 0.3404, Inf];
end

binCenters.L = mean([lEdges(1:end-1);lEdges(2:end)]);
binCenters.C = mean([cEdges(1:end-1);cEdges(2:end)]);
binCenters.S = mean([sEdges(1:end-1);sEdges(2:end)]);

binIndex = zeros(size(statStruct.C, 1), size(statStruct.C, 2), 3);

%% Bin statistics into 3D histogram

for coordItr = 1:size(statStruct.C, 1)
    for imgItr = 1:size(statStruct.C, 2)
        L = statStruct.L(coordItr, imgItr);
        C = statStruct.C(coordItr, imgItr);
        S = statStruct.S(coordItr, imgItr);
        pClipped = statStruct.pClipped(coordItr, imgItr);
        
        if(pClipped > 0.1)
            binIndex(coordItr, imgItr,:) = [0 0 0];
        else
            currBinIndex(1) = find(lEdges > L, 1) - 2;
            currBinIndex(2) = find(cEdges > C, 1) - 2;
            currBinIndex(3) = find(sEdges > S, 1) - 2;
            
            binIndex(coordItr, imgItr,:) = currBinIndex;
        end

    end
end