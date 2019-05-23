% Amplification of transient components using time frequency decomposition
% Question: What to do with last samples?
clear all;
close all;

% Variables
timeInt = 0.1; % 100ms
bw = 300;

% Load audio signal
[original,Fs] = audioread('Sounds/maleVoice.wav');
[train, Fst] = audioread('Sounds/Train-noise.wav');
Fn = Fs/2;

% Option to use 'matlab' instead of audio file
load mtlb;
original = mtlb;

n = length(original);

% Train noise
train = resample(train, Fs, Fst);
train = train(:,1);
m = length(train);
train = [train; zeros((n-m), 1)];
train = train .* 0.7;

% Samples in interval
sampleInt = timeInt * Fs;
steps = round(n/sampleInt);

% High pass filter original signal
[hps, hpf] = highpass(original,700,Fs,'Steepness',0.95);

% Fourrier transform
O = fft(original);
O = fftshift(O);
H = fft(hps);
H = fftshift(H);

% Compute frequency axis
n = sampleInt;
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

% Loop time segments
trans = [];
for i = 0:(steps - 2)
    % Take timeframe
    x = hps((i*sampleInt)+1:(i+1)*sampleInt,end);
    
    [f0, f1, f2, f3] = formants(x, Fs, 300);
    t = x - f0 - f1 - f2 - f3;
    trans = [trans; t];
end

% Last samples
x = hps(round(((i+1)*sampleInt)+1):end,end);
[f0, f1, f2, f3] = formants(x, Fs, 300);
t = x - f0 - f1 - f2 - f3;
trans = [trans; t];


trans = trans * 12;
original = original(1:length(trans),end);
improved = original + trans;

I = fftshift(fft(improved));

% Compute frequency axis
n = length(improved);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

% Normalize the improved signal power
Po = sum(abs(O));
Pi = sum(abs(I));
a = Po / Pi;
improved = improved .* a;

figure;
plot(f, abs(I));




