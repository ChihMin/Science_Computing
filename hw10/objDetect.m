function [objSet, imGray, imGray2, imBw, imBw2, imBw3]=objDetect(im, opt, showPlot)
%circleDetect: Detect a single bead and return it's bounding circle
%
%	Usage:
%		objSet=objDetect(im, opt, showPlot)
%
%	Description:
%		objSet=objDetect(im, opt, showPlot) return the bounding circle of a bead in an image
%			im: input image
%			opt: options for this function
%			showPlot: 1 to show a plot; 0 for nothing
%			objSet: set of objects
%
%	Example:
%		imFile='particles04.png';
%		im=imread(imFile);
%		opt=objDetect('defaultOpt');
%		objSet=objDetect(im, opt, 1);

%	Category: Object detection
%	Roger Jang, 20150618

if nargin<1, selfdemo; return; end
if ischar(im) && strcmpi(im, 'defaultOpt')
	objSet.medianFilterSize=5;
	objSet.dilationSize=5;
	objSet.erosionSize=5;
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

if ischar(im) && exist(im), im=imread(im); end	% "im" is an image file name

imGray=im;
if size(im, 3)>1, imGray=rgb2gray(im); end
imGray2=imGray;
if opt.medianFilterSize>1, imGray2=medfilt2(imGray, opt.medianFilterSize*[1 1]); end
level=graythresh(imGray2);
imBw=im2bw(imGray2, level);
imBw2=imBw;
if opt.dilationSize>1, imBw2=imdilate(imBw2, strel('disk', opt.dilationSize)); end
imBw3=imBw2;
if opt.erosionSize>1, imBw3=imerode(imBw3, strel('disk', opt.erosionSize)); end

property={'BoundingBox', 'Area', 'Perimeter', 'PixelIdxList', 'Centroid', 'MajorAxisLength', 'MinorAxisLength'};
objSet=regionprops(imBw3, property);

if showPlot
	subplot(331); imshow(im); title('Original image');
	subplot(332); imshow(imGray); title('Converted to gray');
	subplot(333); imshow(imGray2); title('After median filter');
	subplot(334); imshow(imBw); title('After Otsu''s method');
	subplot(335); imshow(imBw2); title('After dilation');
	subplot(336); imshow(imBw3); title('After erosion');
	hold on
	for i=1:length(objSet)
		rectangle('position', objSet(i).BoundingBox, 'edgeColor', getColorLight(i));
	end
	hold off
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);