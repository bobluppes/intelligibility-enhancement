close all
clear all

[x,fs] = audioread('clean_speech.wav');

amplification = linspace(0,20,20);
amplified = [];
siib = [];
y = transient_process (x, fs, 505);
for i = 1:length(amplification)
    amplified = transient_amplify(x, y, amplification(i)); 
    siib(i) = SIIB_Gauss(x, amplified, fs);
end
figure
plot(amplification, siib)
xlabel('Transient amplification');ylabel('SIIB [bits/s]');

