function [f0, f1, f2, f3] = formants(audio, Fs)

% The audio input is a time decomposed audio signal
% Formants() will determing the fundamental frequency
% and the first three speech formants and return separate
% time domain signals for each formants

% Fourrier domain
A = fftshift(fft(audio));
n = length(A);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

% Split up in temporary formants to determine center frequencies
tf0 = bandpass(audio, [50 950], Fs);
tf1 = bandpass(audio, [1050 1950], Fs);
tf2 = bandpass(audio, [2050 2950], Fs);
tf3 = bandpass(audio, [3050 3950], Fs);

% Determine formant center frequencies
m0 = 500;
m1 = 1500;
m2 = 2500;
m3 = 3500;

% Determine formants around center frequencies
f0 = bandpass(audio, [max((m0-450), 0) m0+450], Fs);
f1 = bandpass(audio, [m1-450 m1+450], Fs);
f2 = bandpass(audio, [m2-450 m2+450], Fs);
f3 = bandpass(audio, [m3-450 m3+450], Fs);