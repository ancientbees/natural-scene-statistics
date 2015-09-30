function statStruct = loadStatStruct
%% loadStatStruct.m
%
%       stats = loadStatStruct(filePath)
%
%  Loads in the structure of precomputed statsitics from images in the
%  natural image database.
%
%  The output structure has the following fields:
%       L [numSamplesXnumImages double]: patch % mean luminance (max 100)
%       C [numSamplesXnumImages double]: patch RMS contrast
%       S [numSamplesXnumImages double]: patch similarity (max 1)
%       tMatch [numSamplesXnumImages double]: patch match to target
%       imName [numSamplesXnumImages double]: patch parent image name
%       patchSizePix: patch diameter in pixels
%       surroundSizePix: surround diameter in pixels (used for experiment)
%       target: simulus target (used for computing S and tMatch)
%       binIndex [(numSamples x numImages)X 3 double]: 
%           bin where the patch falls (:,1) = L, (:,2) = C, (:,3) = S
%       binCenters [struct]: Bin center locations for .L, .C, and .S
%       binEdges [struct]: Bin edges for .L, .C, and .S
%
%  v1.0, August 13, 2015, Stephen Sebastian <sebastian@utexas.edu>
%/

%%

filePath = 'D:\Sebastian\stats_8_13_2015\statStruct.mat';
ssLoad = load(filePath);

statStruct = ssLoad.statStruct;