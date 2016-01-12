function [param, distortion]=oneCircleFit(circleData, opt, showPlot)
%oneCircleFit: Fit a circle via generalized least-squares method
%
%	Usage:
%		[param, distortion]=oneCircleFit(circleData, showPlot)
%
%	Example:
%		n=100;
%		t=rand(n,1)*2*pi;
%		x=3+10*cos(t)+randn(n,1);
%		y=7+10*sin(t)+randn(n,1);
%		data=[x, y]';
%		opt=oneCircleFit('defaultOpt');
%		param=oneCircleFit(data, opt, 1);
%
%	See also circleFit.

%	Category: Data fitting
%	Roger Jang, 20150626

if nargin<1, selfdemo; return; end
if ischar(circleData) && strcmpi(circleData, 'defaultOpt')
	param.method='lse';	% Least-squares estimate
	param.circleNum=1;
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

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
		tic
		param=fminsearch(@oneCircleFitError, param0, [], circleData);
	%	fprintf('Computation time = %g\n', toc);
	otherwise
		error('Unknown method=%s\n', opt.method);
end
% ====== Compute distortion
distortion=oneCircleFitError(param, circleData);

if showPlot
	t=linspace(0, 2*pi);
	x1=param0(1)+param0(3)*cos(t);
	y1=param0(2)+param0(3)*sin(t);
	plot(x, y, '.', x1, y1, 'k-');
	legend('Sample data', 'Circle by LSE');
	axis image
	if ~isequal(param0, param)
		x2=param(1)+param(3)*cos(t);
		y2=param(2)+param(3)*sin(t);
		hold on; plot(x2, y2, 'm-'); hold off
		legend('Sample data', 'Circle by LSE', 'Circle by LSE+fminsearch');
	end
end

% ====== Objective function used in fminsearch
function distortion=oneCircleFitError(theta, data)
a=theta(1); b=theta(2); r=theta(3);
x=data(1,:)';
y=data(2,:)';
n=length(x);
difference=sqrt((x-a).^2+(y-b).^2)-r;
%distortion=sqrt(sum(temp.^2)/n);
distortion=sum(abs(difference))/n;

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);