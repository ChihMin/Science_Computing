function [ data ] = load1( filename )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    f = fopen(filename);
 
    while ~feof(f),
        [x, y] = fscanf(f, '%d %d', 2)
    end
    fclose(f);
end

