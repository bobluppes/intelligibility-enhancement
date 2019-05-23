clear all;
close all

% Load audio signal
[original,Fs] = audioread('clean_speech.wav');
[train, Fst] = audioread('Sounds/Train-noise.wav');
% initialize noise
train = resample(train, Fs, Fst);
train = train(:,1);
train1 = [train; train];
noise = train(1:length(original));

% SIIB original
siib_original = SIIB_Gauss(original, original+noise, Fs);

%% SIIB optimization
Is = sii_opt(original, noise, Fs);
siib_sii_opt = SIIB_Gauss(Is, Is+noise, Fs);


%% Lombard
% siib_lombard = [];
% tilt = linspace(0,1,20);
% for i = 1:length(tilt)
%     Il = Lombard(original, Fs, 0, 0.5, tilt(i));
%     noise_lombard = train1(1:length(Il));
%     siib_lombard(i) = SIIB_Gauss(Il, Il+noise_lombard, Fs);
% end


Il = Lombard(original, Fs,0, 3,1);
noise_lombard = train1(1:length(Il));
siib_lombard = SIIB_Gauss(Il, Il+noise_lombard, Fs);


%% Transient
It = Transient(original, Fs);
siib_transient = SIIB_Gauss(It, It+noise, Fs);

%% Plot 
figure
plot(abs(fftshift(fft(Il))))
figure
plot(original)
hold on
plot(Il)
% figure;
% plot(tilt, siib_lombard);
% title('SIIB flattening spectral tilt');
% xlabel('Filter coefficient');ylabel('SIIB [bits/s]')