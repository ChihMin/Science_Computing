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
%		imFile='particle02.png';
%		im=imread(imFile);
%		opt=beadDetect('defaultOpt');
%		prm=beadDetect(im, opt, 1);

%	Category: Object detection
%	Roger Jang, 20150618

if nargin<1, selfdemo; return; end
if ischar(im) && strcmpi(im, 'defaultOpt')
	prm.objDetectOpt=objDetect('defaultOpt');
	prm.circleFitOpt=circleFit('defaultOpt');
	prm.edgeDetectionMethod='sobel';
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

if ischar(im) && exist(im), im=imread(im); end	% "im" is an image file name
opt.circleFitOpt.circleNum=1;	% This is fixed!

[objSet, imGray, imGray2, imBw, imBw2, imBw3]=objDetect(im, opt.objDetectOpt, showPlot);
% Find the obj with max. area
[maxValue, maxIndex]=max([objSet.Area]);
imBw4=0*imBw;
imBw4(objSet(maxIndex).PixelIdxList)=1;
selected=imGray(logical(imBw4));
intensityMean=mean(selected);
pixelNum=length(selected);
imBw5= edge(imBw4, opt.edgeDetectionMethod);
[yEdge, xEdge]=find(imBw5);		% x and y coordinates of edge
data=[xEdge'; yEdge'];
circlePrm=circleFit(data, opt.circleFitOpt);
prm=[circlePrm; intensityMean; pixelNum];

if showPlot
	theta=linspace(0, 2*pi, 100);
	a=circlePrm(1); b=circlePrm(2); r=circlePrm(3);
	xCircle=r*cos(theta)+a;
	yCircle=r*sin(theta)+b;
	subplot(337); imshow(imBw4); title('Max-area object');
	line(xCircle, yCircle, 'color', 'r');
	subplot(338); imshow(imBw5); title('Edge and the fitting circle');
	line(xCircle, yCircle, 'color', 'r');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);