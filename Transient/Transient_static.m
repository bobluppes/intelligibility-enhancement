function H = Transient_static(z, x)
% Compute a fixed-frequency filter based on Rasetshwane and Yoo's algorithm
X = fft(x);
Z = fft(z);
H = abs(Z)./abs(X);
