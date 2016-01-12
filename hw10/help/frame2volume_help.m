%% frame2volume
% Frame or frame matrix to volume conversion
%% Syntax
% * 		volume=frame2volume(frameMat, opt)
%% Description
%
% <html>
% <p>frame2volume(frameMat, opt) returns the volume of the given frame or frame matrix
% 	<ul>
% 	<li>frameMat: a column vector of a frame, or a matrix where each column is a frame
% 	<li>opt: options for volume computation
% 		<ul>
% 		<li>opt.method: method for volume computation
% 			<ul>
% 			<li>'absSum': absolute sum
% 			<li>'squaredSum': squared sum
% 			<li>'decibel': log of squared sum
% 			</ul>
% 		<li>opt.meanCurvePolyOrder: order for polynomial fit for approximating the mean of each frame
% 		</ul>
% 	</ul>
% </html>
%% Example
%%
%
waveFile='SingaporeIsAFinePlace.wav';
[y, fs]=audioread(waveFile);
frameSize=640; overlap=480;
frameMat=buffer2(y, frameSize, overlap);
frameNum=size(frameMat, 2);
opt=frame2volume('defaultOpt');
opt1=opt; opt1.method='absSum';
volume1=frame2volume(frameMat, opt1);
opt2=opt; opt2.method='decibel';
volume2=frame2volume(frameMat, opt2);
time=(1:length(y))/fs;
frameTime=((0:frameNum-1)*(frameSize-overlap)+0.5*frameSize)/fs;
subplot(3,1,1); plot(time, y); axis tight; ylabel('Amplitude'); title(waveFile);
subplot(3,1,2); plot(frameTime, volume1, '.-'); axis tight; ylabel(opt1.method);
subplot(3,1,3); plot(frameTime, volume2, '.-'); axis tight; ylabel(opt2.method);
xlabel('Time (sec)');
