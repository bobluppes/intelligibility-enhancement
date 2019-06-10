function AudioOut = Transient(x, fs)

% Parameters
amplification = 12;
band = 216;

trans = transient_process(x, fs, band);

T = fftshift(fft(trans));
n = length(T);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*fs/(2*pi);
figure;
plot(f, abs(T));
figure;
plot(trans);

AudioOut = transient_amplify(x, trans, amplification);

