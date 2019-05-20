function y = spectral_tilt(x, Fs, tilt)

% Power of original signal
Po = sum(abs(x));

% Compute formants
[f0, f1, f2, f3] = formants(x, Fs, 900);

% Spectral tilting
improved = f0 + f1 + f2 + f3;

% Normalize signal power
Pi = sum(abs(improved));
a = Po / Pi;
y = improved .* a;