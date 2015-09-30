function stats = getSceneSimilarity(imIn, tarIn, wWin, Lstats)
%% getSceneSimilarity.m
%
%       stats = getSceneSimilarity(imIn, tarIn, wWin)
%
%  Calculate scene luminance. Based on Steve S.'s code.
%  Output:
%       stats.S:         similarity
%       stats.Smag:      magnitude of similarity
%       stats.tMatch:    templateMatch


%% Preprocess images
% force envelope volume to 1
wWin = wWin./sum(sum(wWin));

% local mean luminance
lumBarS               = Lstats.Ms;
lumWeightedLocalNormS = Lstats.Ms_norm;

N           = length(wWin(:));
tarBar      = mean2(tarIn);
targetNorm  = sqrt((1/N)*sum(sum(tarIn.^2))-tarBar^2);

% similarity
S_covariance = (1/N) * imgstats.fftconv2(imIn,tarIn) - lumBarS.*tarBar;

S_variance 	 = lumWeightedLocalNormS .* targetNorm;
S_map        = S_covariance./S_variance;
S_map(S_variance == 0) = 0; % a uniform field is by definition 0 similarity
S_bar_map    = imgstats.fftconv2(abs(S_map), wWin);

% template match
tar = tarIn - mean(tarIn(:));
tar = tar./max(tar(:));
templateMatch = imgstats.fftconv2(imIn, tar);


%% save patch information and statistics

% store image statistics 
stats.S      = S_map; 			% similarity
stats.Smag   = S_bar_map; 		% magnitude of similarity
stats.tMatch = templateMatch;