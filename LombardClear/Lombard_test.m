clear all;
close all;

% Load audio signal
[x,Fs] = audioread('Sounds/maleVoice.wav');
[t, Fst] = audioread('Sounds/Train-noise.wav');
Fn = Fs/2;
n = length(x);
noise = t(1:n,1);

y = spectral_tilt(x, Fs, 1);

X = fftshift(fft(x));
Y = fftshift(fft(y));
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

figure;
subplot(2,1,1);
plot(f, abs(X));
subplot(2,1,2);
plot(f, abs(Y));


