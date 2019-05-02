clear all;
close all;

% Load audio signal
[original,Fs] = audioread('maleVoice.wav');
[train, Fst] = audioread('Train-noise.wav');
Fn = Fs/2;
n = length(original);

O = fft(original);
O = fftshift(O);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

high = highpass(original,1650,Fs);
mid = bandpass(original,[500 1650],Fs) .* 0.4;
low = lowpass(original,500,Fs) .* 0.1;

improved = low + mid + high;

I = fft(improved);
I = fftshift(I);

% Normalize the improved signal power
Po = sum(abs(O));
Pi = sum(abs(I));
a = Po / Pi;
improved = improved .* a;

figure;
plot(f, abs(I));

sound(improved, Fs);