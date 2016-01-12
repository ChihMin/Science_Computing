%% Q1

clear all;
[y, Fs, nbits] = wavread('band_pass.wav');
[sample, ~] = size(y);
sound(y, Fs);
% 1. space in matlab
space = sample * nbits / 8 
% 2. data type = wav
% 3. space = sample * nbits / 8 
% 4. band_pass = 1279632 bytes
% 5. overhead = 1279632 - 1279588
overhead = 1279632 - space


%% Q2

C = 523.25;
D = 587.33;
E = 659.26;
F = 698.46;
G = 783.99;

Fs=44100;
Ts=1/Fs;
t=[0:Ts:0.5];
 
C = sin(2 * pi * C * t);
D = sin(2 * pi * D * t);
E = sin(2 * pi * E * t);
F = sin(2 * pi * F * t);
G = sin(2 * pi * G * t);

sound([C, D, E ,C, C, D, E, C, E, F, G, G, E, F, G, G], Fs);
