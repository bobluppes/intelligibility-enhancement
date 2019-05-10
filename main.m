% audio input
% noise input 

clear all;
close all;

% Load audio signal
[original,Fs] = audioread('Sounds/maleVoice.wav');

improved = Transient(original, Fs, 5);

sound(improved, Fs);

