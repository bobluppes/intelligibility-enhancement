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


[Pv_old, Pv_t, y] = spectral_tilt(x, Fs);

% figure;
% plot(Pv_t);

X = fftshift(fft(x));
Y = fftshift(fft(y));
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

figure;
subplot(2,1,1);
plot(f, abs(X));
title('Original');

subplot(2,1,2);
plot(f, abs(Y));
title('Decreased spectral tilt');

soundsc(y+noise*0.6, Fs);

