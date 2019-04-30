clear all;
close all;

% Load audio signal
[original,Fs] = audioread('maleVoice.wav');
[train, Fst] = audioread('Train-noise.wav');
Fn = Fs/2;
n = length(original);

train = resample(train, Fs, Fst);
train = train(:,1);
m = length(train);
train = [train; zeros((n-m), 1)];
train = train .* 0.9;

T = fft(train);
T = fftshift(T);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

O = fft(original);
O = fftshift(O);

SNR = abs(O) ./ abs(T);

figure;
subplot(2,1,1);
plot(f, abs(T));
hold on;
plot(f, abs(O));

subplot(2,1,2);
plot(f, SNR);

a = sqrt(abs(T)) ./ sqrt(abs(O));
improved = original .* a;

b = sum(abs(original)) / sum(abs(improved));
improved = improved .* b;

I = fft(improved);
I = fftshift(I);

SNR = abs(I) ./ abs(T);

figure;
subplot(2,1,1);
plot(f, abs(T));
hold on;
plot(f, abs(I));

subplot(2,1,2);
plot(f, SNR);

% Near-end noise
original = original + train;
improved = improved + train;

sound(improved, Fs);

