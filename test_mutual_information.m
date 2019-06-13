close all
clear all

[x,fs] = audioread('clean_speech.wav');

stretch = linspace(1.05,1.45,8);
stretched = [];
siib = [];
for i = 1:length(stretch)
    stretched = Lombard(x, fs,0, stretch(i),0,0);   
    n = length(stretched)-length(x);
    siib(i) = SIIB_Gauss([x;zeros(n,1)], stretched, fs);
end
figure
plot(stretch, siib)
xlabel('Vowel stretch factor');ylabel('SIIB [bits/s]');

