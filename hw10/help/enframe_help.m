%% enframe
% Perform frame blocking on given signals
%% Syntax
% * 		out = enframe(y, frameSize, overlap)
%% Description
% 		out=enframe(y, frameSize, overlap) splits given signals into frames, with each column being a frame.
%% Example
%%
%
waveFile='what_movies_have_you_seen_recently.wav';
au=myAudioRead(waveFile);
frameSize=256;
overlap=128;
frameMat=enframe(au.signal, frameSize, overlap);
mesh(frameMat);
