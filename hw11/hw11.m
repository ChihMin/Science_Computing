clear;
data = load('ellipse.txt');
[SSE, radius] = sseOfEllipseFit([1 2], data);

%%
clear;
data = load('ellipseData02.txt');
[SSE, theta] = ellipseFit(data, 1);