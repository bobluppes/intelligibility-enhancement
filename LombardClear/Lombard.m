function improved = Lombard(original, Fs, snr, extension, tilt, comp)
% original: audiosignal
% Fs: sample rate
% snr: signal-to-noise ratio in dB
% extension: extension factor between 3 and 0.25 > 3 is maximal slow down
% tilt: spectral tilting factor between 0 and 1
improved = original;
%extend vowels and spectral tilt
improved = extend_vowels(original, Fs, extension);
improved = spectral_tilt(improved, tilt);

% Normalize the improved signal power
Po = sqrt(sum(original.^2));
Pi = sqrt(sum(improved.^2));
a = Po*length(improved) / (Pi*length(original));
improved = improved .* a;

% Dynamic range compression
improved = compress(improved, -comp);



