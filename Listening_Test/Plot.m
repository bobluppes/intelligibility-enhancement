clear all;
close all;

load('RESULTS.mat');

stretch = linspace(1, 3, 20);
tilt = linspace(0, 1, 20);
compression = linspace(0, 30, 20);
alphabet = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T'];

% INPUT
% for i = 1:20
%     prompt = alphabet(i);
%     LL(i) = LL(i) + input(prompt);
% end

% NORMALIZE
Lombard_NF = (LA + LG) .* (1/14)*100;
Tilt_NF = (LB + LH) .* (1/15)*100;
Compress_NF = (LC + LI) .* (1/15)*100;
Lombard_F = (LD + LJ) .* (1/13)*100;
Tilt_F = (LE + LK) .* (1/13)*100;
Compress_F = (LF + LL) .* (1/13)*100;

%PLOT
figure;

subplot(2,1,1);
plot(stretch, Lombard_NF);
title('Non-fluctuating noise');
xlabel('Vowel stretch factor'); ylabel('Words recognized [%]')

subplot(2,1,2);
plot(stretch, Lombard_F);
title('Fluctuating noise');
xlabel('Vowel stretch factor'); ylabel('Words recognized [%]')

figure
subplot(2,1,1);
plot(tilt, Tilt_NF);
title('Non-fluctuating noise');
xlabel('Filter coefficient'); ylabel('Words recognized [%]')

subplot(2,1,2);
plot(tilt, Tilt_F);
title('Fluctuating noise');
xlabel('Filter coefficient'); ylabel('Words recognized [%]')

figure
subplot(2,1,1);
plot(compression, Compress_NF);
title('Non-fluctuating noise');
xlabel('Threshold [dB]'); ylabel('Words recognized [%]')

subplot(2,1,2);
plot(compression, Compress_F);
title('Fluctuating noise');
xlabel('Threshold [dB]'); ylabel('Words recognized [%]')
