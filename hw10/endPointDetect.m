function [epInSampleIndex, epInFrameIndex, soundSegment, zeroOneVec, others] = endPointDetect(au, opt, showPlot)
% endPointDetect: EPD based on volume and HOD (high-order difference)
%
%	Usage:
%		[epInSampleIndex, epInFrameIndex, soundSegment, zeroOneVec, others] = endPointDetect(au, opt, showPlot)
%
%	Description:
%		[epInSampleIndex, epInFrameIndex, soundSegment, zeroOneVec, others] = endPointDetect(au, opt, showPlot)
%			epInSampleIndex: two-element end-points in sample index
%			epInFrameIndex: two-element end-points in frame index
%			soundSegment: segment of voice activity
%			zeroOneVec: zero-one vector for each frame
%			others: other outputs, which depends on opt.method.
%			au: audio object
%			opt: parameters for EPD
%			showPlot: 0 for silence operation, 1 for plotting
%
%	Example:	
%		waveFile='SingaporeIsAFinePlace.wav';
%		au=myAudioRead(waveFile);
%		opt=endPointDetect('defaultOpt');
%		opt.method='vol';
%		showPlot = 1;
%		[epInSampleIndex, epInFrameIndex, soundSegment] = endPointDetect(au, opt, showPlot);

%	Roger Jang, 20070323

if nargin<1, selfdemo; return; end
if ischar(au) && strcmpi(au, 'defaultOpt')	% Set the default options
	epInSampleIndex.method='volZcr';		% Default method
	epInSampleIndex.frameDuration=256/8000;		% Frame size (fs=16000 ===> frameSize=256)
	epInSampleIndex.overlapDuration=0;		% Frame overlap
	% The followings are mainly for method='vol'
	epInSampleIndex.volRatio=0.1;
	epInSampleIndex.vMinMaxPercentile=3;
	% For method='volzcr';
	epInSampleIndex.volRatio2=0.2;	% Not used for now   
	epInSampleIndex.zcrRatio=0.1;
	epInSampleIndex.zcrShiftGain=4;
	% For epdByEntropy
	epInSampleIndex.veRatio=0.1;
	epInSampleIndex.veMinMaxPercentile=3;
	% For method='volhod'
	epInSampleIndex.vhRatio=0.012;	% 0.11
	epInSampleIndex.diffOrder=1;
	epInSampleIndex.volWeight=0.76;
	epInSampleIndex.vhMinMaxPercentile=2.3;		% 5.0%
	epInSampleIndex.extendNum=1;				% Extend front and back
	epInSampleIndex.minSegment=0.068;			% Sound segments (in seconds) shorter than or equal to this value are removed
	epInSampleIndex.maxSilBetweenSegment=0.416;	% 
	epInSampleIndex.minLastWordDuration=0.2;		%
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

opt.frameSize=round(opt.frameDuration*au.fs);
opt.overlap=round(opt.overlapDuration*au.fs);
y=au.signal; fs=au.fs; nbits=au.nbits;
if size(y, 2)~=1, error('Wave is not mono!'); end

frameSize=opt.frameSize;
overlap=opt.overlap;
minSegment=round(opt.minSegment*fs/(frameSize-overlap));
maxSilBetweenSegment=round(opt.maxSilBetweenSegment*fs/(frameSize-overlap));
%minLastWordDuration=round(opt.minLastWordDuration*fs/(frameSize-overlap));

