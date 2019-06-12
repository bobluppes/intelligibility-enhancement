clear all;
close all

% Load audio signal
[x,fs] = audioread('maleVoice.wav');
n = length(x);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*fs/(2*pi);
randnoise = randn(n, 1);

trans = transient_process(x, fs, 505);

amp = linspace(0, 20, 40);
noise_amp = linspace(0.01, 0.2, 20);
siib = [];
snr = [];
for i =1:length(noise_amp)
    noise = noise_amp(i) * randnoise;
    snr(i) = 10*log10((sum(abs(x).^2)) / (sum(abs(noise).^2)));
    for j = 1:length(amp)
        enhanced = transient_amplify(x, trans, amp(j));
        siib(i,j) = SIIB_Gauss(enhanced, enhanced+noise, fs);
    end
end

surf(amp, snr, siib);
    
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