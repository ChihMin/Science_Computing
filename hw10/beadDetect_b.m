function prm=beadDetect(im, opt, showPlot)
%circleDetect: Detect a single bead and return it's bounding circle
%
%	Usage:
%		prm=beadDetect(im, opt, showPlot)
%
%	Description:
%		prm=beadDetect(im, opt, showPlot) return the bounding circle of a bead in an image
%			im: input image
%			opt: options for this function
%			showPlot: 1 to show a plot; 0 for nothing
%			prm: parameters of the bounding circle, where
%				[prm(1), prm(2)]: center coordinates
%				prm(3): radius of the fitting circle
%				prm(4): intensity average of the object
%				prm(5): no. of pixels of the object
%
%	Example:
%		imFile='particles02.png';
%		im=imread(imFile);
%		opt=beadDetect('defaultOpt');
%		prm=beadDetect(im, opt, 1);

%	Category: Object detection
%	Roger Jang, 20150618

if nargin<1, selfdemo; return; end
if ischar(im) && strcmpi(im, 'defaultOpt')
	prm.medianFilterSize=5;
	prm.dilationSize=5;
	prm.erosionSize=5;
	prm.edgeDetectionMethod='sobel';
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

if ischar(im) && exist(im), im=imread(im); end	% "im" is an image file name

imGray=im;
if size(im, 3)>1, imGray=rgb2gray(im); end
imGray2=medfilt2(imGray, opt.medianFilterSize*[1 1]);
level=graythresh(imGray2);
imBw=im2bw(imGray2, level);
s=regionprops(imBw, 'Area', 'PixelIdxList');
[maxValue, maxIndex]=max([s.Area]);
imBw2=0*imBw;
imBw2(s(maxIndex).PixelIdxList)=1;
se1 = strel('disk', opt.dilationSize); imBw3=imdilate(imBw2, se1);
se2 = strel('disk', opt.erosionSize); imBw4=imerode(imBw3, se2);
selected=imGray(logical(imBw4));
intensityMean=mean(selected);
pixelNum=length(selected);
imBw5= edge(imBw4, opt.edgeDetectionMethod);
[yEdge, xEdge]=find(imBw5);		% x and y coordinates of edge
circlePrm=circleFit([xEdge'; yEdge'], []);
prm=[circlePrm; intensityMean; pixelNum];

if showPlot
	theta=linspace(0, 2*pi, 100);
	a=circlePrm(1); b=circlePrm(2); r=circlePrm(3);
	xCircle=r*cos(theta)+a;
	yCircle=r*sin(theta)+b;
	subplot(331); imshow(im); title('Original image');
	line(xCircle, yCircle, 'color', 'r');
	subplot(332); imshow(imGray); title('Converted to gray');
	line(xCircle, yCircle, 'color', 'r');
	subplot(333); imshow(imGray2); title('After median filter');
	line(xCircle, yCircle, 'color', 'r');
	subplot(334); imshow(imBw); title('After Otsu''s method');
	line(xCircle, yCircle, 'color', 'r');
	subplot(335); imshow(imBw2); title('Max-area region');
	line(xCircle, yCircle, 'color', 'r');
	subplot(336); imshow(imBw3); title('After dilation');
	line(xCircle, yCircle, 'color', 'r');
	subplot(337); imshow(imBw4); title('After erosion');
	line(xCircle, yCircle, 'color', 'r');
	subplot(338); imshow(imBw5); title('Edge and the detected circle (in red)');
	line(xCircle, yCircle, 'color', 'r');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);