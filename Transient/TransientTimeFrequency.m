clear all;
close all;

% Load audio signal
[original,Fs] = audioread('Sounds/maleVoice.wav');
[train, Fst] = audioread('Sounds/Train-noise.wav');
Fn = Fs/2;
n = length(original);

train = resample(train, Fs, Fst);
train = train(:,1);
m = length(train);
train = [train; zeros((n-m), 1)];
train = train .* 0.9;

O = fft(original);
O = fftshift(O);

[hps, hpf] = highpass(original,700,Fs,'Steepness',0.95);
H = fft(hps);
H = fftshift(H);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

findchangepts(abs(H),'MaxNumChanges', 9, 'Statistic','linear');

% figure;
% plot(f, abs(H));
% hold on;
% plot(ipt/Fs);