y=double(y);					% convert to double data type
frameMat=enframe(y, frameSize, overlap);	% frame blocking
frameMat=frameZeroMean(frameMat, 2);		% zero justification
frameNum=size(frameMat, 2);					% no. of frames
switch(lower(opt.method))
	case 'vol'
		volume=frame2volume(frameMat);				% compute volume
		temp=sort(volume);
		index=round(frameNum*opt.vMinMaxPercentile/100); if index==0, index=1; end
		volMin=temp(index);
		volMax=temp(frameNum-index+1);
		volTh=(volMax-volMin)*opt.volRatio+volMin;	% compute volume threshold
		% ====== Identify voiced part that's larger than volTh
		soundSegment=segmentFind(volume>volTh);
		% ====== Delete short sound clips
		index=[soundSegment.duration]<=minSegment;
		soundSegment(index)=[];
		% ====== Create zero-one vector
		zeroOneVec=logical(0*volume);
		for i=1:length(soundSegment)
			zeroOneVec(soundSegment(i).begin:soundSegment(i).end)=1;
		end
		if isempty(soundSegment)
			epInSampleIndex=[];
			epInFrameIndex=[];
			fprintf('Warning: No sound segment found in %s.m.\n', mfilename);
		else
			epInFrameIndex=[soundSegment(1).begin, soundSegment(end).end];
			epInSampleIndex=frame2sampleIndex(epInFrameIndex, frameSize, overlap);		% conversion from frame index to sample index
			for i=1:length(soundSegment),
				soundSegment(i).beginSample = frame2sampleIndex(soundSegment(i).begin, frameSize, overlap);
				soundSegment(i).endSample   = min(length(y), frame2sampleIndex(soundSegment(i).end, frameSize, overlap));
				soundSegment(i).beginFrame = soundSegment(i).begin;
				soundSegment(i).endFrame = soundSegment(i).end;
			end
			soundSegment=rmfield(soundSegment, 'begin');
			soundSegment=rmfield(soundSegment, 'end');
		%	soundSegment=rmfield(soundSegment, 'duration');
		end
		others.volume=volume; others.volTh=volTh;
	case 'volzcr'
		volume=frame2volume(frameMat);		% compute volume
		temp=sort(volume);
		index=round(frameNum*opt.vMinMaxPercentile/100); if index==0, index=1; end
		volMin=temp(index);
		volMax=temp(frameNum-index+1);			% To avoid unvoiced sounds
		volTh1=(volMax-volMin)*opt.volRatio+volMin;	% compute volume threshold
		volTh2=(volMax-volMin)*opt.volRatio2+volMin;	% compute volume threshold
		% ====== Identify voiced part that's larger than volTh1
		soundSegment=segmentFind(volume>volTh1);
		% ====== Compute ZCR
		[minVol, index]=min(volume);
		shiftAmount=opt.zcrShiftGain*max(abs(frameMat(:,index)));		% shiftAmount is equal to opt.zcrShiftGain times the max. abs. sample within the frame of min. volume
		%shiftAmount=max(shiftAmount, 2);
		shiftAmount=max(shiftAmount, max(frameMat(:))/100);
		zcr=frame2zcr(frameMat, 1, shiftAmount);
		zcrTh=max(zcr)*opt.zcrRatio;
		% ====== Expansion 1: Expand end points to volume level1 (lower level)
		for i=1:length(soundSegment),
			head = soundSegment(i).begin;
			while (head-1)>=1 & volume(head-1)>=volTh1,
				head=head-1;
			end
			soundSegment(i).begin = head;
			tail = soundSegment(i).end;
			while (tail+1)<=length(volume) & volume(tail+1)>=volTh1,
				tail=tail+1;
			end
			soundSegment(i).end = tail;
		end
		% ====== Expansion 2: Expand end points to include high zcr region
		for i=1:length(soundSegment),
			head = soundSegment(i).begin;
			while (head-1)>=1 & zcr(head-1)>zcrTh			% Extend at beginning
				head=head-1;
			end
			soundSegment(i).begin = head;
			tail = soundSegment(i).end;
			while (tail+1)<=length(zcr) & zcr(tail+1)>zcrTh		% Extend at ending
				tail=tail+1;
			end
			soundSegment(i).end = tail;
		end
		% ====== Delete repeated sound segments
		index = [];
		for i=1:length(soundSegment)-1,
			if soundSegment(i).begin==soundSegment(i+1).begin & soundSegment(i).end==soundSegment(i+1).end,
				index=[index, i];
			end
		end
		soundSegment(index) = [];
		% ====== Delete short sound clips
		index = [];
		for i=1:length(soundSegment)
			soundSegment(i).duration=soundSegment(i).end-soundSegment(i).begin+1;	% This is necessary since the duration is changed due to expansion
			if soundSegment(i).duration<=minSegment
				index = [index, i];
			end
		end
		soundSegment(index) = [];
		zeroOneVec=logical(0*volume);
		for i=1:length(soundSegment)
			for j=soundSegment(i).begin:soundSegment(i).end
				zeroOneVec(j)=1;
			end
		end
		if isempty(soundSegment)
			epInSampleIndex=[];
			epInFrameIndex=[];
			fprintf('Warning: No sound segment found in %s.m.\n', mfilename);
		else
			epInFrameIndex=[soundSegment(1).begin, soundSegment(end).end];
			epInSampleIndex=frame2sampleIndex(epInFrameIndex, frameSize, overlap);		% conversion from frame index to sample index
			for i=1:length(soundSegment),
				soundSegment(i).beginSample = frame2sampleIndex(soundSegment(i).begin, frameSize, overlap);
				soundSegment(i).endSample   = min(length(y), frame2sampleIndex(soundSegment(i).end, frameSize, overlap));
				soundSegment(i).beginFrame = soundSegment(i).begin;
				soundSegment(i).endFrame = soundSegment(i).end;
			end
			soundSegment=rmfield(soundSegment, 'begin');
			soundSegment=rmfield(soundSegment, 'end');
		%	soundSegment=rmfield(soundSegment, 'duration');
		end
		others.volume=volume; others.volTh1=volTh1; others.volTh2=volTh2;
	case 'volhod'
		% ====== Compute volume/hod
		volume=frame2volume(frameMat);
		hod=frame2ashod(frameMat, opt.diffOrder);
		% ====== Compute vh and its thresholds
		volume=volume/max(volume); hod=hod/max(hod);	% Normalization before mixing
		vh=volume*opt.volWeight+(1-opt.volWeight)*hod;
		temp=sort(vh);
		index=round(frameNum*opt.vhMinMaxPercentile/100); if index==0, index=1; end
		vhMin=temp(index);
		vhMax=temp(frameNum-index+1);			% To avoid unvoiced sounds
		vhTh=(vhMax-vhMin)*opt.vhRatio+vhMin;
		%fprintf('vhMin=%g, vhMax=%g, vhTh=%g\n', vhMin, vhMax, vhTh);
		opt.fs=fs;
		[epInSampleIndex, epInFrameIndex, soundSegment, zeroOneVec]=epdBySingleCurve(vh, opt);
		others.volume=volume; others.hod=hod; others.vh=vh;
	otherwise
		error(sprintf('Unknown method "%s" in pitchTracking!', ptOpt.mainFun));
