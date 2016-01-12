% Bezier cubic curve
%
% This file will create a Bezier cubic curve and dispay the plot
% There are two reasons for including comments in the front.
% If you are working with a lot of programs then this will tell you what
% the file is supposed to accomplish.
% Second, if you type help filename ( without the  .m extension) then these
% comments are displayed in the workspace

BCon3 = [-1 3 -3 1; 3 -6 3 0; -3 3 0 0 ; 1 0 0 0 ]; % our 4 X 4 constant Matrix

BezVert3 = [ 0 0 ; 0.3 0.5 ; 0.5 0.7 ; 1.0 1.0];  % the vertices

% Don't you think it will be more useful if the user can key
% in the values at the prompt. We will do it later

for i = 1:1:50          % for loop 1 - 50 insteps of 1
   par = (i - 1)/49;
   XY(i,:) = [par^3 par^2 par 1]*BCon3*BezVert3;           % yep! we have created our data
end 

plot();