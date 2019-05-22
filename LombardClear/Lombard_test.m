clear all;
close all;

% Load audio signal
[x,Fs] = audioread('Sounds/maleVoice.wav');
[t, Fst] = audioread('Sounds/Train-noise.wav');
Fn = Fs/2;
n = length(x);
t = resample(t, Fs, Fst);
t = t(:,1);
m = length(t);
noise = [t; zeros((n-m), 1)];


y = Lombard(x, Fs, 10, 0.02);

siib_old = SIIB_Gauss(x, x+noise, Fs);
noise = [t; zeros((length(y)-m), 1)];
siib_new = SIIB_Gauss(y, y+noise, Fs);