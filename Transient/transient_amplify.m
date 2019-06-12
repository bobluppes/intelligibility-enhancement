function AudioOut = transient_amplify(original, trans, amplification)
% Amplify transient signal and add to original
trans = trans * amplification;
improved = original + trans;

% Normalize energy
O = fftshift(fft(original));
I = fftshift(fft(improved));
Po = sum(original.^2);
Pi = sum(improved.^2);
a = Po ./ Pi;
AudioOut = improved .* a;