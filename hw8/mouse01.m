function mouse01(action, color)
% mouse01: Handling mouse events, based on "switchyard programming"
%   Roger Jang, 20040405
%   Cheng-Hsin Hsu, 20151120
if nargin<1, 
    fprintf('here');
    action='start'; 
end
global C;
switch(action)
    case 'start'
        plot(0, 0);
        axis([0 1 0 1]);    % create axes
        title('Click and drag your mouse in this window!');
        
        % Set the call back function when the mouse is pressed
        set(gcf, 'WindowButtonDownFcn', 'mouse01 down');
    case 'down' % the callback function when button is pressed
        % update the callback function of mouse movement
        axis([0 1 0 1]); 
        set(gcf, 'WindowButtonMotionFcn', 'mouse01 move  yellow');
        % update the callback function of mouse button released
        set(gcf, 'WindowButtonUpFcn', 'mouse01 up');
        % debug information
        fprintf('Mouse down!\n');
   case 'up'   % the callback function when button is released
        % update the callback function of mouse movement <-- don't do anything
        set(gcf, 'WindowButtonMotionFcn', '');
        % update the callback function of mouse button released <-- don't do anything
        set(gcf, 'WindowButtonUpFcn', '');
        % debug information
        fprintf('Mouse up!\n');
    case 'move' % the callback function when mouse is moved with key pressed
        currPt = get(gca, 'CurrentPoint');
        x = currPt(1,1);
        y = currPt(1,2);
        pt = line(x, y, 'marker', '*');
        % Rotate2d(10, [2, 2], gca);
        % a = get(h, 'value');
        fprintf('color = %d\n', C);
        switch(C)
            case 1    
                set(pt, 'color', 'r');
            case 2
                set(pt, 'color', 'b');
            case 3
                set(pt, 'color', 'y');
            case 4
                set(pt, 'color', 'm');
            case 5
                set(pt, 'color', 'g');
            case 6
                set(pt, 'color', 'k');
                
        end
        
        % debug information
        fprintf('Mouse is moving! Current location = (%g, %g)\n', x, y);
end

