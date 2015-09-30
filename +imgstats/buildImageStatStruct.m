function statStruct = buildImageStatStruct(fpImg, fpStatImg, surroundSizePix, targetSizePix)
%% buildImageStatStruct.m
%
%       statStruct = buildImageStatStruct(surroundSizePix, targetSizePix)
%
% For every image stored in filePathStr, computes the relavent statistics
%Input:
%	surroundSizePix     - surround size in pixels
%	targetSizePix       - patch size in pixels
%   fpImg               - file path of the natural image database
%   fpStatImg           - file path of the precomputed stat images
%Output:
%           statStruct          - structure containing the image locations
%                                   and statistics

%% Input handling

% Default parameters for the natural masking project
if(~exist('surroundSizePix', 'var') || isempty(surroundSizePix))
    surroundSizePix = 513;
end

if(~exist('targetSizePix ', 'var') || isempty(targetSizePix ))
    targetSizePix = 101;
end

if(~exist('fpImg ', 'var') || isempty(fpImg))
    fpImg             = 'D:\Sebastian\natural_images\images_stats\';
end

if(~exist('fpStatImg ', 'var') || isempty(fpStatImg))
    fpStatImg           = 'D:\Sebastian\natural_images_stats_9_10_2015\';
end

%% Information about images

% Default size of the image
imgSize = [2844 4284];

% sample patch coordinates
sampleCoords    = samplePatchCoordinates(imgSize, [surroundSizePix surroundSizePix], round(targetSizePix/7));

% file path where images are stored. 

D                       = dir([fpImg '\*.mat']);

%% Variable set up

numImages =  size(D, 1);

% initialize arrays

smpCoordsArray      = zeros(size(sampleCoords, 1), 2, numImages);

L               = zeros(size(sampleCoords, 1), numImages); %  %luminance 
C               = zeros(size(sampleCoords, 1), numImages); % rms contrast
S               = zeros(size(sampleCoords, 1), numImages); % target/background similarity
tMatch          = zeros(size(sampleCoords, 1), numImages); % template match to target
sMeanLum        = zeros(size(sampleCoords, 1), numImages); % mean of the surround patch
pClipped        = zeros(size(sampleCoords, 1), numImages); % percentage of clipped pixels in a patch

%% Process each image

parfor imgItr = 1:numImages 
    disp(['Image number: ' num2str(imgItr)]);
    
    % load in the original image and the image stats
    img      = load([fpImg '/' D(imgItr).name]);
    imgStats = load([fpStatImg '/' D(imgItr).name]);

    % compute the statistics
    imgStatStruct = nm.stats.calculateStatsFromImage(img.I_PPM, imgStats, sampleCoords, surroundSizePix, targetSizePix);

    % store the structure elements in arrays
    smpCoordsArray(:, :, imgItr)   = imgStatStruct.smpCoords; 
    L(:, imgItr)                   = imgStatStruct.L;
    C(:, imgItr)                   = imgStatStruct.C;
    S(:, imgItr)                   = imgStatStruct.S;
    tMatch(:, imgItr)              = imgStatStruct.tMatch;
    sMeanLum(:, imgItr)            = imgStatStruct.sMeanLum;
    pClipped(:, imgItr)            = imgStatStruct.pClipped;
end;

%% Save the statistics structure

statStruct = struct('L', L, 'C', C, 'S', S, 'tMatch', tMatch, 'pClipped', pClipped, 'sMeanLum', sMeanLum, ...
    'surroundSizePix', surroundSizePix, 'targetSizePix', targetSizePix, 'smpCoords', smpCoordsArray, 'imgDir', D);



