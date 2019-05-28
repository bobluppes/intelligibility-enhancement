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

y = filter(H, 1, x);

soundsc(y, fs);