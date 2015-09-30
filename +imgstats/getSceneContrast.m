function stats = getSceneContrast(imIn, wWin, Lstats)
%% getSceneContrast.m
%
%       stats = getSceneContrast(imIn, wWin, Lstats)
%
%  Calculate scene contrast. Based on Steve S.'s code.
%  Output:
%       stats.Crms:    windowed mean luminance
%       stats.Cs:       mean luminance over the entire matrix of wWin
%       stats.C:       mean luminance over the entire matrix of wWin
%       stats.CC:      mean luminance over the entire matrix of wWin

%% Preprocess images
% force envelope volume to 1
wWin = wWin./sum(sum(wWin));

% local mean luminance
lumBar                = Lstats.M;
lumBarS               = Lstats.Ms;
lumWeightedLocalNorm  = Lstats.M_norm;
lumWeightedLocalNormS = Lstats.Ms_norm;

% RMS contrast
cMap                  = lumWeightedLocalNorm  ./ lumBar;
cmapS 				  = lumWeightedLocalNormS ./ lumBarS;

% mean contrast
cBar 				  = imgstats.fftconv2(cMap,wWin);

% contrast-contrast
ccNumerator	          = imgstats.fftconv2(cMap.^2,wWin) - cBar.^2;
ccDenominator		  = cBar.^2;
ccNumerator(ccNumerator < 0) = 0;
ccMap                 = sqrt(ccNumerator./ccDenominator);

%% save patch information and statistics

% store image statistics 
stats.Crms = cBar;       	% windowed contrast
stats.Cs   = cmapS;			% mean contrast	
stats.C    = cMap;       	% contrast
stats.CC   = ccMap;      	% contrast contrast
