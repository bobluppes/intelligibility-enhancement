function [f0, f1, f2, f3] = formants(audio, Fs, bw)

% The audio input is a time decomposed audio signal
% Formants() will determing the fundamental frequency
% and the first three speech formants and return separate
% time domain signals for each formants

% Bandwidth constraints
if bw > 900
    bw = 900
end
bw = bw / 2;

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
f = f(round(length(f)/2):end);
f = resample(f, 1, 1000);

F0 = fftshift(fft(tf0));
F0 = F0(round(length(F0)/2):end);
F0 = resample(abs(F0), 1, 1000);

F1 = fftshift(fft(tf1));
F1 = F1(round(length(F1)/2):end);
F1 = resample(abs(F1), 1, 1000);

F2 = fftshift(fft(tf2));
F2 = F2(round(length(F2)/2):end);
F2 = resample(abs(F2), 1, 1000);

F3 = fftshift(fft(tf3));
F3 = F3(round(length(F3)/2):end);
F3 = resample(abs(F3), 1, 1000);

m0 = 0;
m1 = 0;
m2 = 0;
m3 = 0;
for i = 1:length(F0)
    m0 = m0 + (F0(i) * f(i));
    m1 = m1 + (F1(i) * f(i));
    m2 = m2 + (F2(i) * f(i));
    m3 = m3 + (F3(i) * f(i));
end
if m0 ~= 0
    m0 = m0 / (sum(abs(F0)));
end
if m1 ~= 0
    m1 = m1 / (sum(abs(F1)));
end
if m2 ~= 0
    m2 = m2 / (sum(abs(F2)));
end
if m3 ~= 0
    m3 = m3 / (sum(abs(F3)));
end

% Determine formants around center frequencies
f0 = bandpass(audio, [max((m0-bw), 50) min((m0+bw), 950)], Fs);
f1 = bandpass(audio, [max((m1-bw), 50) min((m1+bw), 1950)], Fs);
f2 = bandpass(audio, [max((m2-bw), 50) min((m2+bw), 2950)], Fs);
f3 = bandpass(audio, [max((m3-bw), 50) min((m3+bw), 3950)], Fs);