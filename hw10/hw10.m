X = imread('CG.png'); 
image(X);
[m, n, p]=size(X); 
index=reshape(1:m*n*p, m*n, 3)'; 
data=double(X(index));
maxI=6;
tic;    % timer start 

before = m * n * 3 * 8;
for i=1:maxI,
    centerNum=2^i;  
    
    [center, tmp1, tmp2, tmp3]=kMeansClustering(data, centerNum, 0);   
    distMat=distPairwise(center, data); 
    [minValue, minIndex]=min(distMat); 
    X2=reshape(minIndex, m, n); 
    map=center'/255;
    figure;
    
    cRatio = 24 / ((log(centerNum)/log(2)) + (24 * centerNum / (m * n)));
    fprintf('i=%d/%d: no. of centers=%d, compress ratio = %f\n', i, maxI, centerNum, cRatio);
    
    subplot(2, 1, 1);
    image(X2); 
    colormap(map); 
    colorbar;
    axis image;
    subplot(2, 1, 2);
    plot(tmp2, 'o-');
end
toc    % Timer stop  %Elapsed time is 68.024250 seconds.  % Compression is lossy(Some colors are lose)