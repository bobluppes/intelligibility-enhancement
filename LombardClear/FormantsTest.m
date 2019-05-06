clear all;
close all;

% Load audio signal
[original,Fs] = audioread('Sounds/clean_speech.wav');
[train, Fst] = audioread('Sounds/Train-noise.wav');
Fn = Fs/2;
n = length(original);

scope = dsp.SpectrumAnalyzer;
scope.SampleRate = Fs;
scope.PlotAsTwoSidedSpectrum = false;
scope.PowerUnits = 'dBW';
scope.ChannelNames = {'f0','f1', 'f2', 'f3'};
scope.ShowLegend = true;

for i = 0:10
    int = round(length(original)/11);
    x = original(i*int+1:(i+1)*int);
    
    [f0, f1, f2, f3] = formants(x, Fs, 450);
    
    for j = 1:length(x)
       scope([f0(j), f1(j), f2(j), f3(j)]); 
    end
end
