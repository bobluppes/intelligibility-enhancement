clear all;
close all;

% Load audio signal
[original,Fs] = audioread('../Sounds/maleVoice.wav');
[train, Fst] = audioread('../Sounds/Train-noise.wav');
Fn = Fs/2;
n = length(original);

train = resample(train, Fs, Fst);
train = train(:,1);
m = length(train);
train = [train; zeros((n-m), 1)];
train = train .* 0.9;

O = fft(original);
O = fftshift(O);

[hps, hpf] = highpass(original,700,Fs,'Steepness',0.95);
H = fft(hps);
H = fftshift(H);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

%fvtool(hpf);

figure;
subplot(2,2,1);
plot(original);
title('malevoice.wav');

subplot(2,2,2);
plot(hps);
title('hps');

subplot(2,2,3);
plot(f,abs(O));
title('frequency spectrum');
xlim([0 4000]);

subplot(2,2,4);
plot(f,abs(H));
title('frequency spectrum hps');
xlim([0 4000]);

%Hfit = abs(H);
%freq = fit(transpose(f),Hfit,'cubicinterp');
%freq = freq(0:4000);
%freq = smoothdata(freq, 'movmedian', 800);

q1 = bandpass(hps, [710 1500], Fs);
q2 = bandpass(hps, [2200 2900], Fs);
q3 = bandpass(hps, [3400 3900], Fs);

trans = hps - q1 - q2 - q3;
trans = trans .* 20;
improved = original + trans;

I = fft(improved);
I = fftshift(I);

% Normalize the improved signal power
Po = sum(abs(O));
Pi = sum(abs(I));
a = Po / Pi;
improved = improved .* a;

I = fft(improved);
I = fftshift(I);

figure;
subplot(2,1,1);
plot(improved, 'm');
hold on;
plot(original, 'b');
xlim([2.655e5 2.95e5]);
title('Transient Enhanced Speech Signal');
xlabel('Time [s]');
ylabel('Amplitude');
legend('Enhanced speech', 'Original speech');

subplot(2,1,2);
plot(f, abs(O), 'b');
hold on;
plot(f, abs(I), 'm');
title('Frequency spectrum');
xlim([0 4000]);
xlabel('Frequency [Hz]');
ylabel('Amplitude');

% Near-end noise
improved = improved + train;
%original = original + train;

sound(improved, Fs);
