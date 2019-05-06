% Plays competing signal in frequency band next to distortion
% Only works for sinusoidal distortions 
% Question: Is it useful to keep looking into this?
clear all;
close all;

% Load audio signal
[original,Fs] = audioread('Sounds/maleVoice.wav');
Fn = Fs/2;
n = length(original);

O = fft(original);
O = fftshift(O);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

% Generate white noise
noise = randn(1,n);
N = fftshift(fft(noise));

% Normalize the improved signal power
Po = sum(abs(O));
Pi = sum(abs(N));
a = Po / Pi;
noise = noise .* a;

noise = bandpass(noise, [1950 2050], Fs);
N = fftshift(fft(noise));

improved = transpose(original);
q1 = bandpass(improved, [1900 2100], Fs) * 10;
improved = improved + q1;

I = fftshift(fft(improved));

% Normalize the improved signal power
Po = sum(abs(O));
Pi = sum(abs(I));
a = Po / Pi;
improved = improved .* a;

figure;
plot(f, abs(I));
hold on;
plot(f, abs(N));

sound(improved + noise, Fs);