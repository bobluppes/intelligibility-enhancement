%% An example of how to use OptMI
% Copyright 2017: Steven Van Kuyk
% This program comes WITHOUT ANY WARRANTY.
clear all
clc
fs = 16000;

% clean speech
[x, Fs] = audioread('clean.wav');
x = resample(x,fs,Fs);

% noise signal
[n, Fs] = audioread('car_noise.wav');
n = resample(n,fs,Fs);
n=n(1:length(x));

% set SNR to -20 dB
sig2_x = var(x);
snr = db2pow(-20);
sig2_n = sig2_x/snr;
n = sqrt(sig2_n)*n/std(n);

% maximize the mutual information
gX = OptMI(x,n,fs);

% save files
audiowrite('mixture.wav',x+n,fs)
audiowrite('enhanced_speech.wav',gX,fs)
audiowrite('enhanced_mixture.wav',gX+n,fs)
