clear all;
close all

% Load audio signal
[original,Fs] = audioread('clean_speech.wav');
[train, Fst] = audioread('Sounds/Train-noise.wav');
train = resample(train, Fs, Fst);
train = train(:,1);

noise = transpose(train(1:length(original)));
Is = sii_opt(original, noise, Fs);
Il = Lombard(original, Fs, 0, 0.01);
noise_lombard = transpose(train(1:length(Il)));
It = Transient(original, Fs);

siib_original = SIIB_Gauss(original, original+noise, Fs);
siib_sii_opt = SIIB_Gauss(Is, Is+noise, Fs);
siib_lombard = SIIB_Gauss(Il, Il+noise_lombard, Fs);
siib_transient = SIIB_Gauss(It, It+noise, Fs);