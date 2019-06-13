clear all;
close all

% Load audio signal
[x,fs] = audioread('maleVoice.wav');
n = length(x);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*fs/(2*pi);
randnoise = 0.02*randn(n, 1);

trans = transient_process(x, fs, 505);

amp = linspace(0, 20, 40);
siib = [];
for i = 1:length(amp)
    enhanced = transient_amplify(x, trans, amp(i));
    siib(i) = SIIB_Gauss(enhanced, enhanced+randnoise, fs);
end

figure;
plot(amp, siib);
