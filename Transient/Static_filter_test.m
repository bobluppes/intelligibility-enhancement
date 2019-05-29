clear all;
close all

% Load audio signal
[x,fs] = audioread('maleVoice.wav');
[train, fst] = audioread('Sounds/Train-noise.wav');
% initialize noise
train = resample(train, fs, fst);
train = train(:,1);
train = [train; train];
noise = train(1:length(x));

% Transient algorithm
y_transient = Transient(x, fs);

% Compute static filter
H = Transient_static(y_transient, x);
h = ifft(ifftshift(H));

y = filter(h, 1, x);

siib_old = SIIB_Gauss(x, x+noise, fs);
siib_new = SIIB_Gauss(y, y+noise, fs);
siib_tran = SIIB_Gauss(y_transient, y_transient+noise, fs);

Y = fftshift(fft(y));
n = length(Y);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*fs/(2*pi);
figure;
plot(f, abs(Y));

y = lowpass(y, 3600, fs);
siib_lowpassed = SIIB_Gauss(y, y+noise, fs);

soundsc(y+noise, fs);