% Question: Articles that implement Lombard-like Effect?
% Question: Why soundsc instead of sound
clear all;
close all

timeInt = 0.1; % 100ms

% Load audio signal
[original,Fs] = audioread('clean_speech.wav');
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
thres = (0.13 * max(original)) * sampleInt;
improved = [];
for i = 0:(steps - 2)
    % Take timeframe
    x = original(round((i*sampleInt)+1):round((i+1)*sampleInt));
    
    pow = sum(abs(x));
    
    if pow > thres
        % Vowel
        sound = transpose(slow(x, Fs, 3));
    else
        % Consonant
        sound = x;
    end
    
    improved = [improved; sound];
    
end

% [f0, f1, f2, f3] = formants(improved, Fs, 900);
% 
% n = length(improved);
% t = linspace(0, (n/Fs), n);
% Omega = pi*[-1 : 2/n : 1-1/n];
% f = Omega*Fs/(2*pi);
% 
% Fc = 500;                                 % Desired Output Frequency   
% carrier = sin(2*pi*(Fc)*t);               % Generate Carrier 
% sm = transpose(f0) .* carrier;                          % Modulate (Produces Upper & Lower Sidebands
% Fn = Fs/2;                                  % Design High-Pass Filter To Eliminate Lower Sideband
% Wp = Fc/Fn;
% Ws = Wp*0.8;
% [n,Wn] = buttord(Wp, Ws, 1, 10);
% [b,a] = butter(n,Wn,'high');
% [sos,g] = tf2sos(b,a);
% f0 = transpose(2*filtfilt(sos,g,sm));
% 
% Spectral tilting
% improved = f0 * 0.1 + f1 * 0.3 + f2 * 0.7 + f3 * 0.8;

I = fftshift(fft(improved));
n = length(I);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

% Normalize the improved signal power
Po = sum(abs(O));
Pi = sum(abs(I));
a = Po / Pi;
improved = improved .* a;

figure;
plot(original);
hold on;
plot(improved);

figure;
plot(f, abs(I));


soundsc(improved(1:end), Fs);

