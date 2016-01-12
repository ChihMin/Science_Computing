%% template
% Detect a single bead and return it's bounding circle
%% Syntax
% * 		prm=beadDetect(im, opt, showPlot)
%% Description
%
% <html>
% <p>prm=beadDetect(im, opt, showPlot) return the bounding circle of a bead in an image
% 	<ul>
% 	<li>im: input image
% 	<li>opt: options for this function
% 	<li>showPlot: 1 to show a plot; 0 for nothing
% 	<li>prm: parameters of the bounding circle, where
% 		<ul>
% 		<li>[prm(1), prm(2)] is the center coordinates
% 		<li>prm(3) is the radius.
% 		</ul>
% 	</ul>
% </html>
%% Example
%%
%
imFile='particle01.png';
im=imread(imFile);
opt=beadDetect('defaultOpt');
prm=beadDetect(im, opt, 1);
