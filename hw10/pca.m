function [DS2, eigVec, eigValue]=pca(DS, eigVecNum)
%pca: Principal component analysis (PCA)
%
%	Usage:
%		data2=pca(data)
%		data2=pca(data, eigVecNum)
%		[data2, eigVec, eigValue]=pca(...)
%
%	Description:
%		data2=pca(data) returns the results of PCA (principal component analysis)
%			data: a data matrix, where each column is a data vector, or a dataset object
%			data2: output data matrix after projection, or output dataset object
%		data2=pca(data, eigVecNum) uses the specified no. of eigenvectors for PCA
%			eigVecNum: No. of selected eigenvectors, or the percentage of total variance explained
%		[data2, eigVec, eigValue]=pca(...) returns extra info:
%			eigVec: Each column of this matrix is a eigenvector of dataMat*dataMat', sorted by decending order of the corresponding eigenvalues
%			eigValue: Eigenvalues of (dataMat*dataMat') corresponding to eigVec
%
%	Example:
%		% === Demo for 2D data
%		dataNum=1000;
%		j=sqrt(-1);
%		data=randn(1,dataNum)+j*randn(1,dataNum)/3;
%		data=data*exp(j*pi/6);		% Rotate 30 degress
%		data=data-mean(data);		% Zero mean'ed
%		plot(real(data), imag(data), '.'); axis image;
%		data=[real(data); imag(data)];
%		[data2, v, eigValue]=pca(data);
%		v1=v(:, 1);
%		v2=v(:, 2);
%		arrow=[-1 0 nan -0.1 0 -0.1]+1+j*[0 0 nan 0.1 0 -0.1];
%		arrow1=2*arrow*(v1(1)+j*v1(2))*eigValue(1)/dataNum;
%		arrow2=2*arrow*(v2(1)+j*v2(2))*eigValue(2)/dataNum;
%		line(real(arrow1), imag(arrow1), 'color', 'r', 'linewidth', 4);
%		line(real(arrow2), imag(arrow2), 'color', 'm', 'linewidth', 4);
%		title('Axes for PCA');
%		% === Demo for the iris dataset
%		DS=prData('iris');
%		dataNum=size(DS.input, 2);
%		DS2=pca(DS);
%		figure;
%		subplot(1,2,1); dsScatterPlot(DS2); title('IRIS projected on the first 2D of LDA');
%		DS2.input=DS2.input(3:4, :);
%		subplot(1,2,2); dsScatterPlot(DS2); title('IRIS projected on the last 2D of LDA');

%	Category: Data dimension reduction
%	Roger Jang, 970406, 990612, 991215, 20060506, 20141226

if nargin<1, selfdemo; return; end
if ~isstruct(DS)
	A=DS;
else
	A=DS.input;
end
if nargin<2, eigVecNum=min(size(A)); end
if eigVecNum>min(size(A)), eigVecNum=min(size(A)); end

d=size(A,1);	% Dimension of data point
n=size(A,2);	% No. of data point

A=bsxfun(@minus, A, mean(A, 2));	% Zero justification: Subtract the mean column from A

if n>=d
	[eigVec, eigValue]=eig(A*A');
else	% This is an efficient method which computes the eigvectors of A*A' when size(A,1)>size(A,2)
	% A*A'*x=lambda*x ===> A'*A*A'*x=lambda*A'*x ===> eigVec of A'*A is A'*x, multiply these eigVec by A, we have A*A'*x=lambda*x ===> Got it!
	[eigVec, eigValue]=eig(A'*A);
end

eigValue=diag(eigValue);
[eigValue, index]=sort(eigValue, 'descend');	% Sort based on descending order

if eigVecNum<1		% A percentage instead of an integer
	cumEig=cumsum(eigValue);
	eigVecNum=sum(cumEig<sum(eigValue)*eigVecNum)+1;
end

eigVec=eigVec(:, index(1:eigVecNum));
eigValue=eigValue(1:eigVecNum);

if n<d
	eigVec=A*eigVec(:, 1:eigVecNum);		% Eigenvectors of A*A'
	eigVec=eigVec*diag(1./(sum(eigVec.^2).^0.5));	% Normalization
end

if ~isstruct(DS)
	DS2=eigVec'*A;
else
	DS2=DS;
	DS2.input=eigVec'*A;
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
