clear all;
close all;

% Load audio signal
[original,Fs] = audioread('maleVoice.wav');
Fn = Fs/2;
n = length(original);
m = 10000;

improved = slow(original, Fs)