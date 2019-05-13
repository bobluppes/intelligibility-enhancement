clear all;
close all;

% Load audio signal
[x,fs] = audioread('Sounds/maleVoice.wav');
[n, fst] = audioread('Sounds/Train-noise.wav');

n = resample(n, fs, fst);
n = n(:,1);

% noise = [];
% for i = 1:10
%     amp = i/10;
%     noise(:,i) = [n; zeros((length(x)-length(n)), 1)] .* amp;
% end

noise = [n; zeros((length(x)-length(n)), 1)] .* 0.9;

siib_y = [];
amplification = linspace(8, 15, 25);
trans = transient_process (x, fs);
for i = 1:length(amplification)
    y = transient_amplify(x, trans, amplification(i));
    siib_y(i) = SIIB_Gauss(y, y+noise, fs);
end

figure;
plot(amplification, siib_y);

