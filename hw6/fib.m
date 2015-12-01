function [ output ] = fib(index)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if index == 1
        output = 1;
        return
    elseif index == 2,
        output = 2;
        return
    else
        output = fib(index - 1) + fib(index - 2);
        return
    end
end

