clear all;
close all

% Load audio signal
[x,fs] = audioread('maleVoice.wav');
n = length(x);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*fs/(2*pi);
oldrandnoise = randn(n, 1);
Po = sqrt(sum(oldrandnoise.^2));
randnoise = [];
for i = 1:length(oldrandnoise)
    randnoise(i) = sin(1/5000) * oldrandnoise(i);
end
randnoise = randnoise';
Pn = sqrt(sum(randnoise.^2));
randnoise = (Po/Pn) .* randnoise;
%randnoise = oldrandnoise;

figure;
plot(xcorr(randnoise));
return;


lombard_enhanced_nf = Lombard(x, fs, 0, 1, 0.95, 8.8);
lombard_enhanced_f = Lombard(x, fs, 0, 1, 0.95, 1.5);

trans = transient_process(x, fs, 505);
transient_enhanced = transient_amplify(x, trans, 10);

filter = Transient_static(transient_enhanced, x);
X = fft(x);
static_enhanced = ifft(X.*filter);

siib_original = [];
siib_opt = [];
siib_lombard = [];
siib_transient = [];
siib_static = [];

snr_original = [];
snr_opt = [];
snr_lombard = [];
snr_transient = [];
snr_static = [];

noiseamp = logspace(log10(0.01), log10(0.1), 20);
for i = 1:length(noiseamp)
    noise = noiseamp(i) * randnoise;
    
    opt_enhanced = sii_opt(x, noise, fs);
    
    snr_original(i) = 10*log10((sqrt(sum(x.^2))) / (sqrt(sum(noise.^2))));
    snr_opt(i) = 10*log10((sqrt(sum(opt_enhanced.^2))) / (sqrt(sum(noise.^2))));
    snr_lombard(i) = 10*log10((sqrt(sum(lombard_enhanced_nf.^2))) / (sqrt(sum(noise.^2))));
    snr_transient(i) = 10*log10((sqrt(sum(transient_enhanced.^2))) / (sqrt(sum(noise.^2))));
    snr_static(i) = 10*log10((sqrt(sum(static_enhanced.^2))) / (sqrt(sum(noise.^2))));
    
    siib_original(i) = SIIB_Gauss(x, x+noise, fs);
    siib_opt(i) = SIIB_Gauss(opt_enhanced, opt_enhanced+noise, fs);
    siib_lombard(i) = SIIB_Gauss(lombard_enhanced_nf, lombard_enhanced_nf+noise, fs);
    siib_transient(i) = SIIB_Gauss(transient_enhanced, transient_enhanced+noise, fs);
    siib_static(i) = SIIB_Gauss(static_enhanced, static_enhanced+noise, fs);
end

figure;
plot(snr_original, siib_original);
hold on;
plot(snr_opt, siib_opt);
plot(snr_lombard, siib_lombard);
plot(snr_transient, siib_transient);
plot(snr_static, siib_static);
xlabel('SNR [dB]');
ylabel('SIIB^{Gauss} [bits/s]');
legend('Original', 'Optimized for measure', 'Lombard algorithm', 'Time-varying band-pass filters', 'Static filter');



