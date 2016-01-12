%% objDetect
% Detect a single bead and return it's bounding circle
%% Syntax
% * 		objSet=objDetect(im, opt, showPlot)
%% Description
%
% <html>
% <p>objSet=objDetect(im, opt, showPlot) return the bounding circle of a bead in an image
% 	<ul>
% 	<li>im: input image
% 	<li>opt: options for this function
% 	<li>showPlot: 1 to show a plot; 0 for nothing
% 	<li>objSet: set of objects
% 	</ul>
% </html>
%% Example
%%
%
imFile='particles04.png';
im=imread(imFile);
opt=objDetect('defaultOpt');
objSet=objDetect(im, opt, 1);
