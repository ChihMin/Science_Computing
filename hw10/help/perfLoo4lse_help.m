%% perfLoo4lse
% Leave-one-out cross validation for LSE (least-squares estimate)
%% Syntax
% * 		[trainMaeMean, testMaeMean, trainMae, testMae]=perfLoo4lse(A, b, plotOpt)
%% Description
%
% <html>
% </html>
%% Example
%%
%
A=rand(10, 3);
b=rand(10, 1);
plotOpt=1;
[trainMaeMean, testMaeMean, trainMae, testMae]=perfLoo4lse(A, b, plotOpt);
