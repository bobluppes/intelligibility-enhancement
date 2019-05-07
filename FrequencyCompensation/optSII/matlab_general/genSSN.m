function y = genSSN(x, snr)

N           = 512;
K           = 256;
N_fft       = N;

hf          = mean(abs(stdft(x, N, K, N_fft)).^2)/N;

Nxold       = length(x);
N_x         = length(x)+2*N_fft;

n           = randn(N_x, 1);
nf          = stdft(n, N, K, N_fft);

nf          = nf./sqrt(mean(mean(abs(nf).^2)/N));
nf          = nf.*sqrt(repmat(hf, [size(nf, 1) 1]));
n           = istdft(nf, N, K);

n           = n(1:Nxold).';

y        	= x+(n*(rms(x))./rms(n))*10^(-(snr)/20);
