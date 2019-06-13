clear all;
close all

% Load audio signal
[x,fs] = audioread('iua.wav');
noise = 0.08*randn(length(x), 1);
n = length(x);
x = x(:,1);
x = spectral_tilt(x, 0.9);

stft(x,fs,'Window',kaiser(80,5),'OverlapLength',79,'FFTLength',80);
ylim([0 4]);
xlabel('Time [s]');
ylabel('Frequency [Hz]');
title('');


return;

g = SIIB_Gain(x, noise, fs, 120);

SIIB_Gauss(g*x, g*x+noise, fs)

return;

t = linspace(0, n/fs, n);
amp = linspace(0.01, 0.1, 10);

siib = [];
siib_old = [];
snr = [];
for i = 1:length(amp)
    Is = sii_opt(x, noise*amp(i), fs);
    siib(i) = SIIB_Gauss(Is, Is+noise*amp(i), fs);
    siib_old(i) = SIIB_Gauss(x, x+noise*amp(i), fs);
    snr(i) = 10*log(sum(abs(fftshift(fft(Is)))) / sum(abs(fftshift(fft(noise*amp(i))))));
end

figure;
plot(snr, siib_old);
hold on;
plot(snr, siib);
title('SIIB\_Opt vs SNR');
xlabel('SNR [dB]');
ylabel('SIIB\_Gauss [bits/s]');
legend('Original', 'SIIB\_Opt');

return;

figure;
plot(t, Is);
hold on;
plot(t, x);
title('SIIB\_Gauss Optimized');
xlabel('Time [s]');
ylabel('Amplitude');
legend('SIIB\_Opt', 'Original');

return;




It = Transient(x, fs);

X = fftshift(fft(x));
T = fftshift(fft(It));

t = linspace(0, n/fs, n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*fs/(2*pi);

figure;
subplot(2,1,1);
plot(f, abs(X));
title('Spectrum Original');
xlabel('Frequency [Hz]');
ylabel('Amplitude');
subplot(2,1,2);
plot(f, abs(T));
title('Spectrum Transient Amplified');
xlabel('Frequency [Hz]');
ylabel('Amplitude');

figure;
subplot(2,1,1);
title('Original');
xlabel('Time [s]');
ylabel('Amplitude');
plot(t,x);
subplot(2,1,2);
title('Transient Amplified');
xlabel('Time [s]');
ylabel('Amplitude');
plot(t,It);

return;

% SIIB original
% siib_original = SIIB_Gauss(original, original+noise, Fs);
% 
% %% SIIB optimization
% Is = sii_opt(original, noise, Fs);
% siib_sii_opt = SIIB_Gauss(Is, Is+noise, Fs);


%% Lombard
% siib_lombard = [];
% tilt = linspace(0,1,20);
% for i = 1:length(tilt)
%     Il = Lombard(original, Fs, 0, 0.5, tilt(i));
%     noise_lombard = train1(1:length(Il));
%     siib_lombard(i) = SIIB_Gauss(Il, Il+noise_lombard, Fs);
% end

ext = linspace(1, 3, 20);

mod = [];
siib_lombard = [];
prompt = {'Bob', 'Ellen'};
for i = 1:length(ext)
    Il = Lombard(x, fs, 0, ext(i), 0, 10);
    noise = 0.07*randn(length(Il), 1);
    ext(i)
    siib_lombard(i) = SIIB_Gauss(Il, Il+noise, fs)
    soundsc(Il + noise, fs);
    pause;
    if (i ~= 0)
        duration = length(Il)/fs;
        answer = inputdlg(prompt);
        mod(i) = (str2num(answer{1})/duration + str2num(answer{2})/duration)/2;
    end
end

return;

imp = [];
imp(1) = mod(1);
for i = 2:length(mod)
    imp(i) = mod(i)+imp(i-1);
end

figure;
plot(ext, mod*50);
hold on;
plot(ext, siib_lombard);
title('Listening test vowel extension');
xlabel('Vowel Extension');
ylabel('Intelligibility');
legend('Listening Test', 'SIIB');



%% Transient
It = Transient(original, Fs);
siib_transient = SIIB_Gauss(It, It+noise, Fs);

%% Plot 
figure
plot(abs(fftshift(fft(Il))))
figure
plot(original)
hold on
plot(Il)
% figure;
% plot(tilt, siib_lombard);
% title('SIIB flattening spectral tilt');
% xlabel('Filter coefficient');ylabel('SIIB [bits/s]')