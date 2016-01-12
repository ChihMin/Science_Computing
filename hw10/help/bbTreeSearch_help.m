%% bbTreeSearch
% BB (branch-and-bound) tree search for 1 nearest neighbor
%% Syntax
% * 		[nnIndex, nnDist, distCompCount] = bbTreeSearch(vec, bbTree, allData)
%% Description
%
% <html>
% <p>[nnIndex, nnDist, distCompCount] = bbTreeSearch(vec, bbTree, allData) returns the 1 nearest neighbor via BB (branch-and-bound) tree search
% 	<ul>
% 	<li>vec: test input vector
% 	<li>bbTree: tree structure generated by bbTreeGen, with the following fields:
% 		<ul>
% 		<li>bbTree(i).mean: mean vector of a tree node
% 		<li>bbTree(i).radius: radius vector of a tree node
% 		<li>bbTree(i).child: indices of children for a non-terminal node
% 		<li>bbTree(i).dataIndex: indices of data for a terminal node
% 		<li>bbTree(i).dist2mean: distance to mean of a terminal node
% 		</ul>
% 	<li>allData: all sample data points
% 	<li>nnIndex: index of the nearest neighbor
% 	<li>nnDist: distance to the nearest neighbor
% 	<li>distCompCount: no. of distance computation
% 	</ul>
% </html>
%% Example
%%
%
dim=2;
dataNum=1000;
testNum=100;
data=rand(dim, dataNum);
testData=rand(dim, testNum);
clusterNum=3;
level=4;
plotOpt=1;
bbTree=bbTreeGen(data, clusterNum, level, plotOpt);
for i=1:testNum
	[nnIndex(i), nnDist(i), distCompCount(i)] = bbTreeSearch(testData(:,i), bbTree, data);
end
distMat=distPairwise(data, testData);
[minValue, minIndex]=min(distMat);
fprintf('isequal(nnIndex, minIndex)=%d\n', isequal(nnIndex, minIndex));
plot(distCompCount, '.-');
xlabel('Test case indices'); ylabel('Distance computation count');
title(sprintf('Average number of distance computation = %f\n', mean(distCompCount)));
%% See Also
% <bbTreeGen_help.html bbTreeGen>.
