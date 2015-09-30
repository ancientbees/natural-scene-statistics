function outIm = scaleScene(inIm, pixperdeg, bitdepth)

%% scaleScene.m
%
%       outIm = scaleScene(inIm, pixperdeg, bitdepth)
%
%  Scale image inIm from pixeperdeg(1) and bitdepth(1) to outIm with
%  pixperdeg(2) and bidepth(2);
%

% resize
outIm = imresize(inIm, pixperdeg(2)/pixperdeg(1));

% change bitdepth
outIm = outIm * 2^(bitdepth(2)-bitdepth(1));
outIm = floor(outIm);
outIm(outIm >= 2^bitdepth(2)) = 2^bitdepth(2) - 1;

 