end
% ====== Plotting
if showPlot
switch(lower(opt.method))
	case 'vol'
		subplot(2,1,1);
		time=(1:length(y))/fs;
		frameTime=frame2sampleIndex(1:frameNum, frameSize, overlap)/fs;
		plot(time, y);
		for i=1:length(soundSegment)
			line(frameTime(soundSegment(i).beginFrame)*[1 1], 2^nbits/2*[-1, 1], 'color', 'g');
			line(frameTime(soundSegment(i).endFrame)*[1 1], 2^nbits/2*[-1, 1], 'color', 'm');
		end
		axisLimit=[min(time) max(time) -2^nbits/2, 2^nbits/2];
		if -1<=min(y) & max(y)<=1, axisLimit=[min(time) max(time) -1, 1]; end
		axis(axisLimit);
		ylabel('Amplitude'); title(sprintf('Waveform and EP (method=%s)', opt.method));
		subplot(2,1,2);
		plot(frameTime, volume, '.-');
		if all(volume)>=0
			axis([-inf inf 0 inf]);
		else
			axis tight;
		end
		line([min(frameTime), max(frameTime)], volTh*[1 1], 'color', 'r');
		line([min(frameTime), max(frameTime)], volMin*[1 1], 'color', 'c');
		line([min(frameTime), max(frameTime)], volMax*[1 1], 'color', 'k');
		for i=1:length(soundSegment)
			line(frameTime(soundSegment(i).beginFrame)*[1 1], [0, max(volume)], 'color', 'g');
			line(frameTime(soundSegment(i).endFrame)*[1 1], [0, max(volume)], 'color', 'm');
		end
		ylabel('Volume'); title('Volume');
	case 'volzcr'
		axes1H=subplot(4,1,1);
		time=(1:length(y))/fs;
		plot(time, y);
		axisLimit=[min(time) max(time) -2^nbits/2, 2^nbits/2];
		if -1<=min(y) & max(y)<=1, axisLimit=[min(time) max(time) -1, 1]; end
		axis(axisLimit);
		ylabel('Amplitude');
		ylabel('Amplitude'); title(sprintf('Waveform and EP (method=%s)', opt.method));
		% Plot end points
		yBound=axisLimit(3:4);
		for i=1:length(soundSegment),
			line(frame2sampleIndex(soundSegment(i).beginFrame, frameSize, overlap)/fs*[1,1], yBound, 'color', 'g');
			line(frame2sampleIndex(  soundSegment(i).endFrame, frameSize, overlap)/fs*[1,1], yBound, 'color', 'm');
		end
		axes2H=subplot(4,1,2);
		frameTime = frame2sampleIndex(1:frameNum, frameSize, overlap)/fs;
		plot(frameTime, volume, '.-');
		line([min(frameTime), max(frameTime)], volTh1*[1 1], 'color', 'r');
		line([min(frameTime), max(frameTime)], volTh2*[1 1], 'color', 'r');
		axis tight
		ylabel('Volume'); title('Volume');
		% Plot end points
		yBound = [min(volume) max(volume)];
		for i=1:length(soundSegment),
			line(frame2sampleIndex(soundSegment(i).beginFrame, frameSize, overlap)/fs*[1,1], yBound, 'color', 'g');
			line(frame2sampleIndex(  soundSegment(i).endFrame, frameSize, overlap)/fs*[1,1], yBound, 'color', 'm');
		end
		axes3H=subplot(4,1,3);
		plot(frameTime, zcr, '.-');
		line([min(frameTime), max(frameTime)], zcrTh*[1 1], 'color', 'c');
	%	set(gca, 'xlim', [min(frameTime), max(frameTime)]);
		axis([min(frameTime), max(frameTime), 0, inf]);
		ylabel('ZCR'); title('Zero crossing rate');
		% Plot end points
		yBound = [0 max(zcr)];
		for i=1:length(soundSegment),
			line(frame2sampleIndex(soundSegment(i).beginFrame, frameSize, overlap)/fs*[1,1], yBound, 'color', 'g');
			line(frame2sampleIndex(  soundSegment(i).endFrame, frameSize, overlap)/fs*[1,1], yBound, 'color', 'm');
		end
		axes4H=subplot(4,1,4);
		voicedIndex=epInSampleIndex(1):epInSampleIndex(2);
		voicedTime=time(voicedIndex);
		voicedY=y(voicedIndex);
		voicedH=plot(voicedTime, voicedY);
		axis([time(epInSampleIndex(1)), time(epInSampleIndex(2)), -1, 1]);
		ylabel('Amplitude'); title('Waveform after EPD');
		% === The following 3 lines are for endPointLabel.m
		U.axes1H=axes1H; U.axes2H=axes2H; U.axes3H=axes3H; U.axes4H=axes4H;
		U.voicedIndex=voicedIndex; U.voicedH=voicedH;
		U.voicedY=voicedY; U.voicedTime=voicedTime;
	case 'volhod'
		subplot(3,1,1);
		time=(1:length(y))/fs;
		frameTime=frame2sampleIndex(1:frameNum, frameSize, overlap)/fs;
		plot(time, y);
		for i=1:length(soundSegment)
			line(frameTime(soundSegment(i).beginFrame)*[1 1], 2^nbits/2*[-1, 1], 'color', 'g');
			line(frameTime(soundSegment(i).endFrame)*[1 1], 2^nbits/2*[-1, 1], 'color', 'm');
		end
		axisLimit=[min(time) max(time) -2^nbits/2, 2^nbits/2];
		if -1<=min(y) & max(y)<=1, axisLimit=[min(time) max(time) -1, 1]; end
		axis(axisLimit);
		ylabel('Amplitude'); title(sprintf('Waveform and EP (method=%s)', opt.method));
		subplot(3,1,2);
		plot(frameTime, volume, '.-', frameTime, hod, '.-'); axis tight;
		ylabel('Volume & HOD'); title('Volume & HOD'); legend('Volume', 'HOD');
		subplot(3,1,3);
		plot(frameTime, vh, '.-'); axis tight;
		line([min(frameTime), max(frameTime)], vhTh*[1 1], 'color', 'r');
		line([min(frameTime), max(frameTime)], vhMin*[1 1], 'color', 'c');
		line([min(frameTime), max(frameTime)], vhMax*[1 1], 'color', 'k');
		for i=1:length(soundSegment)
			line(frameTime(soundSegment(i).beginFrame)*[1 1], [0, max(vh)], 'color', 'g');
			line(frameTime(soundSegment(i).endFrame)*[1 1], [0, max(vh)], 'color', 'm');
		end
		ylabel('VH'); title('VH');
	otherwise
		error(sprintf('Unknown method "%s" in pitchTracking!', ptOpt.mainFun));
end
end

if showPlot
	U.y=double(y); U.fs=fs;
	if max(U.y)>1, U.y=U.y/(2^nbits/2); end
	if ~isempty(epInSampleIndex)
		U.voicedY=U.y(epInSampleIndex(1):epInSampleIndex(end));
	else
		U.voicedY=[];
	end
	set(gcf, 'userData', U);
	uicontrol('string', 'Play all', 'callback', 'U=get(gcf, ''userData''); sound(U.y, U.fs);');
	uicontrol('string', 'Play detected', 'callback', 'U=get(gcf, ''userData''); sound(U.voicedY, U.fs);', 'position', [100, 20, 100, 20]);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
