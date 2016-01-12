%% frameZeroMean
% Make a frame zero mean by using polyfit
%% Syntax
% * 		frameMat = frameZeroMean(frameMat, polyOrder);
%% Description
%
% <html>
% <p>frameZeroMean(frameMat, polyOrder) returns the frame matrix after mean subtraction
% 	<ul>
% 	<li>frameMat: a column vector of a frame, or a matrix where each column is a frame
% 	<li>polyOrder: order of polyfit (0 for DC, 1 for line, 2 for quadratic, etc)
% 	</ul>
% <p>This function is usually used before computing volume, hod, etc.
% </html>
%% Example
%%
%
waveFile='star_noisy.wav';
au=myAudioRead(waveFile);
epdPrm=epdPrmSet(au.fs);
for i=0:3
	figure;
	subplot(3,1,1); plot(au.signal); title('Original');
	frameMat=buffer2(au.signal, epdPrm.frameSize, epdPrm.overlap);
	frameMat=frameZeroMean(frameMat, i);
	y2=frameMat(:);
	subplot(3,1,2); plot(y2); title(['Order=', int2str(i)]);
	subplot(3,1,3); plot(au.signal-y2); title('Difference');
end
