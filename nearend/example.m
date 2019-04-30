clear all

[x fs]  = wavread('SA1.wav');
n       = randn(size(x));
n       = n*norm(x)/norm(n);
y       = x+n;

dly     = -1;
xn      = processSpeech(x, y, fs, dly);

subplot(2, 1, 1); plot(x+n);
subplot(2, 1, 2); plot(xn+n);