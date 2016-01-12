function frameMat = frameZeroMean(frameMat, polyOrder);
% frameZeroMean: Make a frame zero mean by using polyfit
%
%	Usage:
%		frameMat = frameZeroMean(frameMat, polyOrder);
%
%	Description:
%		frameZeroMean(frameMat, polyOrder) returns the frame matrix after mean subtraction
%			frameMat: a column vector of a frame, or a matrix where each column is a frame
%			polyOrder: order of polyfit (0 for DC, 1 for line, 2 for quadratic, etc)
%		This function is usually used before computing volume, hod, etc. 
%
%	Example:
%		waveFile='star_noisy.wav';
%		au=myAudioRead(waveFile);
%		epdPrm=epdPrmSet(au.fs);
%		for i=0:3
%			figure;
%			subplot(3,1,1); plot(au.signal); title('Original');
%			frameMat=buffer2(au.signal, epdPrm.frameSize, epdPrm.overlap);
%			frameMat=frameZeroMean(frameMat, i);
%			y2=frameMat(:);
%			subplot(3,1,2); plot(y2); title(['Order=', int2str(i)]);
%			subplot(3,1,3); plot(au.signal-y2); title('Difference');
%		end

%	Category: Audio signal processing
%	Roger Jang, 20041223, 20070417

if nargin<1, selfdemo; return; end
if nargin<2, polyOrder=2; end

[m, n]=size(frameMat);
if m==1, error('The given frameSize=1!'); end

[frameSize, frameNum]=size(frameMat);
x=(1:frameSize)';
x2=(x-mean(x))/std(x);	% To avoid singular warning!
for i=1:frameNum
	frameMat(:,i)=frameMat(:,i)-polyval(polyfit(x2, frameMat(:,i), polyOrder), x2);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
