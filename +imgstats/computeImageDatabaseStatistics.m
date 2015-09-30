function [statStruct, imName] = computeImageDatabaseStatistics(surroundSizePix, patchSizePix, W, T)
%% Purpose: for every image stored in filePathStr, computes the relavent statistics
%   Input:
%           surroundSizePix     - surround size in pixels
%           patchSizePix        - patch size in pixels
%           W                   - weighting function
%           T                   - target
%   Output:
%           statStruct          - structure containing the image locations
%                                   and statistics
%
%

%% Input handling

% Generate the window (W) and the target (T) if they are not specified
% Defualt to cosine window and gabor target

if(~exist('W', 'var') || isempty(W))
    pixPerDeg   = 120;
    sizeDeg     = patchSizePix./pixPerDeg;
    [~, W]      = gaborCosineW2D(0.5, 4, 90, 90,  sizeDeg, pixPerDeg, 128, 0);
end;

if(~exist('T', 'var') || isempty(T))
    pixPerDeg   = 120;
    sizeDeg     = patchSizePix./pixPerDeg;
    [T, ~]      = gaborCosineW2D(0.5, 4, 90, 90,  sizeDeg, pixPerDeg, 128, 0);
end;

%% Information about images

% Default size of the image
imgSize = [2844 4284];

% sample patch coordinates
sampleCoords    = samplePatchCoordinates(imgSize, [surroundSizePix surroundSizePix], round(patchSizePix/7));

% file path where images are stored. 

% Natural images
filePathStr             = 'D:\Sebastian\natural_images\images_stats';
D                       = dir(filePathStr);
filePathsArray          = [repmat([filePathStr '\'], [(sum([D.isdir] == 0)) 1]) cat(1,D(~([D.isdir])).name)];
   

%% Variable set up

numImages =  size(filePathsArray, 1);

% initialize arrays
imName              = char(zeros(size(sampleCoords, 1), 19, numImages));
imSet               = char(zeros(size(sampleCoords, 1), 6, numImages));

smpCoordsArray      = zeros(size(sampleCoords, 1), 2, numImages);

L               = zeros(size(sampleCoords, 1), numImages); %  %luminance 
C               = zeros(size(sampleCoords, 1), numImages); % rms contrast
S               = zeros(size(sampleCoords, 1), numImages); % target/background similarity
tMatch          = zeros(size(sampleCoords, 1), numImages); % template match to target
sMeanLum        = zeros(size(sampleCoords, 1), numImages); % mean of the surround patch
pClipped        = zeros(size(sampleCoords, 1), numImages); % percentage of clipped pixels in a patch
tMatch          = zeros(size(sampleCoords, 1), numImages); % template match to target

%% Load in each image file in the directory
parfor fIndex = 1:numImages 
    disp(['Image number: ' num2str(fIndex)]);
    
    % load in the original image and the image stats
    img      = load([filePathImg '/' D(imgItr).name]);
    imgStats = load([filePathStats '/' D(imgItr).name]);

    % compute the statistics
    imgStatStruct = calculateStatsFromImage(img.I_PPM, imgNameStr, img.imagesetStr, T, W, surroundSizePix, patchSizePix, sampleCoords);

    % store the structure elements in arrays
    imName(:,:,fIndex)               = imgStatStruct.imName;
    imSet(:,:,fIndex)                = imgStatStruct.imSet;
    smpCoordsArray(:, :, fIndex)   = imgStatStruct.smpCoords; 
    M(:, fIndex)                   = imgStatStruct.M;
    Ms(:, fIndex)                  = imgStatStruct.Ms;
    Crms(:, fIndex)                = imgStatStruct.Crms;
    C(:, fIndex)                   = imgStatStruct.C;
    Cs(:, fIndex)                  = imgStatStruct.Cs;
    CC(:, fIndex)                  = imgStatStruct.CC;
    S(:, fIndex)                   = imgStatStruct.S;
    Smag(:, fIndex)                = imgStatStruct.Smag;
    SmagG(:, fIndex)               = imgStatStruct.SmagG;
    sMeanLum(:, fIndex)            = imgStatStruct.sMeanLum;
    pClipped(:, fIndex)            = imgStatStruct.pClipped;
    sClipped(:, fIndex)            = imgStatStruct.sClipped;
    tMatch(:, fIndex)              = imgStatStruct.tMatch;
end;

%% Save the statistics structure
statStruct = struct('T', T, 'smpCoords', smpCoordsArray, 'surroundSizePix', surroundSizePix, 'patchSizePix', patchSizePix, ...
    'M', M, 'Ms', Ms, 'Crms', Crms, 'C', C, 'Cs', Cs, 'CC', CC, 'S', S, 'Smag', Smag, 'SmagG', SmagG, 'pClipped', pClipped, 'sClipped', sClipped, 'tMatch', tMatch, 'sMeanLum', sMeanLum, 'imName', imName, 'imSet', imSet);





