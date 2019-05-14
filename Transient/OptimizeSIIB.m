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
bands = linspace(20, 900, 100);
bar = waitbar(0,'Decomposing Transients');
for i = 1:length(bands)
    waitbar((i/length(bands)), bar, 'Decomposing Transients');
    trans(i,:) = transient_process (x, fs, bands(i));
end
delete(bar);

bar = waitbar(0,'Calculating SIIB');
for i = 1:length(amplification)
    waitbar((i/length(amplification)), bar, 'Calculating SIIB');
    
    for j = 1:length(bands)
        y = transient_amplify(x, transpose(trans(j,:)), amplification(i));
        siib_y(j,i) = SIIB_Gauss(y, y+noise, fs);
    end
end
delete(bar);

figure;
plot(amplification, siib_y(1,:), 'DisplayName', num2str(bands(1)));
hold on;
for i = 2:length(bands)
    plot(amplification, siib_y(i,:), 'DisplayName', num2str(bands(i)));
end
title('SIIB TF-Decomposed');
xlabel('Transient Amplification');
ylabel('SIIB [b/s]');
legend show;


figure;
waterfall(amplification, bands, siib_y)
xlabel('Transient Amplification');
ylabel('Filter Bandwidth [Hz]');
zlabel('SIIB [bits/s]');




