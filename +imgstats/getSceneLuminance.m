function stats = getSceneLuminance(imIn, wWin)
%% getSceneLuminance.m
%
%       stats = getSceneLuminance(imIn, wWin)
%
%  Calculate scene luminance. Based on Steve S.'s code.
%  Output:
%       stats.M:         windowed mean luminance
%       stats.Ms:        mean luminance over the entire matrix of wWin
%       stats.M_norm:    lumWeightedLocalNorm
%       stats.Ms_norm:   lumWeightedLocalNormS


%% Preprocess images
% force envelope volume to 1
wWin = wWin / sum(wWin(:));

% indicator function (logical window)
pWin = ones(size(wWin));
pWin = pWin / sum(pWin(:));

% local mean luminance
lumBar  = imgstats.fftconv2(imIn, wWin);
lumBarS = imgstats.fftconv2(imIn, pWin);

% luminance variance
weightedSquaredNorm   = imgstats.fftconv2(imIn.^2, wWin) - lumBar.^2;
weightedSquaredNormS  = imgstats.fftconv2(imIn.^2, pWin) - lumBarS.^2;

weightedSquaredNorm(weightedSquaredNorm < 0) = 0;
weightedSquaredNormS(weightedSquaredNormS < 0) = 0;

lumWeightedLocalNorm  = sqrt(weightedSquaredNorm);
lumWeightedLocalNormS = sqrt(weightedSquaredNormS);

%% output
stats.M       = lumBar;
stats.Ms      = lumBarS;
stats.M_norm  = lumWeightedLocalNorm;
stats.Ms_norm = lumWeightedLocalNormS;
