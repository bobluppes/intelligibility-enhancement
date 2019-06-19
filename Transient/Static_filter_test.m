clear all;
close all

% Load audio signal
[x,fs] = audioread('clean_speech.wav');
n = length(x);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*fs/(2*pi);
randnoise = randn(n, 1);

snr_need = 3;
px = sqrt(sum(x.^2));
pn = px/10^(snr_need/10);
randnoise = pn/sqrt(sum(randnoise.^2))*randnoise;
snr = 10*log10(px/ pn);

trans = transient_process(x, fs, 505);
enhanced = transient_amplify(x, trans, 10);

filter = Transient_static(enhanced, x);

X = fft(x);

static_enhanced = ifft(X.*filter);
siib_o = SIIB_Gauss(x, x+randnoise, fs);
siib_trans = SIIB_Gauss(enhanced, enhanced+randnoise, fs);
siib_static = SIIB_Gauss(static_enhanced, static_enhanced+randnoise, fs);
%%
noise = [];
for i = 1:length(randnoise)
    noise(i) = sin(i/5000)*randnoise(i);
end
noise = pn/sqrt(sum(noise.^2))*noise;
snr_f = 10*log10(px/sqrt(sum(noise.^2)));
noise = noise';
siib_o_f = SIIB_Gauss(x, x+noise, fs);
siib_trans_f = SIIB_Gauss(enhanced, enhanced+noise, fs);
siib_static_f = SIIB_Gauss(static_enhanced, static_enhanced+noise, fs);
%%
SE = fftshift(fft(static_enhanced));

X = fftshift(X);
% figure;
% subplot(2,1,1);
% plot(f, 2*abs(X));
% title('Original speech signal');
% xlabel('Frequency [Hz]');
% ylabel('Magnitude');
% xlim([0 4000]);
% subplot(2,1,2);
% plot(f, 2*abs(SE));
% title('Static filter enhanced speech signal');
% xlabel('Frequency [Hz]');
% ylabel('Magnitude');
% xlim([0 4000]);
% 
% return;

trans = transient_process(x, fs, 505);

amp = linspace(0, 20, 40);
noiseamp = logspace(log10(0.01), log10(0.08), 20);
siib = [];
snr = [];
for i = 1:length(amp)
    enhanced = transient_amplify(x, trans, amp(i));
    for j = 1:length(noiseamp)
        noise = noiseamp(j) * randnoise;
        siib(i,j) = SIIB_Gauss(enhanced, enhanced+noise, fs);
        if (i == 1)
            S = sqrt(sum(enhanced.^2));
            N = sqrt(sum(noise.^2));
            snr(j) = 10 * log10(S/N);
        end
    end
end

maxx = [];
maxy = [];
figure;
plot(amp, siib(:,1));
hold on;
[M, I] = max(siib(:,1));
maxx(1) = M;
maxy(1) = amp(I);
for i = 2:(length(snr)-1)
    plot(amp, siib(:,i));
    [M, I] = max(siib(:,i));
    maxx(i) = M;
    maxy(i) = amp(I);
end
plot(maxy, maxx, 'r*');
ylim([0 230]);
xlabel('Amplification factor');
ylabel('SIIB^{Gauss} [bits/s]');
legend('SNR 6 dB', 'SNR 5.5 dB', 'SNR 5 dB', 'SNR 4.5 dB', 'SNR 4 dB', 'SNR 3.5 dB', 'SNR 3 dB', 'SNR 2.5 dB', 'SNR 2 dB', 'SNR 1.5 dB', 'SNR 1 dB', 'SNR 0.5 dB', 'SNR 0 dB', 'SNR -0.5 dB', 'SNR -1 dB', 'SNR -1.5 dB', 'SNR -2 dB', 'SNR -2.5 dB', 'SNR -3 dB', 'Maxima');

