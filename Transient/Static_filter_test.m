clear all;
close all

% Load audio signal
[x,fs] = audioread('maleVoice.wav');
n = length(x);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*fs/(2*pi);
noise = 0.01*randn(n, 1);

trans = transient_process(x, fs, 400);

X = fftshift(fft(x));
T = fftshift(fft(trans));

figure;
plot(f, abs(X));
hold on;
plot(f, abs(T));

return;

figure;
plot(x);
hold on;
plot(trans*0.0001);

amp = linspace(0, 20, 40);
siib = [];
for i = 1:length(amp)
    enhanced = transient_amplify(x, trans, amp(i));
    siib(i) = SIIB_Gauss(enhanced, enhanced+noise, fs); 
end

figure;
plot(amp, siib);

clicks = bandpass(trans, [3930 3980], fs);
soundsc(clicks, fs);