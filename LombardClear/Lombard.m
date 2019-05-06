% Question: Articles that implement Lombard-like Effect?
clear all;
close all

timeInt = 0.1; % 10ms

% Load audio signal
[original,Fs] = audioread('speech_dft_8kHz.wav');
[train, Fst] = audioread('Sounds/Train-noise.wav');
Fn = Fs/2;
n = length(original);

sampleInt = timeInt * Fs;
steps = round(n/sampleInt);

O = fft(original);
O = fftshift(O);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

% Loop time segments
thres = (0.2 * max(original)) * sampleInt;
improved = [];
for i = 0:(steps - 2)
    % Take timeframe
    x = original(round((i*sampleInt)+1):round((i+1)*sampleInt));
    
    pow = sum(abs(x));
    
    if pow > thres
        % Vowel
        sound = transpose(slow(x, Fs, 1.5));
    else
        % Consonant
        sound = x;
    end
    
    improved = [improved; sound];
    
end


sound(improved(1:end));

