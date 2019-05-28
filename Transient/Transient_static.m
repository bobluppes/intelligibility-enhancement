function H = Transient_static(z, x)
% Compute a fixed-frequency filter based on Rasetshwane and Yoo's algorithm

% Compute fourier of z and x
Z = fftshift(fft(z));
X = fftshift(fft(x));

H = abs(Z) ./ abs(X);