function [SSE, radius] = sseOfEllipseFit(center, data)
 
    x = data(:, 1);
    y = data(:, 2);
    plot(x, y, 'ro');
    [length, ha] = size(x);
    cx = sum(x) / length;
    cy = sum(y) / length;
    x = x - cx;
    y = y - cy;

    xmax = max(x);
    ymax = max(y);
    xmin = min(x);
    ymin = min(y);
    xlength = xmax - xmin
    ylength = ymax - ymin
    x = x - xmin;
    y = y - ymin;

    thetaX = -((ylength / 2) ^ 2) / ((xlength / 2) ^ 2);
    thetaY = ((ylength / 2) ^ 2);
    theta = [thetaX,  thetaY];
    tic
    theta = fminsearch(@errorMeasure1, theta, [], [x,y]); 

    fprintf('running time = %g\n', toc);


    rx = - theta(2) / theta(1); 
    ry = theta(2);

    if rx < 0, rx = rx * -1, end
    if ry < 0, ry = ry * -1, end

    rx = rx .^ (1/2);
    ry = ry .^ (1/2);

    samplePts = 0:0.01:2*pi;
    xx = rx * cos(samplePts) + cx;
    yy = ry * sin(samplePts) + cy;

    SSE = errorMeasure1(theta, [x,y]);
    radius = [rx, ry];
    
    hold on;
    plot(xx, yy, 'b-');
    hold off;

    legend('Sample data', 'Regression curve');
    fprintf('total squared error = %d\n', SSE);
end