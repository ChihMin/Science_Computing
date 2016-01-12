function [trainMaeMean, testMaeMean, trainMae, testMae]=perfLoo4lse(A, b, plotOpt)
% perfLoo4lse: Leave-one-out cross validation for LSE (least-squares estimate)
%
%	Usage:
%		[trainMaeMean, testMaeMean, trainMae, testMae]=perfLoo4lse(A, b, plotOpt)
%
%	Example:
%		A=rand(10, 3);
%		b=rand(10, 1);
%		plotOpt=1;
%		[trainMaeMean, testMaeMean, trainMae, testMae]=perfLoo4lse(A, b, plotOpt);

%	Category: Least squares
%	Roger Jang, 20150401

if nargin<1, selfdemo; return; end
if nargin<3, plotOpt=0; end

[dataNum, feaDim]=size(A);
testMae=zeros(dataNum, 1);
trainMae=zeros(dataNum, 1);

for i=1:dataNum
	hiddenA=A(i,:);
	hiddenB=b(i,:);
	A2=A; A2(i,:)=[];
	b2=b; b2(i,:)=[];
	x=A2\b2;
	trainMae(i)=mean(abs(b2-A2*x));
	testMae(i)=abs(abs(hiddenB-hiddenA*x));
end
trainMaeMean=mean(trainMae);
testMaeMean=mean(testMae);

if plotOpt
%	plot(1:dataNum, trainMae, 1:dataNum, testMae);
	bar([trainMae, testMae]);
	legend('Training MAE', 'Test MAE');
	title(sprintf('trainMaeMean=%g, testMaeMean=%g', trainMaeMean, testMaeMean));
	xlabel('Data index'); ylabel('Mean absolute error');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);