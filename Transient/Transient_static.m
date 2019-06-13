function h = Transient_static(z, x)
% Compute a fixed-frequency filter based on Rasetshwane and Yoo's algorithm

% Compute fourier of z and x
h = tfestimate(z, x);