function [ds2, fileRr, frameRr]=perfLoo4audio(ds, opt, showPlot)
%strCentroid: Leave-one-file-out CV (for audio)
%
%	Usage:
%		ds2=perfLoo4audio(ds, opt, showPlot)
%
%	Description:
%		perfLoo4audio(ds, opt, showPlot) performs leave-one-out cross validation for audio data
%
%	Example:
%		cellStr={'abcd', 'abde', 'abc', 'asdf', 'abd', 'abcd', 'abd'};
%		opt=strCentroid('defaultOpt');
%		output=strCentroid(cellStr, opt);
%		fprintf('The centroid of %s is %s.\n', cell2str(cellStr), output);
%
%	See also perfCv, perfCv4classifier, perfLoo.

%	Category: Performance evaluation
%	Roger Jang, 20150120

if nargin<1, selfdemo; return; end
if ischar(ds) && strcmpi(ds, 'defaultOpt')	% Set the default options
	ds2.classifier='gmmc';
	ds2.classifierOpt=classifierTrain(ds2.classifier, 'defaultOpt');
	ds2.fileRrMethod='logLike';	% 'logLike' or 'pFrameClass'
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

ds2=ds;
for i=1:length(ds.file)
	fprintf('%d/%d: Leave-one-file-out CV for "%s", time=', i, length(ds.file), ds.file{i});
	theTic=tic;
	% === Create dataset for training and test
	tFrameIndex=find(ds.fileId==i);		% Indices for frames to be tested
	trainDs=ds;
	trainDs.input(:, tFrameIndex)=[];
	trainDs.output(:, tFrameIndex)=[];
	testDs=ds;
	testDs.input=testDs.input(:, tFrameIndex);
	testDs.output=testDs.output(:, tFrameIndex);
	% === Train GMM
	cPrm=classifierTrain(opt.classifier, trainDs, opt.classifierOpt);
	[pClass, logLike]=classifierEval(opt.classifier, testDs, cPrm);
	ds2.frameClassIdPredicted(tFrameIndex)=pClass;	% Predicted class for each frame
	ds2.logLike(:, tFrameIndex)=logLike;
	fprintf('%g sec\n', toc(theTic));
end

% The frame-based accuracy for LOFOCV can be computed next:
frameRr=sum(ds2.frameClassIdPredicted==ds.output)/length(ds.output);

% The file-based accuracy for LOFOCV can be computed as follows:
if strcmp(opt.fileRrMethod, 'frameClassIdPredicted')
	for i=1:length(ds.file)
		index=find(ds.fileId==i);
		ds2.fileClassIdPredicted(i)=mode(ds.frameClassIdPredicted(index));
	end
	fileRr=sum(ds2.fileClassIdPredicted==ds2.fileClassId)/length(ds2.fileClassId);
%	fprintf('File-based LOFOCV (based on frame classification) = %g%%\n', accuracy*100);
elseif strcmp(opt.fileRrMethod, 'logLike')
	for i=1:length(ds.file)
		index=find(ds.fileId==i);
		logLike=sum(ds2.logLike(:, index), 2);
		[maxValue, ds2.fileClassIdPredicted(i)]=max(logLike);
	end
	fileRr=sum(ds2.fileClassIdPredicted==ds2.fileClassId)/length(ds2.fileClassId);
%	fprintf('File-based LOFOCV (based on frame likelihood) = %g%%\n', accuracy*100);
else
	error(sprintf('Unknown opt.fileRrMethod=%s\n', opt.fileRrMethod));
end

if showPlot
	confMat=confMatGet(ds.fileClassId, ds.fileClassIdPredicted);
%	confMat=confMatGet(ds.output, ds.frameClassIdPredicted);
	confOpt=confMatPlot('defaultOpt');
	confOpt.className=ds.outputName;
	confMatPlot(confMat, confOpt);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);