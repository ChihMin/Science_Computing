function [ x3 ] = sortInv(x2, index)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    x3 = x2;
    [a, b] = size(index);
    for i = 1:b,
        x3(index(i)) = x2(i);
    end
end

