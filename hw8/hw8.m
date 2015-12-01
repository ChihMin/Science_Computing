%{

uicontrol('style', 'push', 'position', [200  20 80 30]);
uicontrol('style', 'slide', 'position', [200 70 80 30]);
uicontrol('style', 'radio', 'position', [200 120 80 30]);
uicontrol('style', 'frame', 'position', [200 170 80 30]);
uicontrol('style', 'check', 'position', [200 220 80 30]);
uicontrol('style', 'edit', 'position', [200 270 80 30]);
uicontrol('style', 'list', 'position', [200 320 80 30],...
'string', '1|2|3|4');
uicontrol('style', 'popup', 'position', [200 370 80 30],...
'string', 'one|two|three');

%}
% view(0, 0);
mouse01('start');
global C;
C = 1;
rollValue = 0;
h = uicontrol('style', 'popup', 'position', [0 0 80 30],...
'string', 'red|blue|yellow|pink|green|black|plot');
    set(h, 'Callback', 'C = get(h, ''value''); fprintf(''type is %d\n'', C);');

erase = uicontrol('style', 'push', 'position', [0 40 70 30], 'string', 'clear');
set(erase, 'Callback', 'mouse01(''start'');');

slides = uicontrol('style', 'slide', 'position', [0 80 70 30]);
set(slides, 'Callback', 'oldRollValue = rollValue; rollValue = get(slides, ''value''); camroll(gca, (rollValue - oldRollValue)*100); fprintf(''slides = %d\n'', rollValue);');

