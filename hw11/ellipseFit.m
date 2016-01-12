function [SSE, output] = ellipseFit(data, showPlot)
 
    x = data(:, 1);
    y = data(:, 2);
    plot(x, y, 'ro');
    [length, ha] = size(x);
    
    center = [0 0];
    center = fminsearch(@errorMeasure, center, [], [x,y]); 
    
    % cx = center(1)
    % cy = center(2)
    
    cx =  4.9328 ;
    cy = 2.2014; 
    
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
    
    % thetaX = 0;
    % thetaY = 0;
    
    % theta = [xlength / 2, ylength / 2 ];
    theta = [thetaX, thetaY]
    tic
    
    theta = fminsearch(@errorMeasure1, theta, [], [x,y]); 
    
    fprintf('running time = %g\n', toc);


    rx = -theta(2) / theta(1); 
    ry = theta(2);

    if rx < 0, rx = rx * -1, end
    if ry < 0, ry = ry * -1, end

    rx = rx .^ (1/2);
    ry = ry .^ (1/2);

    samplePts = 0:0.01:2*pi;
    xx = rx * cos(samplePts) + cx;
    yy = ry * sin(samplePts) + cy;

    %maxxx = max(xx)
    %maxyy = max(yy)
    
    % SSE = errorMeasure1(theta, [x,y]);
    SSE = sum((((x + xmin).^2)./(rx^2) + ((y+ymin).^2)./(ry^2) - 1).^2)
    radius = [rx, ry];
    output = [cx, cy, rx, ry];
    
    hold on;
    plot(xx, yy, 'b-');
    hold off;

    legend('Sample data', 'Regression curve');
    fprintf('total squared error = %d\n', SSE);
end