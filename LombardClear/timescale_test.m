clear all;
close all;

[x,fs] = audioread('maleVoice.wav');

o = 0.5;
w = hann(500);

y = OLA(x, 0.5, w, 1.2);

soundsc(y, fs);