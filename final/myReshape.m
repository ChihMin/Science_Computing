function [ B ] = myReshape( A )
    [h, w, color] = size(A)
    B(1:color, w*h + 1) = 0;
    for i = 1:color,
        for j = 1:w,
            for k = 1:h,
                B(i, (j-1) * h + k) = A(k, j, i);
            end
        end
    end
end

