function patchIndex = getPatchIndexInBin(statStruct, binIndex)
%% getPatchIndexInBin(binIndex)
%
%       patchIndex = getPatchIndexInBin(statStruct, binIndex)
%
% Given a bin index [1x3 double], returns the statStruct index of all the
% patches in that bin.
%  Output:
%       patchIndex:     index of all the patches in the specified bin

%%

patchIndex = find(statStruct.binIndex(:,1) == binIndex(1) & statStruct.binIndex(:,2) == binIndex(2) & statStruct.binIndex(:,3) == binIndex(3));