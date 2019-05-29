clear all;
close all;

[x,fs] = audioread('maleVoice.wav');

o = 0.5;
w = hann(500);

y = OLA(x, o, w, 0.8);

soundsc(y, fs);