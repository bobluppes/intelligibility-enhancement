function H = Transient_static(z, x)
% Compute a fixed-frequency filter based on Rasetshwane and Yoo's algorithm
H = abs(fft(z))./abs(fft(x));
