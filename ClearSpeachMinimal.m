clear all;
close all;

% Load audio signal
[original,Fs] = audioread('maleVoice.wav');
Fn = Fs/2;
n = length(original);
m = 10000;

O = fft(original);
O = fftshift(O);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

m = length(O);
mask = [zeros(round(m/2), 1); ones(round(m/2) - 1, 1)];
O = O .* mask;
test = [zeros(m, 1); O];

test = ifft(test);
sound(test);

figure;
%plot(f, abs(test));
