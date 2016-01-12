function [ output ] = fib(index)
    if index == 1
        output = 1;
        return
    elseif index == 2,
        output = 1;
        return
    else
        output = fib(index - 1) + fib(index - 2);
        return
    end
end

