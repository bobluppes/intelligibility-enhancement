% Slow down original signal without changing pitch
clear all;
close all;

% Load audio signal
[original,Fs] = audioread('speech_dft_8kHz.wav');
Fn = Fs/2;
n = length(original);
m = 10000;

threshold = 0.1;
scale = 1.5;

% Findchangepts
% https://nl.mathworks.com/help/signal/ref/findchangepts.html
% Limit changepoints in time

improved = slow(original, Fs, 1.5);

for i = 1:length(improved)
    if improved(i) <= threshold
        improved(i) = scale * improved(i);
    else
        improved(i) = 1 * improved(i);
    end
end

O = fft(original);
O = fftshift(O);
I = fft(improved);
I = fftshift(I);

% Normalize the improved signal power
Po = sum(abs(O));
Pi = sum(abs(I));
a = Po / Pi;
improved = improved .* a;

figure;
plot(improved);

sound(improved, Fs);