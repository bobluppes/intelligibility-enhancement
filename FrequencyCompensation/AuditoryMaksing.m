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

q1 = bandpass(original, [1950 2015], Fs);

q1 = q1 * 12;
improved = original + q1;

I = fftshift(fft(improved));

% Normalize the improved signal power
Po = sum(abs(O));
Pi = sum(abs(I));
a = Po / Pi;
improved = improved .* a;

figure;
plot(f, abs(I));
hold on;
plot(f, abs(O));

sound(improved, Fs);