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
%subplot(2,2,1)
as = linspace(1,length(original),length(sfn));
plot(as,sfn+6.5);
hold on
%plot([0,length(sfn)],[0.47,0.47])
as2 = linspace(1,length(original),length(original));
plot(as2,original);
plot(as2,vowels);
title('Log energy (more energy in vowels)')
%xlim([0 80000])
soundsc(only_vowels(1:80000),Fs)
%% Zero crossings
sfn = vowels_zero_crossings(original, Fs);
vowels = zeros(length(original),1);
frame = round(length(original)/length(sfn));
for i = 1:(length(sfn)-1)
    if ((sfn(i))>40)
        vowels((i-1)*frame+1:(i)*frame) = 0;
    else
        vowels((i-1)*frame+1:(i)*frame) = 1;

    end   
end
only_vowels = vowels.*original;

subplot(2,2,2)
as = linspace(1,length(original),length(sfn));
plot(as,sfn*0.01);
hold on
plot([0,length(sfn)],[0.47,0.47])
as2 = linspace(1,length(original),length(original));
plot(as2,original);
title('Zero crossings (more zerocrossings in consonants)')
xlim([0 80000])
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
as = linspace(1,length(original),length(sfn));
plot(as,sfn);
hold on
plot([0,length(sfn)],[0.47,0.47])
as2 = linspace(1,length(original),length(original));
plot(as2,original);
title('Autocorrelation (high for vowels)')
xlim([0 80000])
%soundsc(only_vowels(1:80000),Fs)
%% Spectral Flatness
sfn = vowels_spectral_flatness(original, Fs);
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
as = linspace(1,length(original),length(sfn));
plot(as,sfn);
hold on
plot([0,length(sfn)],[0.47,0.47])
as2 = linspace(1,length(original),length(original));
plot(as2,original);
title('Spectral flattening (high for consonants)')
xlim([0 80000])
soundsc(only_vowels(1:80000),Fs)

suptitle('She had your dark suit and greasy wash water all year ')

%%%% 0:80000: She had your dark suit and greasy wash water all year

%soundsc(original(1:80000),Fs)
