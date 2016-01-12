%% imFeaLgbp
% Local Gabor binary pattern for images
%% Syntax
% * 		patchHist = imFealgbp(im)
% * 		patchHist = imFeaLgbp(im, opt)
% * 		patchHist = imFeaLgbp(im, opt, showPlot)
% * 		[patchHist, lbpIm] = imFeaLgbp(...)
%% Description
%
% <html>
% <p>patchHist = imFeaLbp(im, opt, showPlot) returns the aggregated patch histogram of LGBP (local Gabor binary patterns)
% 	<ul>
% 	<li>im: Given image
% 	<li>opt: Options for LGBP computation
% 		<ul>
% 		<li>opt.orientation = 8;%%  Gabor Orientation
% 		<li>opt.scale = 5;%%  Gabor Scale
% 		<li>opt.mask = [32 32];%%  Gabor Mask
% 		<li>opt.blockSize = 8;%%  LBP Blocksize
% 		</ul>
% 	<li>showPlot: 1 for plotting the results
% 	</ul>
% <p>[patchHist, lbpIm] = imFeaLgbp(...) returns the LBP image as well.
% </html>
%% Example
%%
%
im=imread('catPangPang.png');
opt=imFeaLgbp('defaultOpt');
[patchHist, lbpIm]=imFeaLgbp(im, opt, 1);
