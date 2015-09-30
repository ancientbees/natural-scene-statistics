function stats = getSceneStats(scene, target_gabor, coords)

%% getSceneStats.m
%
%       stats = getSceneStats(scene, target_gabor [, coords])
%
%  Calculate scene stats (luminance, contrast and similarity) with respect
%  to gabor target. You can specify pixel coords [Y X], 0 for center pixel, and
%  [] (empty matrix [default]) for the full scene.

%  Configure gabor in a struct with the following fields:
%       target_gabor.std
%       target_gabor.sf
%       target_gabor.ori
%       target_gabor.phase
%       target_gabor.pixperdeg
%       target_gabor.odd_even   ('odd'/'even', default: 'odd')
%       target_gabor.envelope   ('gau'/'coswin', default: 'coswin')
%
%  Based on code from Yoon B and Steve S.
%  v2.0, July 2, 2015, Spencer Chen <spencer.chen@utexas.edu>
%/

%% check input
if (nargin < 2)
    target_gabor.std        = .14;
    target_gabor.sf         = 4;
    target_gabor.ori        = 90;
    target_gabor.phase      = 0;
    target_gabor.pixperdeg  = 120;
    target_gabor.odd_even   = 'odd';
    target_gabor.envelope   = 'coswin';
end


% gabor_parameters = [target_gabor.ori,                           ...
%                     target_gabor.sf  / target_gabor.pix2deg,    ...
%                     target_gabor.std * target_gabor.pix2deg,    ...
%                     target_gabor.std * target_gabor.pix2deg,    ...
%                     target_gabor.phase];
                
if (nargin < 3)
    coords = [];
end

if (ischar(scene))    % load file
    tmp = load(scene);
    scene = tmp.scene;
end

%% Create gabor and envelop
[target, envelope] = imgstats.gabor2D(target_gabor);


%% Calculate stats
Lstats = imgstats.getSceneLuminance (scene, envelope);
Cstats = imgstats.getSceneContrast  (scene, envelope, Lstats);
Sstats = imgstats.getSceneSimilarity(scene, target, envelope, Lstats);


%% Output
stats.L = Lstats.M;
stats.C = Cstats.Crms;
stats.S = Sstats.Smag;
stats.T = target;
stats.w = envelope;
stats.B = scene;
stats.tMatch = Sstats.tMatch;

% Convert luminance to % luminance and similarity to % similarity
stats.S = stats.S./0.47;
stats.L = (stats.L./(2^14-1)).*100;

if (~isempty(coords))
    if (numel(coords) == 1 && coords == 0)
        coords = round(size(scene)/2);
    end
    inds = sub2ind(size(scene), coords(:,1), coords(:,2));
    
    stats.L = stats.L(inds);
    stats.C = stats.C(inds);
    stats.S = stats.S(inds);
    
end
