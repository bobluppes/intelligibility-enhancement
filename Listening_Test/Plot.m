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
Lombard_NF = (LA + LG) .* (1/14);
Tilt_NF = (LB + LH) .* (1/15);
Compress_NF = (LC + LI) .* (1/15);
Lombard_F = (LD + LJ) .* (1/13);
Tilt_F = (LE + LK) .* (1/13);
Compress_F = (LF + LL) .* (1/13);

%PLOT
figure;

subplot(3,2,1);
plot(stretch, Lombard_NF);
title('Lombard NF');

subplot(3,2,2);
plot(tilt, Tilt_NF);
title('Tilt NF');

subplot(3,2,3);
plot(compression, Compress_NF);
title('Compression NF');

subplot(3,2,4);
plot(stretch, Lombard_F);
title('Lombard F');

subplot(3,2,5);
plot(tilt, Tilt_F);
title('Tilt F');

subplot(3,2,6);
plot(compression, Compress_F);
title('Compression F');
