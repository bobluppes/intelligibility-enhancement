function enhanced = Controller(x, filter, n, fs)

% Determine SNR
Ps = sqrt(sum(x.^2));
Pn = sqrt(sum(n.^2));
snr = 10*log10(Ps/Pn);

% Use optimal enhancement algorithm based on analysis
if (snr < -2.55)
    % Use SIIB optimized
    enhanced = sii_opt(x, n, fs);
elseif (snr < -1.84)
    % Use Lombard algorithm
    enhanced = Lombard(x, fs, 0, 1, 0.95, 8.8);
elseif (snr < 2.32)
    % Use SIIB optimized
    enhanced = sii_opt(x, n, fs);
else
    % Use Static filter
    X = fft(x);
    enhanced = ifft(X.*filter);
end