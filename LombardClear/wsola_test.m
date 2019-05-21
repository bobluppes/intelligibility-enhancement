clear all;
close all

timeInt = 0.5; % 100ms

% Load audio signal
[original,Fs] = audioread('clean_speech.wav');
[train, Fst] = audioread('Sounds/Train-noise.wav');
alpha = 0.5;
nleng = round(40*Fs/1000); %samples standaardwaarde
nshift = round(10*Fs/1000); %samples standaardwaarde
wtype = 1; % Hamming
deltamax = 5;%ms standaardwaarde

ipause = -1; % >=0 is plot for debug


improved = wsola_analysis(original,Fs,alpha,nleng,nshift,wtype,deltamax,ipause);
I = fftshift(fft(improved));
O = fftshift(fft(original));
Po = sum(abs(O));
Pi = sum(abs(I));
a = Po / Pi;
improved = improved .* a;
%soundsc(improved(1:end), Fs);

%% plots of improved and original in time and frequency domain
I = fftshift(fft(improved));
Pi = sum(abs(I));
n = length(I);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);
n = length(O);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f1 = Omega*Fs/(2*pi);


figure;
plot(original);
hold on;
plot(improved);

figure;
plot(f1, abs(O));
hold on
plot(f, abs(I));
