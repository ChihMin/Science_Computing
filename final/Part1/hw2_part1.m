clear all; close all; clc;
darkFigure();
catImage = im2double(imread('github_icon.png'));
[h, w, ~] = size(catImage);
imshow(catImage);

%% Mouse input
xlabel ('Select at most 200 points along the outline', 'FontName', '微軟正黑體', 'FontSize', 14);
[ ctrlPointX, ctrlPointY ] = ginput(200);
ctrlPointList = [ctrlPointX ctrlPointY];
clickedN = size(ctrlPointList,1);

promptStr = sprintf('%d points selected', clickedN);
xlabel (promptStr, 'FontName', '微軟正黑體', 'FontSize', 14);

%% Calculate Bㄚˇzier curve (Your efforts here)
%  Part 1(A)

outlineVertexList = ctrlPointList; %Enrich outlineVertexList
[pt_counts, ~] = size(outlineVertexList);

M = [-1 3 -3 1; 3 -6 3 0; -3 3 0 0; 1 0 0 0];
G = zeros(4, 2);
syms t;
sample = linspace(0, 1, 40);
ansList = zeros(0, 2, 'double');
[~, sample_counts] = size(sample);

pt_counts 

cur_pt = 0;
while( cur_pt < pt_counts )
    for i = 1:4,
        for j = 1:2,
            G(i, j) = ctrlPointList(mod((cur_pt + i - 1),pt_counts) + 1, j);
        end
    end
    
    for i = 1:sample_counts,
        t = sym(sample(i));
        T = [t.^3, t.^2, t.^1, 1];
        ans = (T * M) * G;
        ans = double(vpa(ans));
        ansList = [ansList; ans];
    end
    cur_pt = cur_pt + 3;
end

outlineVertexList = ansList;
ctrlPointList = ansList;

% Draw and fill the polygon
drawAndFillPolygon( catImage, ctrlPointList, outlineVertexList, true, true, true ); %ctrlPointScattered, polygonPlotted, filled

%% This is part1(b) 
    % This part is NOT Comment, this is part1(b) code
    % Part 1 (b)

    big_img = imresize(catImage, 4, 'nearest');
    imwrite(big_img, 'github_cat_4_scale.png', 'png');
    figure;

    % output 4 multiple scaling of image 

    ctrlPointList = ctrlPointList * 4;
    outlineVertexList = outlineVertexList * 4;
    drawAndFillPolygon( big_img, ctrlPointList, outlineVertexList, true, true, true ); %ctrlPointScattered, polygonPlotted, filled
