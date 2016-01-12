function [scaledVec, scaledVecLen]=vecLinScaling(vec, lowerRatio, upperRatio, resolution, plotOpt)
% vecLinScaling: Create linear scaling versions of a given vector
%	Usage:
%		[scaledVec, scaledVecLen]=vecLinScaling(vec, lowerRatio, upperRatio, resolution, plotOpt)
%
%	Example:
%		pitch=[48.044247 48.917323 49.836778 50.154445 50.478049 50.807818 51.143991 51.486821 51.486821 51.486821 51.143991 50.154445 50.154445 50.154445 49.218415 51.143991 51.143991 50.807818 49.524836 49.524836 49.524836 49.524836 51.143991 51.143991 51.143991 51.486821 51.836577 50.807818 51.143991 52.558029 51.486821 51.486821 51.486821 51.143991 51.143991 51.143991 51.143991 51.143991 51.143991 51.143991 51.143991 51.143991 49.218415 50.807818 50.807818 50.154445 50.478049 48.044247 49.524836 52.193545 51.486821 51.486821 51.143991 50.807818 51.486821 51.486821 51.486821 51.486821 51.486821 55.788268 55.349958 54.922471 54.922471 55.349958 55.349958 55.349958 55.349958 55.349958 55.349958 55.349958 55.349958 53.699915 58.163541 59.213095 59.762739 59.762739 59.762739 59.762739 58.163541 57.661699 58.163541 58.680365 58.680365 58.680365 58.163541 55.788268 54.505286 55.349958 55.788268 55.788268 55.788268 54.922471 54.505286 56.237965 55.349958 55.349958 55.349958 55.349958 54.505286 54.505286 55.349958 48.917323 50.478049 50.807818 51.143991 51.143991 51.143991 50.807818 50.807818 50.478049 50.807818 51.486821 51.486821 51.486821 51.486821 51.486821 51.486821 52.558029 52.558029 52.558029 52.558029 52.193545 51.836577 52.193545 53.310858 53.310858 53.310858 52.930351 52.930351 53.310858 52.930351 52.558029 52.193545 52.930351 53.310858 52.930351 51.836577 52.558029 53.699915 52.930351 52.930351 52.558029 52.930351 52.930351 52.558029 52.558029 52.558029 53.310858 53.310858 53.310858 53.310858 52.930351 52.930351 52.930351 52.558029 52.930351 52.930351 52.930351 52.930351 52.930351 52.930351 52.930351 53.310858 53.310858 53.310858 52.193545 52.193545 52.193545 54.097918 52.930351 52.930351 52.930351 52.930351 52.930351 51.143991 51.143991 51.143991 48.917323 49.524836 49.524836 49.836778 49.524836 48.917323 49.524836 49.218415 48.330408 48.330408 48.330408 48.330408 48.330408 49.524836 49.836778 53.310858 53.310858 53.310858 52.930351 52.930351 52.930351 53.310858 52.930351 52.930351 52.558029 52.558029 51.143991 52.930351 49.218415 49.836778 50.154445 49.836778 49.524836 48.621378 48.621378 48.621378 49.836778 49.836778 49.836778 49.836778 46.680365 46.680365 46.680365 46.163541 45.661699 45.661699 45.910801 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 50.807818 51.486821 51.486821 51.143991];
%		lowerRatio=0.5;
%		upperRatio=1.5;
%		resolution=21;
%		plotOpt=1;
%		[scaledVec, scaledVecLen]=vecLinScaling(pitch, lowerRatio, upperRatio, resolution, plotOpt);		

%	Roger Jang, 20090926

if nargin<1, selfdemo; return; end
if nargin<2, lowerRatio=0.5; end
if nargin<3, upperRatio=1.5; end
if nargin<4, resolution=21; end
if nargin<5, plotOpt=0; end

vecLen=length(vec);
scaleFactor=linspace(lowerRatio, upperRatio, resolution);
maxVecLen=fix(vecLen*upperRatio);

scaledVec=nan*ones(maxVecLen, resolution);
scaledVecLen=zeros(1, resolution);
for i=1:resolution
	scaledVecLen(i)=fix(vecLen*scaleFactor(i));
	scaledVec(1:scaledVecLen(i), i)=interp1(1:vecLen, vec, linspace(1, vecLen, scaledVecLen(i))');
end

if plotOpt
	mesh(scaledVec); axis ij
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
