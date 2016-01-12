%% Q1

x = magic(10);
x = x(1,1:10);
A = magic(5)


x(3) = x(3) * 5  % 5 times element 3 of x 
A(:,2:2:4) = [] % delete column 2 & 4
A = magic(5);

A([1 3],:) = A([3 1],:) % swap row 1 & 3
A = magic(5);

B = A(:, [4 2 5]) % get column 4 2 5 to matrix B

%% Q2

for i = 1:10,
    fib(i)
end
