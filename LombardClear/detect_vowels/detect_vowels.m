clear all;
close all

% Load audio signal
[original,Fs] = audioread('clean_speech.wav');
[train, Fst] = audioread('Sounds/Train-noise.wav');

%% Log energy
% if log energy larger than ~-6.5, vowel, else consonant > only tested on
% part from 1:80000
sfn = vowels_log_energy(original, Fs);
vowels = zeros(length(original),1);
frame = round(length(original)/length(sfn));
for i = 1:(length(sfn)-1)
    if ((sfn(i)+6.5)<0)
        vowels((i-1)*frame+1:(i)*frame) = 0;
    else
        vowels((i-1)*frame+1:(i)*frame) = 1;

    end   
end
only_vowels = vowels.*original;
figure
subplot(2,2,1)
as = linspace(0,length(original)/Fs,length(sfn));
yyaxis left
plot(as,sfn);
ylabel('Log-energy');
hold on
as2 = linspace(0,length(original)/Fs,length(original));
yyaxis right
plot(as2,original);
plot(as2,vowels);
xlabel('Time [s]');ylabel('Amplitude')
xlim([0 80000/Fs])
%soundsc(only_vowels(1:80000),Fs)

%% Zero crossings
sfn = vowels_zero_crossings(original, Fs);
vowels = zeros(length(original),1);
frame = round(length(original)/length(sfn));
for i = 1:(length(sfn)-1)
    if ((sfn(i))<0.4)
        vowels((i-1)*frame+1:(i)*frame) = 0;
    else
        vowels((i-1)*frame+1:(i)*frame) = 1;

    end   
end
only_vowels = vowels.*original;

subplot(2,2,2)
as = linspace(0,length(original)/Fs,length(sfn));
yyaxis left
plot(as,sfn);
ylabel('Zero-crossing rate')
hold on
as2 = linspace(0,length(original)/Fs,length(original));
yyaxis right
plot(as2,original);
plot(as2,vowels)
xlabel('Time [s]');ylabel('Amplitude');
xlim([0 80000/Fs])
%soundsc(only_vowels(1:80000),Fs)
%% Autocorrelation
sfn = vowels_autocorrelation(original, Fs);
vowels = zeros(length(original),1);
frame = round(length(original)/length(sfn));
for i = 1:(length(sfn)-1)
    if ((sfn(i,2))<0.9)
        vowels((i-1)*frame+1:(i)*frame) = 0;
    else
        vowels((i-1)*frame+1:(i)*frame) = 1;

    end   
end
only_vowels = vowels.*original;
subplot(2,2,3)
as = linspace(0,length(original)/Fs,length(sfn));
yyaxis left
plot(as,sfn(:,2));
ylabel('Lag-one autocorrelation')
hold on
as2 = linspace(0,length(original)/Fs,length(original));
yyaxis right
plot(as2,original);
plot(as2,vowels)
xlabel('Time [s]');ylabel('Amplitude');
xlim([0 80000/Fs])
%soundsc(only_vowels(1:80000),Fs)
%% Spectral Flatness
sfn = vowels_spectral_flatness(fftshift(fft(original)), Fs);
vowels = zeros(length(original),1);
frame = round(length(original)/length(sfn));
for i = 1:(length(sfn)-1)
    if ((sfn(i))>0.28)
        vowels((i-1)*frame+1:(i)*frame) = 0;
    else
        vowels((i-1)*frame+1:(i)*frame) = 1;

    end   
end
only_vowels = vowels.*original;
subplot(2,2,4)
as = linspace(0,length(original)/Fs,length(sfn));
yyaxis left
plot(as,sfn);
ylabel('Spectral flattening')
hold on
as2 = linspace(0,length(original)/Fs,length(original));
yyaxis right
plot(as2,original);
plot(as2,vowels)
xlabel('Time [s]');ylabel('Amplitude');
xlim([0 80000/Fs])
%soundsc(only_vowels(1:80000),Fs)

% suptitle('She had your dark suit and greasy wash water all year ')

%%%% 0:80000: She had your dark suit and greasy wash water all year

%soundsc(original(1:80000),Fs)
