clear all;
close all

% Load audio signal
[x,fs] = audioread('maleVoice.wav');
n = length(x);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*fs/(2*pi);
randnoise = 0.02*randn(n, 1);

trans = transient_process(x, fs, 505);

enhanced = transient_amplify(x, trans, 9);
siib = SIIB_Gauss(enhanced, enhanced+randnoise, fs);

filter = Transient_static(enhanced, x);
freqz(filter)
E = ifft(fft(x).*filter);

immse(E, enhanced)

figure;
plot(E);
figure;
plot(enhanced)
soundsc(E, fs)

