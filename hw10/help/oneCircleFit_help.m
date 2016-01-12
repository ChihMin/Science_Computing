%% oneCircleFit
% Fit a circle via generalized least-squares method
%% Syntax
% * 		[param, distortion]=oneCircleFit(circleData, showPlot)
%% Description
%
% <html>
% </html>
%% Example
%%
%
n=100;
t=rand(n,1)*2*pi;
x=3+10*cos(t)+randn(n,1);
y=7+10*sin(t)+randn(n,1);
data=[x, y]';
opt=oneCircleFit('defaultOpt');
param=oneCircleFit(data, opt, 1);
%% See Also
% <circleFit_help.html circleFit>.
