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
train = train .* 0.1;

O = fftshift(fft(original));
N = fftshift(fft(train));

t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

SIIB_old = SIIB_Gauss(original, original+train, Fs);

I = O - N;
improved = abs(ifft(I));

figure;
plot(f, abs(O));
hold on;
plot(f, abs(N));

soundsc(improved+train, Fs);

SIIB_new = SIIB_Gauss(original, improved+train, Fs);



