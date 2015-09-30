function statStructOut = calculateStatsFromImage(imgIn, statsImgIn, smpCoords, surroundSizePix, patchSizePix)
%% calculateStatsFromImage.m
% Purpose: given an image, imgIn, computes several statistics

%% Clipped pixels

smpIndex        = sub2ind(size(imgIn), smpCoords(:,1), smpCoords(:,2));	% sample coordinates

% patch size window
pWin = ones(patchSizePix, patchSizePix);
pWin = pWin./sum(sum(pWin));

% surround size window
sWin = ones(surroundSizePix, surroundSizePix);
sWin = sWin./sum(sum(sWin));

imgInClippedMap  = imgIn == 100;                              % clipping map for the image
pClippedMap   	= calculateConv2D(imgInClippedMap,pWin);		% clipping map for the patch
sClippedMap   	= calculateConv2D(imgInClippedMap,sWin);		% clipping map for the surround

%% Mean luminance of the surround
sMeanLumImg = calculateConv2D(imgIn, sWin);

%% Image statistics

L               = statsImgIn.L(smpIndex);   % windowed mean luminance
C               = statsImgIn.C(smpIndex);   % contrast
S               = statsImgIn.S(smpIndex); 	% similarity
pClipped        = pClippedMap(smpIndex);	% patch clipped percent
sClipped        = sClippedMap(smpIndex);	% surround clipped percent
tMatch          = statsImgIn.tMatch(smpIndex);  % template match to target
sMeanLum        = sMeanLumImg(smpIndex);  % template match to target

%% Save the output variables as a structure
statStructOut = struct('smpCoords', smpCoords, 'L', L, 'C', C, 'S', S, 'sMeanLum', sMeanLum, 'pClipped', pClipped, 'sClipped', sClipped, 'tMatch', tMatch);
