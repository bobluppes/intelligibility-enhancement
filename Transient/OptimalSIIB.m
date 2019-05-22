clear all;
close all;

% Load audio signal
[x,fs] = audioread('Sounds/maleVoice.wav');
[n, fst] = audioread('Sounds/Train-noise.wav');

n = resample(n, fs, fst);
n = n(:,1);
noise = [n; zeros((length(x)-length(n)), 1)];

amplification = linspace(0,40,80);
band = 216;

trans = transient_process(x, fs, band);

siib = [];
for i = 1:length(amplification)
    y = transient_amplify(x, trans, amplification(i));
    siib(i) = SIIB_Gauss(y, y+noise*0.6, fs);
end


% extra_amp = transient_amplify(x, trans, 70);

% noise_amp = linspace(0.05,2,100);

% siib_y = [];
% siib_x = [];
% siib_e = [];
% snr = [];
% for i = 1:length(noise_amp)
%     amplified_noise = noise_amp(i) * noise;
%     
%     siib_y(i) = SIIB_Gauss(y, y+amplified_noise, fs);
%     siib_x(i) = SIIB_Gauss(x, x+amplified_noise, fs);
%     siib_e(i) = SIIB_Gauss(extra_amp, extra_amp+amplified_noise, fs);
%     
%     Y = fftshift(fft(y));
%     N = fftshift(fft(amplified_noise));
%     
%     snr(i) = 10*log(sum(abs(Y))/sum(abs(N)));
% end

% figure;
% plot(snr, siib_x);
% hold on;
% plot(snr, siib_y);
% plot(snr, siib_e);
% title('SIIB for different SNR');
% xlabel('SNR [dB]');
% ylabel('SIIB [bits/s]');
% legend('Original', 'Improved', 'Extra Amplified');

figure;
plot(amplification, siib);






