function precomputeImgStats(filePathIn, filePathOut)

% For each image in the filepath, precomputes the stats, and saves them
target.std        = .14;
target.sf         = 4;
target.ori        = 90;
target.phase      = 0;
target.pixperdeg  = 120;
target.odd_even   = 'odd';
target.envelope   = 'coswin';

D = dir([filePathIn '/*.mat']);

parfor imgIndex = 1:size(D, 1)
    disp(['Image: ' num2str(imgIndex) '/' num2str(size(D,1))]);
    
    % load the image
    I = load([filePathIn '\' D(imgIndex).name]);
    
    % compute the statistics
	stats = imgstats.getSceneStats(I.I_PPM, target);

    L = stats.L;
    C = stats.C;
    S = stats.S;
    tMatch = stats.tMatch;
    
    parSave([filePathOut '/' D(imgIndex).name], L, C, S, tMatch);
end

function parSave(filePath, L, C, S, tMatch)
    save(filePath, '-v6', 'L', 'C', 'S', 'tMatch');
    