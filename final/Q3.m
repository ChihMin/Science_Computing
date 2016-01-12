%% (a)

x = linspace(-pi, pi);
y = linspace(-pi, pi);
f = sin(x) ./ x
stem3(x, y, f)

%% (b)
x = linspace(-4 * pi, 4 * pi);
y = linspace(-4 * pi, 4 * pi);
z = abs(sin(x) ./ x);
stem3(x, y, z)

%% (c)
theta = -pi:0.05:pi;
x = sin(theta);
y = cos(theta);
z = abs(cos(3*theta)).*exp(-abs(theta * 1.2 )) * 4 + 1 ;
stem3(x, y, z);

%% 
clear;
img = imread('58.jpg');
img = im2double(img);
[h, w, color] = size(img)
B(1:color, w*h + 1) = 0;
for i = 1:color,
    for j = 1:w,
        for k = 1:h,
            B(i, (j-1) * h + k) = img(k, j, i);
        end
    end
end

B(:, 1:10)

YUV(1, :) = 0.299 * B(1,:) + 0.587 * B(2,:) + 0.114 * B(3,:);
YUV(2, :) = -0.147 * B(1,:) - 0.289 * B(2,:) + 0.436 * B(3,:);
YUV(3, :) = 0.615 * B(1,:) - 0.515 * B(2,:) - 0.1 * B(3,:);


for j = 1:w,
    for k = 1:h,  
        Y(k, j) = B(1, (j-1) * h + k);
        U(k, j) = B(2, (j-1) * h + k);
        V(k, j) = B(3, (j-1) * h + k);
    end
end
imshow([Y, U, V]);