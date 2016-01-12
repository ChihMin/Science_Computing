function [squaredError] = errorMeasure1(theta, data)
    x = data(:,1);
    y = data(:,2);
    
    x = x .^ 2;
 
    y2 = theta(1) * (x) + theta(2);
    %[ylength, ~] = size(y2);
    %{
    for i = 1:ylength,
        if y2(i) < 0,
            y2(i) = y2(i) * -1;
        end
    end
    %}
    y2 = y2 .^ (1/2);
    squaredError = sum((y-y2).^2);
end

