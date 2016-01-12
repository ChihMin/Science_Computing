function [squaredError] = errorMeasure(theta, data)
    x = data(:,1);
    y = data(:,2);
    squaredError = sum((theta(1)-x).^2 + (theta(2)-y).^2);
end

