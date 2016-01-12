function [x, y, z] = ball(a, b, c)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

t = linspace(-pi/2 , pi/2, 200);
u = linspace(-pi, pi, 200);

[tt, uu] = meshgrid(t, u);

x = a .* cos(tt) .* cos(uu);
y = b .* cos(tt) .* sin(uu);
z = c .* sin(tt);

mesh(x, y, z);

end

