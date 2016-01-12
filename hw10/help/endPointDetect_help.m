%% endPointDetect
% EPD based on volume and HOD (high-order difference)
%% Syntax
% * 		[epInSampleIndex, epInFrameIndex, soundSegment, zeroOneVec, others] = endPointDetect(au, opt, showPlot)
%% Description
%
% <html>
% <p>[epInSampleIndex, epInFrameIndex, soundSegment, zeroOneVec, others] = endPointDetect(au, opt, showPlot)
% 	<ul>
% 	<li>epInSampleIndex: two-element end-points in sample index
% 	<li>epInFrameIndex: two-element end-points in frame index
% 	<li>soundSegment: segment of voice activity
% 	<li>zeroOneVec: zero-one vector for each frame
% 	<li>others: other outputs, which depends on opt.method.
% 	<li>au: audio object
% 	<li>opt: parameters for EPD
% 	<li>showPlot: 0 for silence operation, 1 for plotting
% 	</ul>
% </html>
%% Example
%%
%
waveFile='SingaporeIsAFinePlace.wav';
au=myAudioRead(waveFile);
opt=endPointDetect('defaultOpt');
opt.method='vol';
showPlot = 1;
[epInSampleIndex, epInFrameIndex, soundSegment] = endPointDetect(au, opt, showPlot);
