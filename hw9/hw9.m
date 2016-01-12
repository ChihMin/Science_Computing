%% Q1
x=round(100*rand(1,100));
[x2, index]=sort(x);
x3=sortInv(x2, index);
z=isequal(x, x3)

%% Q2

A = imread('pitfal.png');
B = myReshape(A);

%% Q3 
clear;
f = fopen('testcase.txt');
index = 1;
summary = [];

while ~feof(f),
    str = fgets(f);
    attr = strsplit(str, ' ');
    student = cell2struct(attr, {'name', 'id', 'assignment', 'midterm', 'final'}, 2);
    
    assignment = str2double(student.assignment);
    midterm = str2double(student.midterm);
    final = strsplit(student.final, '\n');
    final = cellstr(final{1});
    final = str2double(final);
    student.final = final;
    student.sum = assignment + midterm + final;
    summary = [summary student.sum];
    students(index) = student;
    index = index + 1;
end

[ret oldIndex] = sort(summary);
[h w] = size(oldIndex);
maxGrade = max(summary);
minGrade = min(summary);
range = minGrade:maxGrade;
counter(1:maxGrade) = 0;
for i = 1:w,
    grade = summary(i);
    counter(grade) = counter(grade) + 1;
end

retCounter(1:maxGrade) = 0;
for i = minGrade:maxGrade,
    retCounter(i) = retCounter(i-1) + counter(i);
end

plot(1:maxGrade, retCounter)
T = struct2table(students)