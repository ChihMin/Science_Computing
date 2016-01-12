function [param, assignment, distortion] = circleFit(data, opt, showPlot)
% circleFit: Fitting a fixed number of circles in 2D via k-means-like clustering
%
%	Usage:
%		[param, assignment, distortion] = circleFit(data, opt, showPlot)
%
%	Description:
%		param = circleFit(data, opt, showPlot) returns the parameters of circles after k-means-like clustering, where
%			data (2 x dataNum): dataset in 2D to be clustered; where each column is a sample point
%			opt.circleNum: number of circles to be identified
%			showPlot: 1 for animation if the dimension is 2
%			param (3 x circleNum): final parameters of identified circles,
%			where each column is the parameters for a circle, with the first two element as coordinates for center and the last element as radius
%		[center, assignment, distortion] = circleFit(...) also returns assignment of data, where
%			assignment: final assignment matrix, with assignment(i,j)=1 if data instance i belongs to circle j
%			distortion: values of the objective function (mean of absolute error) during iterations
%
%	Example:
%		% === Example 1: Fitting 1 circle
%		n=100;
%		t=rand(n,1)*2*pi;
%		x=3+10*cos(t)+randn(n,1);
%		y=7+10*sin(t)+randn(n,1);
%		data=[x, y]';
%		opt=circleFit('defaultOpt');
%		opt.circleNum=1;
%		figure; param=circleFit(data, opt, 1);
%		% === Example 2: Fitting 2 circels of scattered data
%		n=100;
%		t=rand(n,1)*2*pi;
%		x=3+10*cos(t)+0.2*randn(n,1);
%		y=7+10*sin(t)+0.2*randn(n,1);
%		data1=[x, y]';
%		x=9+8*cos(t)+0.2*randn(n,1);
%		y=3+8*sin(t)+0.2*randn(n,1);
%		data2=[x, y]';
%		data=[data1, data2];
%		opt=circleFit('defaultOpt');
%		figure; param=circleFit(data, opt, 1);
%		% === Example 3: Fitting 2 circles of image data
%		im=imread('circleEdge02.png');
%		[yEdge, xEdge]=find(im);		% x and y coordinates of edge
%		data=double([xEdge'; yEdge']);
%		opt=circleFit('defaultOpt');
%		figure; param=circleFit(data, opt, 1);
%
%	See also vecQuantize, vqDataPlot.

%	Category: Object detection
%	Roger Jang, 20150703

if nargin<1, selfdemo; return; end
if ischar(data) && strcmpi(data, 'defaultOpt')
	param.circleNum=2;
	param.interactiveDisplay=0;
	param.method='lse';	% 'lse' (for least-squares estimate) or 'lse+fminsearch'
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

circleNum=opt.circleNum;
[dim, dataNum]=size(data);
if dim~=2, error('The dimensionality of data must be 2'); end

% ====== Initial parameters
[param, distortion]=oneCircleFit(data, opt);	% Initial parameters
assignment=ones(dataNum, circleNum);
if showPlot
	resultPlot(data, param, assignment);
	if opt.interactiveDisplay
		fprintf('\tPress any key to continue...'); pause; fprintf('\n');
	end
end
if circleNum==1, return; end		% A single circle

% ====== Random the initial parameters
maxRange=max(max(data')-min(data'));
param=repmat(param, 1, circleNum);
for i=1:circleNum
	param(1:2, i)=param(1:2, i)+maxRange/20*randn(2,1);
end

maxIterCount = 200;				% Max. iteration
distortion = zeros(maxIterCount, 1);		% Array for objective function
% ====== Main loop
for i = 1:maxIterCount,
	[param2, distortion(i), assignment] = vqUpdateCenter(param, data, opt);
	if showPlot, fprintf('Iteration count = %d/%d, distortion = %f\n', i, maxIterCount, distortion(i)); end
	if showPlot
		clf; resultPlot(data, param, assignment); drawnow
		if opt.interactiveDisplay
			fprintf('\tPress any key to continue...'); pause; fprintf('\n');
		end
	end
%	keyboard
	param=param2;
	% check termination condition
	if (i>1) & (abs(distortion(i-1)-distortion(i))<eps), break; end
end
loopCount = i;	% Actual number of iterations 
distortion(loopCount+1:maxIterCount) = [];
%if showPlot & dim==2, figure; vqDataPlot(data, center, assignment); end

if showPlot, resultPlot(data, param, assignment); end

% ========== subfunctions ==========
% ====== Fit a single circle
function [param, distortion]=oneCircleFit(circleData, opt)
x=circleData(1, :)';
y=circleData(2, :)';
n=length(x);
% Linear eq: [2*x, 2*y, 1] dot [a, b, r^2-a^2-b^2] = x^2+y^2
A=[2*x, 2*y, ones(n,1)];
b=x.^2+y.^2;
theta=A\b;
a=theta(1);
b=theta(2);
r=sqrt(theta(3)+a^2+b^2);
param0=[a, b, r]';
switch opt.method
	case 'lse'
		param=param0;
	case 'lse+fminsearch'
		% ====== Further optimization using fminsearch
	%	tic
		param=fminsearch(@circleFitError, param0, [], circleData);
	%	fprintf('Computation time = %g\n', toc);
	otherwise
		error('Unknown method=%s\n', opt.method);
end
distortion=oneCircleFitError(param, circleData);

% ====== Distortion calculated as mean of abs errors
function distortion=oneCircleFitError(param, data)
%distortion=mean(abs(sqrt((data(1,:)-param(1)).^2+(data(2,:)-param(2)).^2)-param(3)));
distortion=mean(distOfData2circle(data, param));

% ====== Plot the result of clustering
function resultPlot(data, param, assignment)
circleNum=size(param,2);
t=linspace(0, 2*pi);
for i=1:circleNum
	theData=data(:, logical(assignment(:,i)));
	line(theData(1,:), theData(2,:), 'color', getColorLight(i), 'marker', '.', 'markersize', 10, 'linestyle', 'none');
	x1=param(1,i)+param(3,i)*cos(t);
	y1=param(2,i)+param(3,i)*sin(t);
	line(x1, y1, 'color', getColor(i), 'linewidth', 1);
end
axis image; box on

% ====== Update centers
function [param2, distortion, assignment]=vqUpdateCenter(param, data, opt)
[dim, dataNum]=size(data);
circleNum=size(param, 2);
% ====== Compute distance matrix
distMat=distOfData2circle(data, param);
% ====== Find the U (partition matrix)
[minDist, rowMinIndex] = min(distMat, [], 2);
assignment=logical(zeros(size(distMat)));
assignment((rowMinIndex-1)*dataNum+(1:dataNum)') = 1;
distortion = mean(minDist);	% objective function
% ====== Find new parameters
param2=zeros(3, circleNum);
for i=1:circleNum
	param2(:,i)=oneCircleFit(data(:, assignment(:,i)), opt);
end

% ====== Compute the distance of all sample data to all circles
function distMat=distOfData2circle(data, param)
dataNum=size(data,2);
circleNum=size(param, 2);
distMat=zeros(dataNum, circleNum);
x=data(1,:)';
y=data(2,:)';
for i=1:circleNum
	distMat(:,i)=abs(sqrt((x-param(1,i)).^2+(y-param(2,i)).^2)-param(3,i));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
