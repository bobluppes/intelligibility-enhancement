clear all;
close all

% Load audio signal
[x,fs] = audioread('maleVoice.wav');
n = length(x);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*fs/(2*pi);
oldrandnoise = randn(n, 1);
Po = sqrt(sum(oldrandnoise.^2));

[y, fs2] = audioread('clean_speech.wav');
y = resample(y, fs2, fs);
y = y(10000:length(y));
y = y(1:n);
ssn = oldrandnoise .* y;
Pn = sqrt(sum(ssn.^2));
ssn = (Po/Pn) * ssn;


randnoise = [];
for i = 1:length(oldrandnoise)
    randnoise(i) = sin(1/5000) * oldrandnoise(i);
end
randnoise = randnoise';
Pn = sqrt(sum(randnoise.^2));
randnoise = (Po/Pn) .* randnoise;
randnoise = y;
Py = sqrt(sum(randnoise.^2));
randnoise = (Po/Py) * randnoise;

trans = transient_process(x, fs, 505);
transient_enhanced = transient_amplify(x, trans, 10);
filter = Transient_static(transient_enhanced, x);

siib_original = [];
siib_enhanced = [];
snr = [];
G = [];
noiseamp = logspace(log10(0.01), log10(0.15), 20);
for i = 1:length(noiseamp)
    noise = noiseamp(i) * randnoise;

    enhanced = Controller(x, filter, noise, fs);
    G(i) = SIIB_Gain(enhanced, noise, fs, 150);
    enhanced = G(i).*enhanced;
    
    snr(i) = 10*log10((sqrt(sum(x.^2))) / (sqrt(sum(noise.^2))));
    
    siib_original(i) = SIIB_Gauss(x, x+noise, fs);
    siib_enhanced(i) = SIIB_Gauss(enhanced, enhanced+noise, fs);
end

figure;
plot(snr, siib_original);
hold on;
plot(snr, siib_enhanced);

yyaxis right;
ylim([0 15]);
plot(snr, G);
ylabel('Gain');
yyaxis left;

yl = ylim;
line([-2.55 -2.55], [yl(1) yl(2)], 'Color', 'green', 'LineStyle', '--');
line([-1.84 -1.84], [yl(1) yl(2)], 'Color', 'green', 'LineStyle', '--');
line([2.32 2.32], [yl(1) yl(2)], 'Color', 'green', 'LineStyle', '--');
xlabel('SNR [dB]');
ylabel('SIIB^{Gauss} [bits/s]');
legend('Original', 'Enhanced');

