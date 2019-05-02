function [TF, fc] = FF2ED

% Free field to eardrum transfer function at the 1/3 oct frequencies
% between 160 Hz and 8000Hz, inclusive. (From Table 3)

TF = [0 0.50 1.00 1.40 1.50 1.80 2.40 3.10 2.60 3.00 6.10 12.00 16.80 15.00 14.30 10.70 6.40 1.80];
fc = [160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000];