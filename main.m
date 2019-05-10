clear all;
close all

timeInt = 0.1; % 100ms

% Load audio signal
[original,Fs] = audioread('clean_speech.wav');
[train, Fst] = audioread('Sounds/Train-noise.wav');


improved = Lombard(original, Fs, 0, timeInt);

%soundsc(improved(1:end), Fs);

%% plots of improved and original in time and frequency domain
I = fftshift(fft(improved));
O = fftshift(fft(original));
n = length(I);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);
n = length(O);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f1 = Omega*Fs/(2*pi);


figure;
plot(original);
hold on;
plot(improved);

figure;
plot(f, abs(I));
hold on
plot(f1, abs(O));