function improved = Lombard(original, Fs, snr, timeInt)
% set values (dependend on SNR??)
extension = 3;
tilt = 0;

% Calculate variables
n = length(original);
sampleInt = timeInt * Fs;
steps = round(n/sampleInt);

%extend vowels and spectral tilt
thres = (0.1 * max(original)) * sampleInt;
improved = extend_vowels(original, Fs, extension, sampleInt, thres, steps);
improved = spectral_tilt(improved, Fs);

% Fourier Transform of original and improved signals
O = fft(original);
O = fftshift(O);
I = fftshift(fft(improved));

% Normalize the improved signal power
Po = sum(abs(O));
Pi = sum(abs(I));
a = Po / Pi;
improved = improved .* a;



