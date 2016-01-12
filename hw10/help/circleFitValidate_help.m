%% circleFitValidate
% Validate (determine) the number of circles for fitting in a 2D dataset
%% Syntax
% * 		param=circleFitValidate(data, opt, showPlot)
%% Description
%
% <html>
% <p>param=circleFitValidate(data, opt) returns the best parameters for the selected number of circles via cluster validation
% 	<ul>
% 	<li>data: 2D data for fitting circles
% 	<li>opt: Options for validating no. of circles
% 		<ul>
% 		<li>opt.circleNumMax: Max no. of circles
% 		<li>opt.trialNum: No. of trials for circleFit
% 		<li>opt.errorReductionTh: Error reduction threshold to determine the no. of circles
% 		<li>opt.interactiveDisplay: 1 for interactive display
% 		<li>opt.circleFitOpt: options for circleFitOpt
% 		</ul>
% 	</ul>
% <p>param: The best parameters for the selected number of circles, where each column is the parameters for a circle
% </html>
%% Example
%%
%
im=imread('circleEdge02.png');
[yEdge, xEdge]=find(im);		% x and y coordinates of edge
data=[xEdge'; yEdge'];
opt=circleFitValidate('defaultOpt');
opt.circleNumMax=2;
param=circleFitValidate(data, opt, 1);
%% See Also
% <circleFit_help.html circleFit>,
% <oneCircleFit_help.html oneCircleFit>.
