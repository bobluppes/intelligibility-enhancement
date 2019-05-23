function improved = Lombard(original, Fs, snr, extension, tilt)
% original: audiosignal
% Fs: sample rate
% snr: signal-to-noise ratio in dB
% extension: extension factor between 3 and 0.25 > 3 is maximal slow down
% tilt: spectral tilting factor between 0 and 1

%extend vowels and spectral tilt
improved = extend_vowels(original, Fs, extension);
improved = spectral_tilt(improved, tilt);

% Fourier Transform of original and improved signals
O = fft(original);
O = fftshift(O);
I = fftshift(fft(improved));

% Normalize the improved signal power
Po = sum(abs(O));
Pi = sum(abs(I));
a = Po*length(I) / (Pi*length(O));
improved = improved .* a;

% Dynamic range compression
improved = compress(improved, -100);



