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
%				[prm(1), prm(2)] is the center coordinates
%				prm(3) is the radius.
%
%	Example:
%		imFile='particle01.png';
%		im=imread(imFile);
%		opt=beadDetect('defaultOpt');
%		prm=beadDetect(im, opt, 1);

%	Category: Object detection
%	Roger Jang, 20150618

if nargin<1, selfdemo; return; end
if ischar(im) && strcmpi(im, 'defaultOpt')
	prm.dilationSize=5;
	prm.erosionSize=5;
	prm.edgeDetectionMethod='sobel';
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

if ischar(im) && exist(im), im=imread(im); end	% "im" is an image file name

imGray=rgb2gray(im);
level=graythresh(imGray);
imBw=im2bw(imGray, level);
se1 = strel('disk', opt.dilationSize); imBw2=imdilate(imBw, se1);
se2 = strel('disk', opt.erosionSize); imBw3=imerode(imBw2, se2);
imBw4= edge(imBw3, opt.edgeDetectionMethod);
[yEdge, xEdge]=find(imBw4);		% x and y coordinates of edge
n=length(xEdge);
A=[xEdge, yEdge, ones(n, 1)];
B=xEdge.^2+yEdge.^2;
th=A\B;
a=th(1)/2;
b=th(2)/2;
r=sqrt(th(3)+a^2+b^2);
prm=[a, b, r]';

if showPlot
	theta=linspace(0, 2*pi, 100);
	xCircle=r*cos(theta)+a;
	yCircle=r*sin(theta)+b;
	subplot(231); imshow(im); title('Original image');
	line(xCircle, yCircle, 'color', 'r');
	subplot(232); imshow(imGray); title('Converted to gray');
	line(xCircle, yCircle, 'color', 'r');
	subplot(233); imshow(imBw); title('After Otsu''s method');
	line(xCircle, yCircle, 'color', 'r');
	subplot(234); imshow(imBw2); title('After dilation');
	line(xCircle, yCircle, 'color', 'r');
	subplot(235); imshow(imBw3); title('After erosion');
	line(xCircle, yCircle, 'color', 'r');
	subplot(236); imshow(imBw4); title('Edge and the detected circle (in red)');
	line(xCircle, yCircle, 'color', 'r');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);