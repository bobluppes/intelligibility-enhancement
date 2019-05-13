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
amplification = linspace(0, 20, 100);
bands = [20 50 100 200 300 400 500 600 700];
for i = 1:9
    trans(i,:) = transient_process (x, fs, bands(i));
end

for i = 1:length(amplification)
    amplification(i)
    
    for j = 1:9
        y(j,:) = transient_amplify(x, transpose(trans(j,:)), amplification(i));
        siib_y(j,i) = SIIB_Gauss(transpose(y(j,:)), transpose(y(j,:))+noise, fs);
    end
end

figure;
plot(amplification, siib_y(1,:));
hold on;
for i = 2:9
    plot(amplification, siib_y(i,:));
end
title('SIIB TF-Decomposed');
xlabel('Transient Amplification');
ylabel('SIIB [b/s]');
legend('300', '500', '700');

