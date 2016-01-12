%% houghCircle
% 
%% Syntax
% * 		[y0detect,x0detect,accumulator] = houghcircle(Imbinary,r,thresh,region)
%% Description
%
% <html>
% <p>[y0detect,x0detect,accumulator] = houghcircle(Imbinary,r,thresh,region)
% 	<ul>
% 	<li>Imbinary - a binary image. image pixels that have value equal to 1 are interested pixels for HOUGHLINE function.
% 	<li>r        - radius of circles.
% 	<li>thresh   - a threshold value that determines the minimum number of pixels that belong to a circle in image space. threshold must be bigger than or equal to 4(default).
% 	<li>region   - a rectangular region to search for circle centers within [x,y,w,h]. Must not be larger than the image area. Default is image area
% 	<li>y0detect    - row coordinates of detected circles.
% 	<li>x0detect    - column coordinates of detected circles.
% 	<li>accumulator - the accumulator array in Hough space.
% 	</ul>
% <p>Function uses Standard Hough Transform to detect circles in a binary image.
% <p>According to the Hough Transform for circles, each pixel in image space corresponds to a circle in Hough space and vise versa.
% <p>Upper left corner of image is the origin of coordinate system.
% </html>
%% Example
%%
%
im=imread('coins.png');
subplot(221); imshow(im);
imBw=edge(double(im));
subplot(222); imshow(imBw);
rad=24;
[y0, x0, accumulator]=houghCircle(imBw, rad, rad*pi);
line(x0(:), y0(:), 'marker', 'x', 'LineWidth', 2, 'Color', 'yellow');
subplot(223); imagesc(accumulator); axis image
subplot(224); mesh(accumulator);
colormap default
