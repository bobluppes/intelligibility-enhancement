clear all;
close all;

% Load audio signal
[x,Fs] = audioread('Sounds/clean_speech.wav');
[t, Fst] = audioread('Sounds/Train-noise.wav');
Fn = Fs/2;
n = length(x);
t = resample(t, Fs, Fst);
t = t(:,1);
m = length(t);
%noise = [t; zeros((n-m), 1)];
noise = t(1:n);

% Set compression threshold vector (default -10dB)
threshold = linspace(0, -100, 100);

siib = [];
for i = 1:length(threshold)
    y = compress(x, threshold(i));
    siib(i) = SIIB_Gauss(y, y+noise, Fs);
end

figure;
plot(threshold, siib);
title('SIIB for different compression thresholds');
xlabel('Threshold [dB]');
ylabel('SIIB [bits/s]');




