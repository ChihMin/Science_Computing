%% circleFit
% Fitting a fixed number of circles in 2D via k-means-like clustering
%% Syntax
% * 		[param, assignment, distortion] = circleFit(data, opt, showPlot)
%% Description
%
% <html>
% <p>param = circleFit(data, opt, showPlot) returns the parameters of circles after k-means-like clustering, where
% 	<ul>
% 	<li>data (2 x dataNum): dataset in 2D to be clustered; where each column is a sample point
% 	<li>opt.circleNum: number of circles to be identified
% 	<li>showPlot: 1 for animation if the dimension is 2
% 	<li>param (3 x circleNum): final parameters of identified circles,
% 	<li>where each column is the parameters for a circle, with the first two element as coordinates for center and the last element as radius
% 	</ul>
% <p>[center, assignment, distortion] = circleFit(...) also returns assignment of data, where
% 	<ul>
% 	<li>assignment: final assignment matrix, with assignment(i,j)=1 if data instance i belongs to circle j
% 	<li>distortion: values of the objective function (mean of absolute error) during iterations
% 	</ul>
% </html>
%% Example
%%
% Example 1: Fitting 1 circle
n=100;
t=rand(n,1)*2*pi;
x=3+10*cos(t)+randn(n,1);
y=7+10*sin(t)+randn(n,1);
data=[x, y]';
opt=circleFit('defaultOpt');
opt.circleNum=1;
figure; param=circleFit(data, opt, 1);
%%
% Example 2: Fitting 2 circels of scattered data
n=100;
t=rand(n,1)*2*pi;
x=3+10*cos(t)+0.2*randn(n,1);
y=7+10*sin(t)+0.2*randn(n,1);
data1=[x, y]';
x=9+8*cos(t)+0.2*randn(n,1);
y=3+8*sin(t)+0.2*randn(n,1);
data2=[x, y]';
data=[data1, data2];
opt=circleFit('defaultOpt');
figure; param=circleFit(data, opt, 1);
%%
% Example 3: Fitting 2 circles of image data
im=imread('circleEdge02.png');
[yEdge, xEdge]=find(im);		% x and y coordinates of edge
data=double([xEdge'; yEdge']);
opt=circleFit('defaultOpt');
figure; param=circleFit(data, opt, 1);
%% See Also
% <vecQuantize_help.html vecQuantize>,
% <vqDataPlot_help.html vqDataPlot>.
