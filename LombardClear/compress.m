function y = compress(x, t)

dRC = compressor('AttackTime',0,'ReleaseTime',0);
dRC.Threshold = t;

improved = dRC(x);

% Normalize power
X = fftshift(fft(x));
I = fftshift(fft(improved));
Px = sum(abs(X));
Pi = sum(abs(I));
a = Px / Pi;
y = improved .* a;
