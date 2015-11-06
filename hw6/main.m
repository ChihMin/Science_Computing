%% Q1

x = magic(10);
x = x(1,1:10);
A = magic(10);


x(3) = x(3) * 5  % 5 times element 3 of x 
A(:,2:2:4) = [] % delete column 2 & 4
A([1 3],:) = A([3 1],:)
B = A(:, [4 2 5])


%% Q2

for i = 1:10,
    fib(i)
end