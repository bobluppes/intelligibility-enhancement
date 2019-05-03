clear all;
close all;

% Load audio signal
[original,Fs] = audioread('Sounds/maleVoice.wav');
[train, Fst] = audioread('Sounds/Train-noise.wav');
Fn = Fs/2;
n = length(original);

scope = dsp.SpectrumAnalyzer;
scope.SampleRate = Fs;
scope.PlotAsTwoSidedSpectrum = false;
scope.RBWSource = 'Auto';
scope.PowerUnits = 'dBW';

for i = 1:length(original)
    scope(original(i));
end
