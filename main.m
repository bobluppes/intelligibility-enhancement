clear all;
close all

% Load audio signal
[original,Fs] = audioread('ButcherBlock.wav');
[train, Fst] = audioread('Sounds/mixture.wav');
%initialize noise
train = resample(train, Fs, Fst);
train = train(:,1);
train = [train; train; train;];
noise = train(1:length(original));

original = sii_opt(original, noise, Fs);

soundsc(original, Fs);

noisy = original + noise*2;

audiowrite('sii_example.wav', original, Fs);
return;

% SIIB original
% siib_original = SIIB_Gauss(original, original+noise, Fs);
% 
% %% SIIB optimization
% Is = sii_opt(original, noise, Fs);
% siib_sii_opt = SIIB_Gauss(Is, Is+noise, Fs);


%% Lombard
% siib_lombard = [];
% tilt = linspace(0,1,20);
% for i = 1:length(tilt)
%     Il = Lombard(original, Fs, 0, 0.5, tilt(i));
%     noise_lombard = train1(1:length(Il));
%     siib_lombard(i) = SIIB_Gauss(Il, Il+noise_lombard, Fs);
% end

comp = linspace(0, 100, 20);

mod = [];
prompt = {'Bob', 'Ellen'};
for i = 1:length(comp)
    Il = Lombard(original, Fs, 0, 1, comp(i));
    noise_lombard = train1(1:length(Il));
    comp(i)
    siib_lombard = SIIB_Gauss(Il, Il+noise_lombard, Fs)
    soundsc(Il + noise_lombard*0.8, Fs);
    pause;
    if (i ~= 0)
        duration = length(Il)/Fs;
        answer = inputdlg(prompt);
        mod(i) = (str2num(answer{1})/duration + str2num(answer{2})/duration)/2;
    end
end

return;

imp = [];
imp(1) = mod(1);
for i = 2:length(mod)
    imp(i) = mod(i)+imp(i-1);
end

figure;
plot(comp, mod);
title('Listening test compressor');
xlabel('Compressor Threshold');
ylabel('Intelligibility [%]');



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