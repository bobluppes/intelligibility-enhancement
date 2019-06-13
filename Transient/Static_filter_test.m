clear all;
close all

% Load audio signal
[x,fs] = audioread('maleVoice.wav');
n = length(x);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*fs/(2*pi);
randnoise = randn(n, 1);

trans = transient_process(x, fs, 505);
TFenhanced = transient_amplify(x, trans, 8);

h = Transient_static(TFenhanced, x);
enhanced = highpass(conv(x,h), 100, fs);

figure;
plot(abs(fftshift(fft(enhanced))));
figure;
plot(abs(fftshift(fft(TFenhanced))));

soundsc(enhanced, fs);
