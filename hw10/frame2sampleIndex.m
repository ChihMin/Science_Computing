function sampleIndex=frame2sampleIndex(frameIndex, frameSize, overlap)
%frame2sampleIndex: Frame index to sample index conversion
%	Usage: sampleIndex=frame2sampleIndex(frameIndex, frameSize, overlap)
%		frameIndex: frame index
%		frameSize: frame size
%		overlap: frame overlap
%		sampleIndex: the output sample index

%	Category: Audio signal processing
%	Roger Jang, 20041016

if nargin<1; selfdemo; return; end

sampleIndex=(frameIndex-1)*(frameSize-overlap)+round(frameSize/2);

% ====== Self demo
function selfdemo
frameIndex=[1 2 3];
frameSize=5;
overlap=3;
fprintf('frameIndex = %s\n', mat2str(frameIndex));
fprintf('frameSize = %d\n', frameSize);
fprintf('overlap = %d\n', overlap);
fprintf('After calling "sampleIndex=frame2sampleIndex(frameIndex, frameSize, overlap)":\n');
sampleIndex=feval(mfilename, frameIndex, frameSize, overlap);
fprintf('sampleIndex = %s\n', mat2str(sampleIndex));
