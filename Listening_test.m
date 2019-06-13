clear all;
close all

[x,fs] = audioread('maleVoice.wav');
noise = randn(length(x), 1);


ext = linspace(1, 3, 20);

mod = [];
siib_lombard = [];
prompt = {'Bob', 'Ellen'};
for i = 1:length(ext)
    Il = Lombard(x, fs, 0, ext(i), 0, 10);
    noise = 0.07*randn(length(Il), 1);
    ext(i)
    siib_lombard(i) = SIIB_Gauss(Il, Il+noise, fs)
    soundsc(Il + noise, fs);
    pause;
    if (i ~= 0)
        duration = length(Il)/fs;
        answer = inputdlg(prompt);
        mod(i) = (str2num(answer{1})/duration + str2num(answer{2})/duration)/2;
    end
end
