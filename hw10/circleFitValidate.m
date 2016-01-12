function [param, distortion, errorMat]=circleFitValidate(data, opt, showPlot)
% circleFitValidate: Validate (determine) the number of circles for fitting in a 2D dataset
%
%	Usage:
%		param=circleFitValidate(data, opt, showPlot)
%
%	Description:
%		param=circleFitValidate(data, opt) returns the best parameters for the selected number of circles via cluster validation
%			data: 2D data for fitting circles
%			opt: Options for validating no. of circles
%				opt.circleNumMax: Max no. of circles
%				opt.trialNum: No. of trials for circleFit
%				opt.errorReductionTh: Error reduction threshold to determine the no. of circles
%				opt.interactiveDisplay: 1 for interactive display		
%				opt.circleFitOpt: options for circleFitOpt
%		param: The best parameters for the selected number of circles, where each column is the parameters for a circle
%
%	Example:
%		im=imread('circleEdge02.png');
%		[yEdge, xEdge]=find(im);		% x and y coordinates of edge
%		data=[xEdge'; yEdge'];
%		opt=circleFitValidate('defaultOpt');
%		opt.circleNumMax=2;
%		param=circleFitValidate(data, opt, 1);
%
%	See also circleFit, oneCircleFit.

%	Category: Object detection
%	Roger Jang, 20150703

if nargin<1, selfdemo; return; end
if ischar(data) && strcmpi(data, 'defaultOpt')
	param.circleNumMax=5;	% Max no. of circles
	param.trialNum=8;		% No. of trials for circleFit
	param.errorReductionTh=6;	% Error reduction threshold to determine the no. of circles
	param.interactiveDisplay=0;
	param.circleFitOpt=circleFit('defaultOpt');
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

opt.circleFitOpt.interactiveDisplay=opt.interactiveDisplay;
errorMat=zeros(opt.circleNumMax, opt.trialNum);
circleNumSet=struct([]);
for i=1:opt.circleNumMax
	fprintf('%d/%d\n', i, opt.circleNumMax);
	opt.circleFitOpt.circleNum=i;
	trialSet=struct([]);
	for j=1:opt.trialNum
		[trialSet(j).param, assignment, theDistort]=circleFit(data, opt.circleFitOpt, showPlot);
		errorMat(i,j)=min(theDistort);
	end
	[~, minId]=min(errorMat(i,:));
	circleNumSet(i).param=trialSet(minId).param;	% Keep the best-parameters
end
distortion=min(errorMat, [], 2);
index=find(-diff(distortion)>opt.errorReductionTh);
if isempty(index)
	num=1;
else
	num=index(end)+1;
end
param=circleNumSet(num).param;	% Best parameters

if showPlot
	subplot(311); bar(errorMat); xlabel('No. of circles'); title('Distortion for each trial');
	subplot(312); plot(distortion, 'o-'); xlabel('No. of circles'); title('Distortion');
	line(num, distortion(num), 'marker', 'square', 'color', 'r');
	subplot(313); plot(-diff(distortion), 'o-'); title('Diff in distortion');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);