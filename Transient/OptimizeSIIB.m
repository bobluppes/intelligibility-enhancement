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

noise = [n; zeros((length(x)-length(n)), 1)] .* 0.4;

siib_y = [];
amplification = linspace(0, 20, 40);
bands = [216 900];
bar = waitbar(0,'Decomposing Transients');
for i = 1:length(bands)
    waitbar((i/length(bands)), bar, 'Decomposing Transients');
    trans(i,:) = transient_process (x, fs, bands(i));
end
delete(bar);

bar = waitbar(0,'Calculating SIIB');
for i = 1:length(amplification)
    waitbar((i/length(amplification)), bar, 'Calculating SIIB');
    
    for j = 1:1
        y = transient_amplify(x, transpose(trans(j,:)), amplification(i));
        stoi_y(j,i) = stoi(y, y+noise, fs);
        siib_y(j,i) = SIIB_Gauss(y, y+noise, fs);
    end
end
delete(bar);

% figure;
% plot(amplification, siib_y(1,:), 'DisplayName', num2str(bands(1)));
% hold on;
% for i = 2:length(bands)
%     plot(amplification, siib_y(i,:), 'DisplayName', num2str(bands(i)));
% end
% title('SIIB TF-Decomposed');
% xlabel('Transient Amplification');
% ylabel('SIIB [b/s]');
% legend show;


figure;
%amplification = linspace(0, 20, 100);
%subplot(2,1,1);
%surf(amplification, bands, siib_y);
plot(amplification, siib_y(1,:);
hold on;
plot(amplification, siib_y(2,:);

amplification = linspace(0, 20, 25);
subplot(2,1,2);
surf(amplification, bands, siib_y .* 50);
xlabel('Transient Amplification');
ylabel('Filter Bandwidth [Hz]');
zlabel('SIIB [bits/s]');

figure;
plot(amplification, siib_y(:,23));




