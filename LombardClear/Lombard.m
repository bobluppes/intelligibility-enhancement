function improved = Lombard(original, Fs, snr, extension, tilt)
% parameters (dependend on SNR??)

% Calculate variables


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
a = Po / Pi;
improved = improved .* a;

% Dynamic range compression
improved = compress(improved, -20);



