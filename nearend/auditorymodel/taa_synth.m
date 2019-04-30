function [y rmsyi]    = taa_synth(x, alp, p)

N       = length(x);
x       = [x(:); zeros(p.N - length(x), 1)];

rmsyi   = zeros(p.M, 1);

hf      = sum(p.h.*repmat(alp, [1 size(p.h, 2)]));
y       = ifft(fft(x).*hf');
y       = y(1:N);