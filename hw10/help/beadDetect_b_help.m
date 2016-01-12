%% beadDetect_b
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
% 		<li>[prm(1), prm(2)]: center coordinates
% 		<li>prm(3): radius of the fitting circle
% 		<li>prm(4): intensity average of the object
% 		<li>prm(5): no. of pixels of the object
% 		</ul>
% 	</ul>
% </html>
%% Example
%%
%
imFile='particles02.png';
im=imread(imFile);
opt=beadDetect('defaultOpt');
prm=beadDetect(im, opt, 1);
