clear all;
close all;

% Load audio signal
[original,Fs] = audioread('Sounds/clean_speech.wav');
[train, Fst] = audioread('Sounds/Train-noise.wav');
Fn = Fs/2;
n = length(original);

% Fourrier domain
O = fftshift(fft(original));
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);
kmax = f(end)/1000;

figure;
plot(f, abs(O));
hold on;
for i = 0:kmax
    x = i * 1000;
    line([x x], get(gca, 'ylim'), 'Color', 'red');
end
title('Formants');
xlabel('Frequency [Hz]');
ylabel('Amplitude');

[f0, f1, f2, f3] = formants(original, Fs);

F0 = fftshift(fft(f0));
F1 = fftshift(fft(f1));
F2 = fftshift(fft(f2));
F3 = fftshift(fft(f3));

figure;
plot(f, abs(F0));
hold on;
plot(f, abs(F1));
plot(f, abs(F2));
plot(f, abs(F3));
