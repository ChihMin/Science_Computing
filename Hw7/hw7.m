%% Q1
clear;
x = linspace(-1, 1);
[l ,w] = size(x);

m = 6
y1 = cos(1*acos(x));
y2 =  cos(2*acos(x));
y3 =  cos(3*acos(x));
y4 =  cos(4*acos(x));
y5 =  cos(5*acos(x));
y6 =  cos(6*acos(x));
plot(x ,y1, 'r--o', x, y2, 'b--o', x, y3, 'g--o', x, y4, 'k--o',x, y5, 'y--o', x, y6, 'm--o' );

%% Q2
x = linspace(-10*pi+pi, 10*pi);
y = linspace(-10*pi, 10*pi);
t = linspace(0, 10*pi, 10000);
plot(-t.*sin(t), -t.*cos(t));

%% Q3
clear;
ball(10, 12, 2);



